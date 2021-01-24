//
//  PlanetViewController.swift
//  Project_1_Universe
//
//  Created by Sasha on 22/01/2021.
//

import UIKit

class PlanetViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let sectionInsets = UIEdgeInsets(top: 10.0,
                                             left: 10.0,
                                             bottom: 10.0,
                                             right: 10.0)
    private let itemsPerRow: CGFloat = 3
    private weak var planet: Planet?
    weak var coordinator: MainCoordinator?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if planet == nil {
            coordinator?.popBack()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
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
        present(ac, animated: true)
        
    }
    
}

// MARK: - Setup Methods

private extension PlanetViewController {
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(type: TopImageCollectionViewCell.self)
    }
    
}

// MARK: - UICollectionViewDataSource

extension PlanetViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let planet = planet else { return 0 }
        return planet.getSattelites().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(with: TopImageCollectionViewCell.self, for: indexPath)
    }
    
    
}

extension PlanetViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let planet = planet else { return }
        guard let cell = cell as? TopImageCollectionViewCell else { return }
        let item = planet.getSattelites()[indexPath.item]
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

extension PlanetViewController: TrackerDelegate {
    
    func trackerDidRemove() {
        planetDidDestroyed()
    }
    
    func trackerDidUpdate() {
        collectionView.reloadData()
    }
    
}
