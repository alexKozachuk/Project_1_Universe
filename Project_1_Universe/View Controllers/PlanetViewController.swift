//
//  PlanetViewController.swift
//  Project_1_Universe
//
//  Created by Sasha on 22/01/2021.
//

import UIKit

final class PlanetViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let sectionInsets = UIEdgeInsets(top: 10.0,
                                             left: 10.0,
                                             bottom: 10.0,
                                             right: 10.0)
    private let itemsPerRow: CGFloat = 3
    private weak var planet: Planet?
    weak var coordinator: MainCoordinator?
    
    // MARK: - View controller lifecycle methods
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if planet == nil {
            coordinator?.popBack()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupBarItems()
    }
    
    func setupPlanet(with planet: Planet) {
        self.planet = planet
        self.planet?.delegate = self
    }

}

private extension PlanetViewController {
    
    func planetDidDestroyed() {
        
        let ac = UIAlertController(title: "Houston we have a problem" , message: "The planet was destroyed", preferredStyle: .alert)
        let applyAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.coordinator?.popBack(to: StarPlanetarySystemViewController.self)
        }
        ac.addAction(applyAction)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(ac, animated: true)
        }
        
    }
    
}

// MARK: - Setup Methods

private extension PlanetViewController {
    
    func setupBarItems() {
        navigationItem.title = "Planet"
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(type: TopImageCollectionViewCell.self)
        let kind = UICollectionView.elementKindSectionHeader
        collectionView.register(type: HeaderCollectionReusableView.self, kind: kind)
    }
    
}

// MARK: - UICollectionViewDataSource

extension PlanetViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let planet = planet else { return CGSize.zero }
        if planet.satellites.count == 0 {
            return CGSize.zero
        } else {
            return CGSize(width: 0, height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let planet = planet else { return 0 }
        return planet.satellites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(with: TopImageCollectionViewCell.self, for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerKind = UICollectionView.elementKindSectionHeader
        guard kind == headerKind else { return .init() }
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, with: HeaderCollectionReusableView.self, for: indexPath)
        headerView.title = "Satellites"
        return headerView
    }
    
    
}

extension PlanetViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let planet = planet else { return }
        guard let cell = cell as? TopImageCollectionViewCell else { return }
        let item = planet.satellites[indexPath.item]
        cell.title = item.name
        cell.image = item.image
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PlanetViewController: UICollectionViewDelegateFlowLayout {
    
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

extension PlanetViewController: TrackerDelegate {
    
    func trackerDidRemove() {
        planetDidDestroyed()
    }
    
    func trackerDidUpdate() {
        collectionView?.reloadData()
    }
    
}
