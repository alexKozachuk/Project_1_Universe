//
//  GalaxyType.swift
//  Project_1_Universe
//
//  Created by Sasha on 24/01/2021.
//

import UIKit

enum GalaxyType: String, CaseIterable {
    case Ε = "Elliptical"
    case S = "Spiral"
    case Irr = "Irregular"
    
    var image: UIImage {
        switch self {
        case .Ε:
            return #imageLiteral(resourceName: "Eliptical")
        case .S:
            return #imageLiteral(resourceName: "Spiral")
        case .Irr:
            return #imageLiteral(resourceName: "Irregular")
        }
    }
}
