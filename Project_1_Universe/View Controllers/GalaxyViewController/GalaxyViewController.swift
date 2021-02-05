//
//  GalaxyViewController.swift
//  Project_1_Universe
//
//  Created by Sasha on 22/01/2021.
//

import UIKit

final class GalaxyViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var dataSource: GalaxyDataSource!
    weak var coordinator: MainCoordinator?
    
    // MARK: - View controller lifecycle methods
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if dataSource.galaxy == nil {
            coordinator?.popBack()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupBarItems()
    }
    
    // MARK: - Setup View controller method

    func setupGalaxy(with galaxy: Galaxy) {
        let dataSource = GalaxyDataSource(galaxy: galaxy)
        galaxy.delegate = self
        self.dataSource = dataSource
    }
    
}
// MARK: - Helper methods

private extension GalaxyViewController {
    
    func galaxyDidDestroyed() {
        let ac = UIAlertController(title: "Houston we have a problem" , message: "The galaxy was destroyed", preferredStyle: .alert)
        let applyAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.coordinator?.popBack(to: UniverseViewController.self)
        }
        ac.addAction(applyAction)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(ac, animated: true)
        }
        
    }
    
}

// MARK: - Setup Methods

private extension GalaxyViewController {
    
    func setupBarItems() {
        navigationItem.title = "Galaxy"
    }
    
    func setupCollectionView() {
        collectionView.dataSource = dataSource
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

extension GalaxyViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? TopImageCollectionViewCell else { return }
        guard let item = dataSource.getItem(at: indexPath) else { return }
        cell.setup(with: item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 0 else { return }
        guard let galaxy = dataSource.galaxy else { return }
        let starPlanetarySystems = galaxy.getStarPlanetarySystems()
        let item = starPlanetarySystems[indexPath.item]
        coordinator?.presentStarPlanetarySystemVC(with: item)
    }
    
}

// MARK: - TrackerDelegate

extension GalaxyViewController: TrackerDelegate {
    
    func trackerDidUpdate() {
        collectionView?.reloadData()
    }
    
    func trackerDidRemove() {
        galaxyDidDestroyed()
        
    }
    
}

