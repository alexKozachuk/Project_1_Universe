//
//  Galaxy.swift
//  Project_1_Universe
//
//  Created by Sasha on 22/01/2021.
//

import UIKit

final class Galaxy {
    
    private(set) var lifetime: TimeInterval = 0.0
    private(set) var type: GalaxyType
    private(set) var starPlanetarySystems: [StarPlanetarySystem] = []
    private(set) var blackHoles: [BlackHole] = []
    private(set) var id: UUID
    
    weak var delegate: TrackerDelegate?
    
    init(id: UUID) {
        let items = GalaxyType.allCases
        let lastIndex = items.count - 1
        self.type = items[Int.random(in: 0...lastIndex)]
        self.id = id
        print("Galaxy \(id), created")
    }
    
    deinit {
        self.delegate?.trackerDidRemove()
        print("Galaxy \(id), destroyed")
    }
    
}

extension Galaxy: Handler {
    
    func handle(_ properties: UniversProperties) {
        self.lifetime += properties.realInterval
        
        createStarPlanetarySystem()
        
        starPlanetarySystems.forEach {
            $0.handle(properties)
        }
        
    }
    
}

private extension Galaxy {
    
    func createStarPlanetarySystem() {
        
        let starPlanetarySystem = StarPlanetarySystem()
        starPlanetarySystem.starDelegate = self
        starPlanetarySystems.append(starPlanetarySystem)
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.trackerDidUpdate()
        }
        
    }
    
}

extension Galaxy {
    
    func getMass() -> Int {
        if starPlanetarySystems.count == 0 {
            return 0
        } else {
            return starPlanetarySystems.reduce(0) { $0 + $1.getMass()}
        }
    }
    
}

extension Galaxy {
    
    func collision(with galaxy: Galaxy, destroyPercent: Double = 0.8) {
        var items = starPlanetarySystems + galaxy.starPlanetarySystems
        
        var lastIndex = items.count - 1
        let countDestroy = Int(Double(items.count) * destroyPercent)
        
        for _ in 0..<countDestroy {
            let randomIndex = Int.random(in: 0...lastIndex)
            items.remove(at: randomIndex)
            lastIndex -= 1
        }
        self.blackHoles += galaxy.blackHoles
        self.starPlanetarySystems = items
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

extension Galaxy: Comparable {
    
    static func < (lhs: Galaxy, rhs: Galaxy) -> Bool {
        lhs.getMass() < rhs.getMass()
    }
    
}

extension Galaxy {
    
    var name: String {
        return "\(id)"
    }
    
    var image: UIImage {
        return type.image
    }
    
}

extension Galaxy: StarPlanetarySystemDelegate {
    
    func starInStarPlanetarySystemDidTransform(_ starPlanetarySystem: StarPlanetarySystem) {
        let id = starPlanetarySystem.id
        let blackHole = BlackHole(mass: starPlanetarySystem.getMass())
        self.blackHoles.append(blackHole)
        starPlanetarySystems.removeAll { $0.id == id}
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.trackerDidUpdate()
        }
    }
    
}

