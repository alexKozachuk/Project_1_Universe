//
//  StarPlanetarySystemViewController.swift
//  Project_1_Universe
//
//  Created by Sasha on 22/01/2021.
//

import UIKit

class StarPlanetarySystemViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var starImage: UIImageView!
    
    private let sectionInsets = UIEdgeInsets(top: 10.0,
                                             left: 10.0,
                                             bottom: 10.0,
                                             right: 10.0)
    private let itemsPerRow: CGFloat = 3
    private weak var starPlanetarySystem: StarPlanetarySystem?
    weak var coordinator: MainCoordinator?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if starPlanetarySystem == nil {
            coordinator?.popBack()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupStarView()
    }
    
    func setupStarPlanetarySystem(with starPlanetarySystem: StarPlanetarySystem) {
        self.starPlanetarySystem = starPlanetarySystem
        self.starPlanetarySystem?.delegate = self
    }
    
}

private extension StarPlanetarySystemViewController {
    
    func starPlanetarySystemDidDestroyed() {
        
        let ac = UIAlertController(title: "Houston we have a problem" , message: "The star planetary system was destroyed", preferredStyle: .alert)
        let applyAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.coordinator?.popBack(to: GalaxyViewController.self)
        }
        ac.addAction(applyAction)
        present(ac, animated: true)
        
    }
    
}

// MARK: - Setup Methods

private extension StarPlanetarySystemViewController {
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(type: TopImageCollectionViewCell.self)
    }
    
    func setupStarView() {
        guard let star = starPlanetarySystem?.getStar() else { return }
        textLabel.text = star.description
        starImage.image = star.getType().image
    }
    
}

// MARK: - UICollectionViewDataSource

extension StarPlanetarySystemViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let starPlanetarySystem = starPlanetarySystem else { return 0 }
        return starPlanetarySystem.getPlanets().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(with: TopImageCollectionViewCell.self, for: indexPath)
    }
    
    
}

extension StarPlanetarySystemViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let starPlanetarySystem = starPlanetarySystem else { return }
        guard let cell = cell as? TopImageCollectionViewCell else { return }
        let item = starPlanetarySystem.getPlanets()[indexPath.item]
        cell.title = item.name
        cell.image = item.image
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let starPlanetarySystem = starPlanetarySystem else { return }
        let item = starPlanetarySystem.getPlanets()[indexPath.item]
        coordinator?.presentPlanetVC(with: item)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension StarPlanetarySystemViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                          sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        return CGSize(width: widthPerItem, height: widthPerItem)
      }
      
    func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                          insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
      
    func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                          minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}

// MARK: - TrackerDelegate

extension StarPlanetarySystemViewController: TrackerDelegate {
    
    func trackerDidRemove() {
        starPlanetarySystemDidDestroyed()
    }
    
    func trackerDidUpdate() {
        collectionView.reloadData()
    }
    
}
