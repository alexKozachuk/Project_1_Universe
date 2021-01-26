//
//  GalaxyViewController.swift
//  Project_1_Universe
//
//  Created by Sasha on 22/01/2021.
//

import UIKit

final class GalaxyViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let sectionInsets = UIEdgeInsets(top: 10.0,
                                             left: 10.0,
                                             bottom: 10.0,
                                             right: 10.0)
    private let itemsPerRow: CGFloat = 3
    private weak var galaxy: Galaxy?
    weak var coordinator: MainCoordinator?
    
    // MARK: - View controller lifecycle methods
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if galaxy == nil {
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
        self.galaxy = galaxy
        self.galaxy?.delegate = self
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
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(type: TopImageCollectionViewCell.self)
        let kind = UICollectionView.elementKindSectionHeader
        collectionView.register(type: HeaderCollectionReusableView.self, kind: kind)
    }
    
}

// MARK: - UICollectionViewDataSource

extension GalaxyViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let galaxy = galaxy else { return CGSize.zero }
        
        switch section {
        case 0:
            if galaxy.starPlanetarySystems.count == 0 {
                return CGSize.zero
            } else {
                return CGSize(width: 0, height: 40)
            }
        case 1:
            if galaxy.blackHoles.count == 0 {
                return CGSize.zero
            } else {
                return CGSize(width: 0, height: 40)
            }
        default:
            return CGSize.zero
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let galaxy = galaxy else { return 0 }
        if section == 0 {
            return galaxy.starPlanetarySystems.count
        } else {
            return galaxy.blackHoles.count
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

extension GalaxyViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let galaxy = galaxy else { return }
        guard let cell = cell as? TopImageCollectionViewCell else { return }
        if indexPath.section == 0 {
            if indexPath.item < galaxy.starPlanetarySystems.count {
                let item = galaxy.starPlanetarySystems[indexPath.item]
                cell.title = item.name
                cell.image = item.typeImage
            }
        } else {
            let item = galaxy.blackHoles[indexPath.item]
            cell.title = item.name
            cell.image = item.image
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section == 0 else { return }
        guard let galaxy = galaxy else { return }
        let item = galaxy.starPlanetarySystems[indexPath.item]
        coordinator?.presentStarPlanetarySystemVC(with: item)
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

// MARK: - TrackerDelegate

extension GalaxyViewController: TrackerDelegate {
    
    func trackerDidUpdate() {
        collectionView?.reloadData()
    }
    
    func trackerDidRemove() {
        galaxyDidDestroyed()
        
    }
    
}

