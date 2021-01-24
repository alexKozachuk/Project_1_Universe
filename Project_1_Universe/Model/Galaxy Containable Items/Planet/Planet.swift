//
//  Planet.swift
//  Project_1_Universe
//
//  Created by Sasha on 22/01/2021.
//

import UIKit

final class Planet {
    
    private var type: PlanetType
    private var mass: Int
    private var temperature: Int
    private var radius: Int
    private var satellites: [Planet] = []
    private var lifetime: TimeInterval = 0.0
    private var id: UUID
    
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
            type = .Sattelite
        }
        
        print("Planet \(id), created")
    }
    
    deinit {
        delegate?.trackerDidRemove()
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
            return self.mass
        } else {
            let satellitesMass = satellites.reduce(0) { $0 + $1.mass }
            return self.mass + satellitesMass
        }
    }
    
    func getID() -> UUID {
        return id
    }
    
    func getSattelites() -> [Planet] {
        return satellites
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

extension Planet {
    
    var name: String {
        return "\(self.id)"
    }
    
    var image: UIImage {
        return self.type.image
    }
    
}
