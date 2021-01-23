//
//  StarPlanetarySystemViewController.swift
//  Project_1_Universe
//
//  Created by Sasha on 22/01/2021.
//

import UIKit

class StarPlanetarySystemViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let sectionInsets = UIEdgeInsets(top: 10.0,
                                             left: 10.0,
                                             bottom: 10.0,
                                             right: 10.0)
    private let itemsPerRow: CGFloat = 3
    private weak var starPlanetarySystem: StarPlanetarySystem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    func setupStarPlanetarySystem(with starPlanetarySystem: StarPlanetarySystem) {
        self.starPlanetarySystem = starPlanetarySystem
        self.starPlanetarySystem?.delegate = self
    }
    
    func starPlanetarySystemDidDestroid() {
        navigationController?.popViewController(animated: true)
    }

}

// MARK: - Setup Methods

private extension StarPlanetarySystemViewController {
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(type: TopImageCollectionViewCell.self)
    }
    
}

// MARK: - UICollectionViewDataSource

extension StarPlanetarySystemViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let starPlanetarySystem = starPlanetarySystem else {
            starPlanetarySystemDidDestroid()
            return 0
        }
        return starPlanetarySystem.getPlanets().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(with: TopImageCollectionViewCell.self, for: indexPath)
    }
    
    
}

extension StarPlanetarySystemViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let starPlanetarySystem = starPlanetarySystem else {
            starPlanetarySystemDidDestroid()
            return
        }
        guard let cell = cell as? TopImageCollectionViewCell else { return }
        let item = starPlanetarySystem.getPlanets()[indexPath.item]
        cell.title = item.name
        cell.image = item.image
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let starPlanetarySystem = starPlanetarySystem else {
            starPlanetarySystemDidDestroid()
            return
        }
        let vc: PlanetViewController = .instantiate(from: .main)
        let item = starPlanetarySystem.getPlanets()[indexPath.item]
        vc.setupPlanet(with: item)
        navigationController?.pushViewController(vc, animated: true)
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

extension StarPlanetarySystemViewController: TrackerDelegate {
    
    func trackerDidUpdate() {
        collectionView.reloadData()
    }
    
}
