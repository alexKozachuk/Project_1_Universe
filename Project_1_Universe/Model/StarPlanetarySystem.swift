//
//  StarPlanetarySystem.swift
//  Project_1_Universe
//
//  Created by Sasha on 22/01/2021.
//

import UIKit

class StarPlanetarySystem {
    
    private var star: Star
    private var lifetime: TimeInterval = 0.0
    private var planets: [Planet] = []
    private var id: UUID
    
    weak var delegate: TrackerDelegate?
    weak var starDelegate: StarPlanetarySystemDelegate?
    
    init() {
        self.star = Star()
        self.id = UUID()
        star.starDelegate = self
        print("StarPlanetarySystem \(id), created")
    }
    
    deinit {
        print("StarPlanetarySystem \(id), destroyed")
    }
    
}

extension StarPlanetarySystem: Handler {
    
    func handle(_ properties: UniversProperties) {
        self.lifetime += properties.realInterval
    
        if planets.count < 9 {
            let planet = Planet()
            planets.append(planet)
            print("Planet Created")
        }
        
        delegate?.trackerDidUpdate()
        
        planets.forEach {
            $0.handle(properties)
        }
        star.handle(properties)
    }
    
}

extension StarPlanetarySystem {
    
    func getLifeTime() -> TimeInterval {
        return lifetime
    }
    
    func getMass() -> Int {
        if planets.count == 0 {
            return star.getMass()
        } else {
            let planetsMass = planets.reduce(0) { $0 + $1.getMass()}
            return star.getMass() + planetsMass
        }
    }
    
    func getID() -> UUID {
        return id
    }
    
    func getStar() -> Star {
        return star
    }
    
    func getPlanets() -> [Planet] {
        return planets
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
        return "\(self.getID())"
    }
    
    var typeImage: UIImage {
        return self.getStar().getType().image
    }
    
    var stageImage: UIImage {
        return self.getStar().getStageEvolution().image
    }
    
    
}

extension StarPlanetarySystem: StarDelegate {
    
    func starDidTransformInBlackHole() {
        starDelegate?.starInStarPlanetarySystemDidTransform(self)
    }
    
}
