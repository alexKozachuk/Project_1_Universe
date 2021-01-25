//
//  ViewController.swift
//  Project_1_Universe
//
//  Created by Sasha on 22/01/2021.
//

import UIKit

final class UniverseViewController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let sectionInsets = UIEdgeInsets(top: 10.0,
                                             left: 10.0,
                                             bottom: 10.0,
                                             right: 10.0)
    private let itemsPerRow: CGFloat = 2
    private var universe: Universe!
    private var toggleTimerButton: UIBarButtonItem?
    private let pauseImage = UIImage(systemName: "pause")
    private let playImage = UIImage(systemName: "play")
    
    weak var coordinator: MainCoordinator?
    
    // MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupUniverse()
        setupBarItems()
    }

}

// MARK: - Setup Methods

private extension UniverseViewController {
    
    func setupBarItems() {
        
        let toggleTimerButton = UIBarButtonItem(image: pauseImage, style: .done, target: self, action: #selector(toggleTimer))
        self.toggleTimerButton = toggleTimerButton
        
        let changeSpeedButton = UIBarButtonItem(title: "Speed", style: .done, target: self, action: #selector(changeSpeed))
        
        
        navigationItem.rightBarButtonItems = [changeSpeedButton, toggleTimerButton]
        navigationItem.title = "Universe"
    }
    
    func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(type: TopImageCollectionViewCell.self)
    }
    
    func setupUniverse() {
        
        let properties = UniversProperties(massΒoundary: 40, radiusBoundary: 40, virtualInterval: 10.0)
        universe = Universe(properties: properties)
        universe?.delegate = self
        
    }
    
}

// MARK: - UICollectionViewDataSource

extension UniverseViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        universe.getGalaxies().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(with: TopImageCollectionViewCell.self, for: indexPath)
    }
    
    
}

// MARK: UICollectionViewDelegate

extension UniverseViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? TopImageCollectionViewCell else { return }
        let item = universe.getGalaxies()[indexPath.item]
        cell.title = item.name
        cell.image = item.image
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = universe.getGalaxies()[indexPath.item]
        coordinator?.presentGalaxyVC(with: item)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension UniverseViewController: UICollectionViewDelegateFlowLayout {
    
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
        universe.isPaused.toggle()
        let image = universe.isPaused ? playImage : pauseImage
        toggleTimerButton?.image = image
    }
    
    @objc func changeSpeed() {
        let currentState = universe.isPaused
        
        universe.isPaused = true
        
        let speedActionSheet = UIAlertController(title: "Choose Speed", message: nil, preferredStyle: .actionSheet)
        
        let x2speedButton = UIAlertAction(title: "Speed x2", style: .default) { [weak self] _ in
            self?.universe.setVirtualTime(time: 5)
            self?.universe.isPaused = currentState
        }
        
        let x5speedButton = UIAlertAction(title: "Speed x5", style: .default) { [weak self] _ in
            self?.universe.setVirtualTime(time: 2)
            self?.universe.isPaused = currentState
        }
        
        let x10speedButton = UIAlertAction(title: "Speed x10", style: .default) { [weak self] _ in
            self?.universe.setVirtualTime(time: 1)
            self?.universe.isPaused = currentState
        }
        
        let x20speedButton = UIAlertAction(title: "Speed x20", style: .default) { [weak self] _ in
            self?.universe.setVirtualTime(time: 0.5)
            self?.universe.isPaused = currentState
        }
        
        let normalSpeedButton = UIAlertAction(title: "Normal", style: .default) { [weak self] _ in
            self?.universe.setVirtualTime(time: 1)
            self?.universe.isPaused = currentState
        }
        
        speedActionSheet.addAction(x2speedButton)
        speedActionSheet.addAction(x5speedButton)
        speedActionSheet.addAction(x10speedButton)
        speedActionSheet.addAction(x20speedButton)
        speedActionSheet.addAction(normalSpeedButton)
        
        present(speedActionSheet, animated: true)
        
    }
    
}
