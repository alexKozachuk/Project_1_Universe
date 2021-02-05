//
//  RandomStarFactory.swift
//  Project_1_Universe
//
//  Created by Sasha on 05/02/2021.
//

import Foundation

class RandomStarFactory: StarFactory {
    
    func createStar() -> Star {
        let items = StarType.allCases
        let lastIndex = items.count - 1
        let type = items[Int.random(in: 0...lastIndex)]
        let stageEvolution = StarStageEvolution.young
        let mass = Int.random(in: 1...100)
        let temperature = Int.random(in: 1...100)
        let luminosity = Int.random(in: 1...100)
        let radius = Int.random(in: 1...100)
        let id = UUID()
        return Star(type: type, stageEvolution: stageEvolution, mass: mass, temperature: temperature, radius: radius, luminosity: luminosity, id: id)
    }
    
}
