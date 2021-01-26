//
//  StarType.swift
//  Project_1_Universe
//
//  Created by Sasha on 24/01/2021.
//

import UIKit

enum StarType: String, CaseIterable {
    case blueGiant
    case brownDwarf
    case redDwarf
    case redGiant
    case redSupergiant
    case whiteDwarf
    case yellowDwarf
    
    var image: UIImage {
        switch self {
        case .blueGiant:
            return #imageLiteral(resourceName: "BlueGiantStar")
        case .brownDwarf:
            return #imageLiteral(resourceName: "BrownDwarfStar")
        case .redDwarf:
            return #imageLiteral(resourceName: "RedDwarfStar")
        case .whiteDwarf:
            return #imageLiteral(resourceName: "WhiteDwarfStar")
        case .redGiant:
            return #imageLiteral(resourceName: "RedGiantStar")
        case .redSupergiant:
            return #imageLiteral(resourceName: "RedSupergiantStar")
        case .yellowDwarf:
            return #imageLiteral(resourceName: "ΥellowDwarfStar")
        }
    }
}
