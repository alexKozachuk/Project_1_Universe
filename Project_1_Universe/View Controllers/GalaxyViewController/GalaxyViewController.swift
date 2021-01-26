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
        collectionView.register(type: TopImageCollectionViewCell.self)
        let kind = UICollectionView.elementKindSectionHeader
        collectionView.register(type: HeaderCollectionReusableView.self, kind: kind)
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let galaxy = dataSource.galaxy else { return CGSize.zero }
        let starPlanetarySystems = galaxy.getStarPlanetarySystems()
        let blackHoles = galaxy.getBlackHoles()
        
        switch section {
        case 0:
            if starPlanetarySystems.count == 0 {
                return CGSize.zero
            } else {
                return CGSize(width: 0, height: 40)
            }
        case 1:
            if blackHoles.count == 0 {
                return CGSize.zero
            } else {
                return CGSize(width: 0, height: 40)
            }
        default:
            return CGSize.zero
        }
        
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

