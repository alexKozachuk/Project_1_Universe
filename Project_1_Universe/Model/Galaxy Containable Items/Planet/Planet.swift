//
//  Planet.swift
//  Project_1_Universe
//
//  Created by Sasha on 22/01/2021.
//

import UIKit

final class Planet {
    
    private(set) var type: PlanetType
    private(set) var mass: Int
    private(set) var temperature: Int
    private(set) var radius: Int
    private(set) var satellites: [Planet] = []
    private(set) var lifetime: TimeInterval = 0.0
    private(set) var id: UUID
    
    weak var delegate: TrackerDelegate?
    
    init(hasSatellites: Bool = true) {
        
        self.mass = Int.random(in: 1...100)
        self.temperature = Int.random(in: 1...100)
        self.radius = Int.random(in: 1...100)
        self.id = UUID()
        
        if hasSatellites {
            
            let items = PlanetType.allCases
            let lastIndex = items.count - 2
            self.type = items[Int.random(in: 0...lastIndex)]
            
            for _ in 0...Int.random(in: 0...5) {
                let planet = Planet(hasSatellites: false)
                self.satellites.append(planet)
            }
        } else {
            type = .sattelite
        }
        
        print("Planet \(id), created")
    }
    
    deinit {
        self.delegate?.trackerDidRemove()
        print("Planet \(id), destroyed")
    }
    
}

extension Planet: Handler {
    
    func handle(_ properties: UniversProperties) {
        self.lifetime += properties.realInterval
        
        satellites.forEach {
            $0.handle(properties)
        }
        
    }
    
}

extension Planet {
    
    func getMass() -> Int {
        if satellites.count == 0 {
            return mass
        } else {
            let satellitesMass = satellites.reduce(0) { $0 + $1.mass }
            return mass + satellitesMass
        }
    }
    
}

extension Planet: Hashable {
    
    static func == (lhs: Planet, rhs: Planet) -> Bool {
        lhs.getMass() == rhs.getMass()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}

extension Planet: TopImagePresentable {
    
    var title: String {
        return "\(self.id)"
    }
    
    var image: UIImage {
        return self.type.image
    }
    
}
