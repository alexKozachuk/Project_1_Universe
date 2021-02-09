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
    private(set) var galaxyObjects: [GalaxyContainable] = []
    private(set) var id: UUID
    
    weak var delegate: TrackerDelegate?
    private let starPlanetarySystemFactory: StarPlanetarySystemFactory = RandomStarPlanetarySystemFactory()
    private let blackHoleFactory: BlackHoleFactory = SimpleBlackHoleFactory()
    
    init(id: UUID, type: GalaxyType) {
        self.type = type
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
        
        galaxyObjects.forEach {
            $0.handle(properties)
        }
        
    }
    
}

private extension Galaxy {
    
    func createStarPlanetarySystem() {
        
        let starPlanetarySystem = starPlanetarySystemFactory.createStarPlanetarySystem()
        starPlanetarySystem.starDelegate = self
        galaxyObjects.append(starPlanetarySystem)
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.trackerDidUpdate()
        }
        
    }
    
}

extension Galaxy {
    
    func getMass() -> Int {
        if galaxyObjects.count == 0 {
            return 0
        } else {
            return galaxyObjects.reduce(0) { $0 + $1.getMass()}
        }
    }
    
}

extension Galaxy {
    
    func collision(with galaxy: Galaxy, destroyPercent: Double = 0.1) {
        var items = self.galaxyObjects + galaxy.galaxyObjects
        
        var lastIndex = items.count - 1
        let countDestroy = Int(Double(items.count) * destroyPercent)
        
        for _ in 0..<countDestroy {
            let randomIndex = Int.random(in: 0...lastIndex)
            items.remove(at: randomIndex)
            lastIndex -= 1
        }
        
        self.galaxyObjects = items
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
    
    func getStarPlanetarySystems() -> [StarPlanetarySystem] {
        galaxyObjects.compactMap { $0 as? StarPlanetarySystem }
    }
    
    func getBlackHoles() -> [BlackHole] {
        galaxyObjects.compactMap { $0 as? BlackHole }
    }
    
}

extension Galaxy: TopImagePresentable {
    
    var title: String {
        return "\(id)"
    }
    
    var image: UIImage {
        return type.image
    }
    
}

extension Galaxy: StarPlanetarySystemDelegate {
    
    func starInStarPlanetarySystemDidTransform(_ starPlanetarySystem: StarPlanetarySystem) {
        let id = starPlanetarySystem.id
        let blackHole = blackHoleFactory.createBlackHole(with: starPlanetarySystem)
        guard let index = galaxyObjects.firstIndex(where: { $0.getID() == id}) else { return }
        galaxyObjects[index] = blackHole
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.trackerDidUpdate()
        }
    }
    
}

