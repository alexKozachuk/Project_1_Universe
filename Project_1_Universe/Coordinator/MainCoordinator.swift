//
//  MainCoordinator.swift
//  Project_1_Universe
//
//  Created by Sasha on 24/01/2021.
//

import UIKit

class MainCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc: UniverseViewController = .instantiate(from: .main)
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func presentGalaxyVC(with galaxy: Galaxy) {
        let vc: GalaxyViewController = .instantiate(from: .main)
        vc.coordinator = self
        vc.setupGalaxy(with: galaxy)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func presentStarPlanetarySystemVC(with starPlanetarySystem: StarPlanetarySystem) {
        let vc: StarPlanetarySystemViewController = .instantiate(from: .main)
        vc.coordinator = self
        vc.setupStarPlanetarySystem(with: starPlanetarySystem)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func presentPlanetVC(with planet: Planet) {
        let vc: PlanetViewController = .instantiate(from: .main)
        vc.coordinator = self
        vc.setupPlanet(with: planet)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func popBack<T: UIViewController>(to controllerType: T.Type) {
        var viewControllers: [UIViewController] = self.navigationController.viewControllers
        viewControllers = viewControllers.reversed()
        if let vc = viewControllers.first(where: { $0.isKind(of: controllerType) }) {
            self.navigationController.popToViewController(vc, animated: true)
        }
    }
    
    func popBack() {
        navigationController.popViewController(animated: true)
    }
    
}
