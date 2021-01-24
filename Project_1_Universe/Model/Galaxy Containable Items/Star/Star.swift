//
//  Star.swift
//  Project_1_Universe
//
//  Created by Sasha on 22/01/2021.
//

import UIKit

final class Star {
    
    private var type: StarType
    private var stageEvolution: StarStageEvolution
    private var lifetime: TimeInterval
    private var mass: Int
    private var temperature: Int
    private var radius: Int
    private var luminosity: Int
    private var id: UUID
    weak var starDelegate: StarDelegate?
    
    init() {
        let items = StarType.allCases
        let lastIndex = items.count - 1
        self.type = items[Int.random(in: 0...lastIndex)]
        self.stageEvolution = .young
        self.lifetime = 0.0
        self.mass = Int.random(in: 1...100)
        self.temperature = Int.random(in: 1...100)
        self.luminosity = Int.random(in: 1...100)
        self.radius = Int.random(in: 1...100)
        self.id = UUID()
        print("Star \(id), created")
    }
    
    deinit {
        print("Star \(id), destroyed")
    }
    
}

extension Star: Handler {
    
    func handle(_ properties: UniversProperties) {
        lifetime += properties.realInterval
        starEvolve(properties)
    }
    
}

private extension Star {
    
    func starEvolve(_ properties: UniversProperties) {
        
        guard Int(lifetime) % 60 != 0 else { return }
        
        let evolutionStage = Int(lifetime / 60)
            
        switch evolutionStage {
        case 1:
            self.stageEvolution = .old
        case 2:
            if mass > properties.massΒoundary && radius > properties.radiusBoundary {
                starDelegate?.starDidTransformInBlackHole()
            } else {
                self.stageEvolution = .degenerateDwarf
            }
        default:
            return
        }
    }
    
}

extension Star {
    
    var stageEvolutionDescription: String {
        stageEvolution.rawValue.uppercased()
    }
    
    func getID() -> UUID {
        return id
    }
    
    func getMass() -> Int {
        return self.mass
    }
    
    func getStageEvolution() -> StarStageEvolution {
        return stageEvolution
    }
    
    func getType() -> StarType {
        return type
    }
    
}

extension Star: Hashable {
    
    static func == (lhs: Star, rhs: Star) -> Bool {
        lhs.getMass() == rhs.getMass()
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}

extension Star: CustomStringConvertible {
    
    var description: String {
        return "ID: \(id)\nStage Evolution: \(stageEvolution)\nType: \(type)"
    }
    
}
