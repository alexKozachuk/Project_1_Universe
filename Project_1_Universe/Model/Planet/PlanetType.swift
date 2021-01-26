//
//  PlanetType.swift
//  Project_1_Universe
//
//  Created by Sasha on 24/01/2021.
//

import UIKit

enum PlanetType: CaseIterable {
    case earthType
    case gasGiant
    case iceGiant
    case dwarf
    case sattelite
    
    var image: UIImage {
        switch self {
        case .earthType:
            return #imageLiteral(resourceName: "EarthTypePlanet")
        case .gasGiant:
            return #imageLiteral(resourceName: "GasGiantPlanet")
        case .iceGiant:
            return #imageLiteral(resourceName: "IceGiantPlanet")
        case .dwarf:
            return #imageLiteral(resourceName: "DwarfPlanet")
        case .sattelite:
            return #imageLiteral(resourceName: "DwarfPlanet")
        }
    }
}
