//
//  BlackHole.swift
//  Project_1_Universe
//
//  Created by Sasha on 22/01/2021.
//

import UIKit

class BlackHole {
    private var lifetime: TimeInterval
    private var mass: Int
    private var id: UUID
    
    init(mass: Int) {
        self.lifetime = 0.0
        self.mass = mass
        self.id = UUID()
    }
    
    
}

extension BlackHole: Handler {
    
    func handle(_ properties: UniversProperties) {
        self.lifetime += properties.realInterval
    }
    
}

extension BlackHole {
    
    var name: String {
        return "\(id)"
    }
    
    var image: UIImage {
        return #imageLiteral(resourceName: "BlackHole")
    }
    
}
