//
//  Coordinator.swift
//  Project_1_Universe
//
//  Created by Sasha on 24/01/2021.
//

import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
