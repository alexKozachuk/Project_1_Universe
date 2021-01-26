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
    private var dataSource: PlanetDataSource!
    weak var coordinator: MainCoordinator?
    
    // MARK: - View controller lifecycle methods
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if dataSource.planet == nil {
            coordinator?.popBack()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupBarItems()
    }
    
    func setupPlanet(with planet: Planet) {
        planet.delegate = self
        let dataSource = PlanetDataSource(planet: planet)
        self.dataSource = dataSource
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
        collectionView.dataSource = self.dataSource
        collectionView.delegate = self
        collectionView.register(type: TopImageCollectionViewCell.self)
        let kind = UICollectionView.elementKindSectionHeader
        collectionView.register(type: HeaderCollectionReusableView.self, kind: kind)
    }
    
}

extension PlanetViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let planet = dataSource.planet else { return CGSize.zero }
        if planet.satellites.count == 0 {
            return CGSize.zero
        } else {
            return CGSize(width: 0, height: 40)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let planet = dataSource.planet else { return }
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
