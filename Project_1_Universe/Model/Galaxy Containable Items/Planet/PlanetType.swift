//
//  PlanetType.swift
//  Project_1_Universe
//
//  Created by Sasha on 24/01/2021.
//

import UIKit

enum PlanetType: CaseIterable {
    case EarthType
    case GasGiant
    case IceGiant
    case Dwarf
    case Sattelite
    
    var image: UIImage {
        switch self {
        case .EarthType:
            return #imageLiteral(resourceName: "EarthTypePlanet")
        case .GasGiant:
            return #imageLiteral(resourceName: "GasGiantPlanet")
        case .IceGiant:
            return #imageLiteral(resourceName: "IceGiantPlanet")
        case .Dwarf:
            return #imageLiteral(resourceName: "DwarfPlanet")
        case .Sattelite:
            return #imageLiteral(resourceName: "DwarfPlanet")
        }
    }
}
