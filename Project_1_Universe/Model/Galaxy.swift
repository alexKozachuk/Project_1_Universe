//
//  Galaxy.swift
//  Project_1_Universe
//
//  Created by Sasha on 22/01/2021.
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

class Galaxy {
    
    private var lifetime: TimeInterval = 0.0
    private var type: GalaxyType
    private var starPlanetarySystems: [StarPlanetarySystem] = []
    private var blackHoles: [BlackHole] = []
    private var id: UUID
    
    weak var delegate: TrackerDelegate?
    
    init(id: UUID) {
        let items = GalaxyType.allCases
        let lastIndex = items.count - 1
        self.type = items[Int.random(in: 0...lastIndex)]
        self.id = id
        print("Galaxy \(id), created")
    }
    
    deinit {
        print("Galaxy \(id), destroyed")
    }
    
}

extension Galaxy: Handler {
    
    func handle(_ properties: UniversProperties) {
        
        self.lifetime += properties.realInterval
        
        let starPlanetarySystem = StarPlanetarySystem()
        starPlanetarySystem.starDelegate = self
        starPlanetarySystems.append(starPlanetarySystem)
        print("Star Planetary System Created")
        
        delegate?.trackerDidUpdate()
        
        starPlanetarySystems.forEach {
            $0.handle(properties)
        }
        
    }
    
}

extension Galaxy {
    
    func getBlackHoles() -> [BlackHole] {
        return blackHoles
    }
    
    func getType() -> GalaxyType {
        return type
    }
    
    func getLifeTime() -> TimeInterval {
        return lifetime
    }
    
    func getID() -> UUID {
        return id
    }
    
    func getMass() -> Int {
        if starPlanetarySystems.count == 0 {
            return 0
        } else {
            return starPlanetarySystems.reduce(0) { $0 + $1.getMass()}
        }
    }
    
    func getStarPlanetarySystems() -> [StarPlanetarySystem] {
        return starPlanetarySystems
    }
    
}

extension Galaxy {
    
    func collision(with galaxy: Galaxy) {
        var items = self.getStarPlanetarySystems() + galaxy.getStarPlanetarySystems()
        
        var lastIndex = items.count - 1
        let countDestroy = Int(Double(items.count) * 0.9)
        
        for _ in 0..<countDestroy {
            let randomIndex = Int.random(in: 0...lastIndex)
            let item = items.remove(at: randomIndex)
            lastIndex -= 1
        }
        self.blackHoles += galaxy.blackHoles
        self.starPlanetarySystems = items
    }
    
    static func + (left: Galaxy, right: Galaxy) -> Galaxy {
        let galaxy = left.getMass() > right.getMass() ? left : right
        let removedGalaxy = left.getMass() < right.getMass() ? left : right
        var items = left.starPlanetarySystems + right.starPlanetarySystems
        
        var lastIndex = items.count - 1
        let countDestroy = Int(Double(items.count) * 0.5)
        
        for _ in 0..<countDestroy {
            let randomIndex = Int.random(in: 0...lastIndex)
            let item = items.remove(at: randomIndex)
            lastIndex -= 1
        }
        
        galaxy.starPlanetarySystems = items
        return galaxy
    }
    
}

extension Galaxy: Hashable {
    
    static func == (lhs: Galaxy, rhs: Galaxy) -> Bool {
        lhs.getMass() == rhs.getMass()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(type)
        hasher.combine(id)
    }
    
}

extension Galaxy {
    
    var name: String {
        return "\(self.getID())"
    }
    
    var image: UIImage {
        return self.getType().image
    }
    
}

extension Galaxy: StarPlanetarySystemDelegate {
    
    func starInStarPlanetarySystemDidTransform(_ starPlanetarySystem: StarPlanetarySystem) {
        let id = starPlanetarySystem.getID()
        let blackHole = BlackHole(mass: starPlanetarySystem.getMass())
        self.blackHoles.append(blackHole)
        starPlanetarySystems.removeAll { $0.getID() == id}
        delegate?.trackerDidUpdate()
    }
    
}

