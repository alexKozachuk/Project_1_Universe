//
//  StarPlanetarySystemDataSource.swift
//  Project_1_Universe
//
//  Created by Sasha on 26/01/2021.
//

import UIKit

class StarPlanetarySystemDataSource: NSObject, UICollectionViewDataSource {
    
    private(set) weak var starPlanetarySystem: StarPlanetarySystem?
    
    init(starPlanetarySystem: StarPlanetarySystem) {
        self.starPlanetarySystem = starPlanetarySystem
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let starPlanetarySystem = starPlanetarySystem else { return 0 }
        return starPlanetarySystem.planets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(with: TopImageCollectionViewCell.self, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerKind = UICollectionView.elementKindSectionHeader
        guard kind == headerKind else { return .init() }
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, with: HeaderCollectionReusableView.self, for: indexPath)
        headerView.title = "Planets"
        return headerView
    }
    
}
