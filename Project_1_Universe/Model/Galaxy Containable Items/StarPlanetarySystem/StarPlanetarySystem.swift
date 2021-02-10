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
    private let id: UUID = UUID()
    
    weak var delegate: TrackerDelegate?
    weak var starDelegate: StarPlanetarySystemDelegate?
    private let planetFactory: PlanetFactory = RandomPlanetFactory()
    
    init(star: Star) {
        self.star = star
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
            let planet = planetFactory.createPlanet()
            planets.append(planet)
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.trackerDidUpdate()
            }
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

extension StarPlanetarySystem: TopImagePresentable {
    
    var title: String {
        return "\(id)"
    }
    
    var image: UIImage {
        return star.type.image
    }
    
    
}

extension StarPlanetarySystem: StarDelegate {
    
    func starDidTransformInBlackHole() {
        starDelegate?.starInStarPlanetarySystemDidTransform(self)
    }
    
}

extension StarPlanetarySystem: GalaxyContainable {
    
    func getMass() -> Int {
        if planets.count == 0 {
            return star.mass
        } else {
            let planetsMass = planets.reduce(0) { $0 + $1.getMass()}
            return star.mass + planetsMass
        }
    }
    
    func getID() -> UUID {
        return id
    }
    
}
