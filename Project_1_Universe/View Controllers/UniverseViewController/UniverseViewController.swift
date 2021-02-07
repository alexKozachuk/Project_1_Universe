//
//  ViewController.swift
//  Project_1_Universe
//
//  Created by Sasha on 22/01/2021.
//

import UIKit

final class UniverseViewController: UIViewController {

    
    @IBOutlet private weak var collectionView: UICollectionView!
    private var dataSource: UniverseDataSource?
    private var toggleTimerButton: UIBarButtonItem?
    private let pauseImage = UIImage(systemName: "pause")
    private let playImage = UIImage(systemName: "play")
    weak var coordinator: MainCoordinator?
    
    // MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUniverse()
        setupCollectionView()
        setupBarItems()
    }

}

// MARK: - Setup Methods

private extension UniverseViewController {
    
    func setupBarItems() {
        
        let toggleTimerButton = UIBarButtonItem(image: pauseImage, style: .done, target: self, action: #selector(toggleTimer))
        self.toggleTimerButton = toggleTimerButton
        
        let changeSpeedButton = UIBarButtonItem(title: "Speed", style: .done, target: self, action: #selector(changeSpeed))
        
        navigationItem.rightBarButtonItems = [toggleTimerButton, changeSpeedButton]
        navigationItem.title = "Universe"
    }
    
    func setupUniverse() {
        
        let properties = UniversProperties(massΒoundary: 40, radiusBoundary: 40, virtualInterval: 10.0)
        let universe = Universe(properties: properties)
        universe.delegate = self
        let dataSource = UniverseDataSource(universe: universe)
        self.dataSource = dataSource
        
    }
    
    func setupCollectionView() {
        
        collectionView.dataSource = self.dataSource
        collectionView.delegate = self
        collectionView.collectionViewLayout = makeLayout(itemsPerRow: 2)
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

// MARK: UICollectionViewDelegate

extension UniverseViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let dataSource = dataSource else { return }
        guard let cell = cell as? TopImageCollectionViewCell else { return }
        let item = dataSource.getItem(at: indexPath)
        cell.setup(with: item)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let dataSource = dataSource else { return }
        let item = dataSource.getItem(at: indexPath)
        coordinator?.presentGalaxyVC(with: item)
    }
    
}

// MARK: - TrackerDelegate

extension UniverseViewController: TrackerDelegate {
    
    func trackerDidRemove() {
        
    }
    
    func trackerDidUpdate() {
        collectionView.reloadData()
    }
    
}

// MARK: Bar Button Action Methods

private extension UniverseViewController {
    
    @objc func toggleTimer() {
        guard let dataSource = dataSource else { return }
        dataSource.universe.isPaused.toggle()
        let image = dataSource.universe.isPaused ? playImage : pauseImage
        toggleTimerButton?.image = image
    }
    
    @objc func changeSpeed() {
        guard let dataSource = dataSource else { return }
        let currentState = dataSource.universe.isPaused
        
        dataSource.universe.isPaused = true
        
        let speedActionSheet = UIAlertController(title: "Choose Speed", message: nil, preferredStyle: .actionSheet)
        
        let x2speedButton = UIAlertAction(title: "Speed x2", style: .default) { [weak self] _ in
            self?.dataSource?.universe.setVirtualTime(time: 5)
            self?.dataSource?.universe.isPaused = currentState
        }
        
        let x5speedButton = UIAlertAction(title: "Speed x5", style: .default) { [weak self] _ in
            self?.dataSource?.universe.setVirtualTime(time: 2)
            self?.dataSource?.universe.isPaused = currentState
        }
        
        let x10speedButton = UIAlertAction(title: "Speed x10", style: .default) { [weak self] _ in
            self?.dataSource?.universe.setVirtualTime(time: 1)
            self?.dataSource?.universe.isPaused = currentState
        }
        
        let x20speedButton = UIAlertAction(title: "Speed x20", style: .default) { [weak self] _ in
            self?.dataSource?.universe.setVirtualTime(time: 0.5)
            self?.dataSource?.universe.isPaused = currentState
        }
        
        let normalSpeedButton = UIAlertAction(title: "Normal", style: .default) { [weak self] _ in
            self?.dataSource?.universe.setVirtualTime(time: 10)
            self?.dataSource?.universe.isPaused = currentState
        }
        
        speedActionSheet.addAction(x2speedButton)
        speedActionSheet.addAction(x5speedButton)
        speedActionSheet.addAction(x10speedButton)
        speedActionSheet.addAction(x20speedButton)
        speedActionSheet.addAction(normalSpeedButton)
        
        present(speedActionSheet, animated: true)
        
    }
    
}
