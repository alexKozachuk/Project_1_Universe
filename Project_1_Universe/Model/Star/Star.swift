//
//  Star.swift
//  Project_1_Universe
//
//  Created by Sasha on 22/01/2021.
//

import UIKit

final class Star {
    
    private(set) var type: StarType
    private(set) var stageEvolution: StarStageEvolution
    private(set) var lifetime: TimeInterval = 0.0
    private(set) var mass: Int
    private(set) var temperature: Int
    private(set) var radius: Int
    private(set) var luminosity: Int
    private(set) var id: UUID
    weak var starDelegate: StarDelegate?
    
    init(type: StarType, stageEvolution: StarStageEvolution, mass: Int, temperature: Int, radius: Int, luminosity: Int, id: UUID) {
        self.type = type
        self.stageEvolution = stageEvolution
        self.mass = mass
        self.temperature = temperature
        self.radius = radius
        self.luminosity = luminosity
        self.id = id
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

extension Star: Hashable {
    
    static func == (lhs: Star, rhs: Star) -> Bool {
        lhs.mass == rhs.mass
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
