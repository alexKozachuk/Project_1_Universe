//
//  BlackHole.swift
//  Project_1_Universe
//
//  Created by Sasha on 22/01/2021.
//

import UIKit

final class BlackHole {
    private var lifetime: TimeInterval = 0.0
    private var mass: Int
    private let id: UUID = UUID()
    
    init(mass: Int) {
        self.mass = mass
    }
    
    
}

extension BlackHole: Handler {
    
    func handle(_ properties: UniversProperties) {
        self.lifetime += properties.realInterval
    }
    
}

extension BlackHole: GalaxyContainable {
    
    func getMass() -> Int {
        return mass
    }
    
    func getID() -> UUID {
        return id
    }
    
}

extension BlackHole: TopImagePresentable {
    
    var title: String {
        return "\(id)"
    }
    
    var image: UIImage {
        return #imageLiteral(resourceName: "BlackHole")
    }
    
}
