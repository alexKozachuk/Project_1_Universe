//
//  Storyboard.swift
//  Project_1_Universe
//
//  Created by Sasha on 22/01/2021.
//

import Foundation

import UIKit

enum Storyboard: String {
    case main
    
    var instance: UIStoryboard {
        return UIStoryboard(name: rawValue.capitalized, bundle: nil)
    }
    
    func viewController<T: UIViewController>(viewControllerTypes: T.Type) -> T {
        let storyboardID = String(describing: viewControllerTypes)
        return instance.instantiateViewController(withIdentifier: storyboardID) as! T
    }
    
}
