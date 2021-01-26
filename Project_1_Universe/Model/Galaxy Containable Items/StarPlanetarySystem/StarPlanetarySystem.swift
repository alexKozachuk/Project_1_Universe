//
//  StarPlanetarySystem.swift
//  Project_1_Universe
//
//  Created by Sasha on 22/01/2021.
//

import UIKit

final class StarPlanetarySystem {
    
    private(set) var star: Star
    private(set) var lifetime: TimeInterval = 0.0
    private(set) var planets: [Planet] = []
    private(set) var id: UUID
    
    weak var delegate: TrackerDelegate?
    weak var starDelegate: StarPlanetarySystemDelegate?
    
    init() {
        self.star = Star()
        self.id = UUID()
        star.starDelegate = self
        print("StarPlanetarySystem \(id), created")
    }
    
    deinit {
        self.delegate?.trackerDidRemove()
        print("StarPlanetarySystem \(id), destroyed")
    }
    
}

extension StarPlanetarySystem: Handler {
    
    func handle(_ properties: UniversProperties) {
        self.lifetime += properties.realInterval
        createPlanet()
        planets.forEach {
            $0.handle(properties)
        }
        star.handle(properties)
    }
    
}

private extension StarPlanetarySystem {
    
    func createPlanet() {
        
        if planets.count < 9 {
            let planet = Planet()
            planets.append(planet)
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.trackerDidUpdate()
            }
        }
        
    }
    
}

extension StarPlanetarySystem {
    
    func getMass() -> Int {
        if planets.count == 0 {
            return star.mass
        } else {
            let planetsMass = planets.reduce(0) { $0 + $1.getMass()}
            return star.mass + planetsMass
        }
    }
    
}

extension StarPlanetarySystem: Hashable {
    
    static func == (lhs: StarPlanetarySystem, rhs: StarPlanetarySystem) -> Bool {
        lhs.getMass() == rhs.getMass()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}

extension StarPlanetarySystem {
    
    var name: String {
        return "\(id)"
    }
    
    var typeImage: UIImage {
        return star.type.image
    }
    
    
}

extension StarPlanetarySystem: StarDelegate {
    
    func starDidTransformInBlackHole() {
        starDelegate?.starInStarPlanetarySystemDidTransform(self)
    }
    
}
