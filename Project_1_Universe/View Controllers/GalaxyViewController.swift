//
//  GalaxyViewController.swift
//  Project_1_Universe
//
//  Created by Sasha on 22/01/2021.
//

import UIKit

class GalaxyViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let sectionInsets = UIEdgeInsets(top: 10.0,
                                             left: 10.0,
                                             bottom: 10.0,
                                             right: 10.0)
    private let itemsPerRow: CGFloat = 3
    private weak var galaxy: Galaxy?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }

    func setupGalaxy(with galaxy: Galaxy) {
        self.galaxy = galaxy
        self.galaxy?.delegate = self
    }
    
    func galaxyDidDestroid() {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - Setup Methods

private extension GalaxyViewController {
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(type: TopImageCollectionViewCell.self)
    }
    
}

// MARK: - UICollectionViewDataSource

extension GalaxyViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let galaxy = galaxy else {
            galaxyDidDestroid()
            return 0
        }
        if section == 0 {
            return galaxy.getStarPlanetarySystems().count
        } else {
            return galaxy.getBlackHoles().count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(with: TopImageCollectionViewCell.self, for: indexPath)
    }
    
    
}

extension GalaxyViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let galaxy = galaxy else {
            galaxyDidDestroid()
            return
        }
        guard let cell = cell as? TopImageCollectionViewCell else { return }
        if indexPath.section == 0 {
            let item = galaxy.getStarPlanetarySystems()[indexPath.item]
            cell.title = item.name
            cell.image = item.typeImage
        } else {
            let item = galaxy.getBlackHoles()[indexPath.item]
            cell.title = item.name
            cell.image = item.image
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let galaxy = galaxy else {
            galaxyDidDestroid()
            return
        }
        let vc: StarPlanetarySystemViewController = .instantiate(from: .main)
        let item = galaxy.getStarPlanetarySystems()[indexPath.item]
        vc.setupStarPlanetarySystem(with: item)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GalaxyViewController: UICollectionViewDelegateFlowLayout {
    
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

extension GalaxyViewController: TrackerDelegate {
    
    func trackerDidUpdate() {
        collectionView.reloadData()
    }
    
}

