//
//  GalaxyDataSource.swift
//  Project_1_Universe
//
//  Created by Sasha on 26/01/2021.
//

import UIKit

class GalaxyDataSource: NSObject, UICollectionViewDataSource {
    
    private(set) weak var galaxy: Galaxy?
    
    init(galaxy: Galaxy) {
        self.galaxy = galaxy
    }
    
    func getItem(at indexPath: IndexPath) -> GalaxyContainable? {
        guard let galaxy = galaxy else { return nil }
        if indexPath.section == 0 {
            let starPlanetarySystems = galaxy.getStarPlanetarySystems()
            guard indexPath.item < starPlanetarySystems.count else { return nil }
            return starPlanetarySystems[indexPath.item]
        } else {
            let blackHoles = galaxy.getBlackHoles()
            guard indexPath.item < blackHoles.count else { return nil }
            return blackHoles[indexPath.item]
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let galaxy = galaxy else { return 0 }
        if section == 0 {
            let starPlanetarySystems = galaxy.getStarPlanetarySystems()
            return starPlanetarySystems.count
        } else {
            let blackHoles = galaxy.getBlackHoles()
            return blackHoles.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(with: TopImageCollectionViewCell.self, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerKind = UICollectionView.elementKindSectionHeader
        guard kind == headerKind else { return .init() }
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, with: HeaderCollectionReusableView.self, for: indexPath)
        
        switch indexPath.section {
        case 0:
            headerView.title = "Star Planetary Systems"
        case 1:
            headerView.title = "Black Holes"
        default:
            break
        }
        
        return headerView
    }
    
}
