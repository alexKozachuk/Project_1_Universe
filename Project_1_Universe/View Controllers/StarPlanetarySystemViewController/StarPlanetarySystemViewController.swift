//
//  StarPlanetarySystemViewController.swift
//  Project_1_Universe
//
//  Created by Sasha on 22/01/2021.
//

import UIKit

final class StarPlanetarySystemViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var starImage: UIImageView!
    
    private var dataSource: StarPlanetarySystemDataSource!
    weak var coordinator: MainCoordinator?
    
    // MARK: - View controller lifecycle methods
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if dataSource.starPlanetarySystem == nil {
            coordinator?.popBack()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupStarView()
        setupBarItems()
    }
    
    func setupStarPlanetarySystem(with starPlanetarySystem: StarPlanetarySystem) {
        starPlanetarySystem.delegate = self
        let dataSource = StarPlanetarySystemDataSource(starPlanetarySystem: starPlanetarySystem)
        self.dataSource = dataSource
    }
    
}

private extension StarPlanetarySystemViewController {
    
    func starPlanetarySystemDidDestroyed() {
        
        let ac = UIAlertController(title: "Houston we have a problem" , message: "The star planetary system was destroyed", preferredStyle: .alert)
        let applyAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.coordinator?.popBack(to: GalaxyViewController.self)
        }
        ac.addAction(applyAction)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(ac, animated: true)
        }
        
    }
    
}

// MARK: - Setup Methods

private extension StarPlanetarySystemViewController {
    
    func setupBarItems() {
        navigationItem.title = "Star Planetary System"
    }
    
    func setupCollectionView() {
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.collectionViewLayout = makeLayout(itemsPerRow: 3)
        collectionView.register(type: TopImageCollectionViewCell.self)
        let kind = UICollectionView.elementKindSectionHeader
        collectionView.register(type: HeaderCollectionReusableView.self, kind: kind)
    }
    
    func setupStarView() {
        guard let star = dataSource.starPlanetarySystem?.star else { return }
        textLabel.text = star.description
        starImage.image = star.type.image
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

extension StarPlanetarySystemViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let starPlanetarySystem = dataSource.starPlanetarySystem else { return }
        guard let cell = cell as? TopImageCollectionViewCell else { return }
        let item = starPlanetarySystem.planets[indexPath.item]
        cell.setup(with: item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let starPlanetarySystem = dataSource.starPlanetarySystem else { return }
        let item = starPlanetarySystem.planets[indexPath.item]
        coordinator?.presentPlanetVC(with: item)
    }
    
}

// MARK: - TrackerDelegate

extension StarPlanetarySystemViewController: TrackerDelegate {
    
    func trackerDidRemove() {
        starPlanetarySystemDidDestroyed()
    }
    
    func trackerDidUpdate() {
        collectionView?.reloadData()
    }
    
}
