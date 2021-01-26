//
//  StarPlanetarySystemViewController.swift
//  Project_1_Universe
//
//  Created by Sasha on 22/01/2021.
//

import UIKit

final class StarPlanetarySystemViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var starImage: UIImageView!
    
    private let sectionInsets = UIEdgeInsets(top: 10.0,
                                             left: 10.0,
                                             bottom: 10.0,
                                             right: 10.0)
    private let itemsPerRow: CGFloat = 3
    private var dataSource: StarPlanetarySystemDataSource!
    weak var coordinator: MainCoordinator?
    
    // MARK: - View controller lifecycle methods
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if dataSource.starPlanetarySystem == nil {
            coordinator?.popBack()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupStarView()
        setupBarItems()
    }
    
    func setupStarPlanetarySystem(with starPlanetarySystem: StarPlanetarySystem) {
        starPlanetarySystem.delegate = self
        let dataSource = StarPlanetarySystemDataSource(starPlanetarySystem: starPlanetarySystem)
        self.dataSource = dataSource
    }
    
}

private extension StarPlanetarySystemViewController {
    
    func starPlanetarySystemDidDestroyed() {
        
        let ac = UIAlertController(title: "Houston we have a problem" , message: "The star planetary system was destroyed", preferredStyle: .alert)
        let applyAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.coordinator?.popBack(to: GalaxyViewController.self)
        }
        ac.addAction(applyAction)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(ac, animated: true)
        }
        
    }
    
}

// MARK: - Setup Methods

private extension StarPlanetarySystemViewController {
    
    func setupBarItems() {
        navigationItem.title = "Star Planetary System"
    }
    
    func setupCollectionView() {
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.register(type: TopImageCollectionViewCell.self)
        let kind = UICollectionView.elementKindSectionHeader
        collectionView.register(type: HeaderCollectionReusableView.self, kind: kind)
    }
    
    func setupStarView() {
        guard let star = dataSource.starPlanetarySystem?.star else { return }
        textLabel.text = star.description
        starImage.image = star.type.image
    }
    
}

extension StarPlanetarySystemViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let starPlanetarySystem = dataSource.starPlanetarySystem else { return CGSize.zero }
        if starPlanetarySystem.planets.count == 0 {
            return CGSize.zero
        } else {
            return CGSize(width: 0, height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let starPlanetarySystem = dataSource.starPlanetarySystem else { return }
        guard let cell = cell as? TopImageCollectionViewCell else { return }
        let item = starPlanetarySystem.planets[indexPath.item]
        cell.title = item.name
        cell.image = item.image
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let starPlanetarySystem = dataSource.starPlanetarySystem else { return }
        let item = starPlanetarySystem.planets[indexPath.item]
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
        collectionView?.reloadData()
    }
    
}
