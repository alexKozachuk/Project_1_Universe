//
//  UniverseDataSource.swift
//  Project_1_Universe
//
//  Created by Sasha on 25/01/2021.
//

import UIKit

class UniverseDataSource: NSObject {
    
    private(set) var universe: Universe
    
    init(universe: Universe) {
        self.universe = universe
    }

}

extension UniverseDataSource: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        universe.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(with: TopImageCollectionViewCell.self, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerKind = UICollectionView.elementKindSectionHeader
        guard kind == headerKind else { return .init() }
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, with: HeaderCollectionReusableView.self, for: indexPath)
        headerView.title = "Galaxies"
        return headerView
    }
    
}

extension UniverseDataSource {
    
    func getItem(at indexPath: IndexPath) -> Galaxy {
        universe.getGalaxies()[indexPath.row]
    }
    
}

