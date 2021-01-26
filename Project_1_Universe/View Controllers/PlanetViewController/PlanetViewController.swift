//
//  PlanetViewController.swift
//  Project_1_Universe
//
//  Created by Sasha on 22/01/2021.
//

import UIKit

final class PlanetViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
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
        collectionView.collectionViewLayout = makeLayout(itemsPerRow: 3)
        collectionView.register(type: TopImageCollectionViewCell.self)
        let kind = UICollectionView.elementKindSectionHeader
        collectionView.register(type: HeaderCollectionReusableView.self, kind: kind)
    }
    
    func makeLayout(itemsPerRow: CGFloat) -> UICollectionViewFlowLayout {
        
        let sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        let layout = UICollectionViewFlowLayout()
        let paddingSpace = sectionInset.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow

        layout.itemSize = CGSize(width: widthPerItem, height: widthPerItem)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.headerReferenceSize = CGSize(width: 0, height: 40)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        return layout
    }
    
}

extension PlanetViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let planet = dataSource.planet else { return }
        guard let cell = cell as? TopImageCollectionViewCell else { return }
        let item = planet.satellites[indexPath.item]
        cell.setup(with: item)
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
