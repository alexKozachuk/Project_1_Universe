//
//  RandomPlanetFactory.swift
//  Project_1_Universe
//
//  Created by Sasha on 05/02/2021.
//

import Foundation

class RandomPlanetFactory: PlanetFactory {
    
    func createPlanet() -> Planet {
        let mass = Int.random(in: 1...100)
        let temperature = Int.random(in: 1...100)
        let radius = Int.random(in: 1...100)
        let id = UUID()
        var satellites: [Planet] = []
        
        let items = PlanetType.allCases
        let lastIndex = items.count - 2
        let type = items[Int.random(in: 0...lastIndex)]
        
        for _ in 0..<Int.random(in: 0...5) {
            let planet = createSatellite()
            satellites.append(planet)
        }
        
        return Planet(type: type, mass: mass, temperature: temperature, radius: radius, satellites: satellites, id: id)
    }
    
    private func createSatellite() -> Planet {
        let mass = Int.random(in: 1...50)
        let temperature = Int.random(in: 1...50)
        let radius = Int.random(in: 1...50)
        let id = UUID()
        let type = PlanetType.sattelite
        
        return Planet(type: type, mass: mass, temperature: temperature, radius: radius, satellites: [], id: id)
    }
    
    
}
