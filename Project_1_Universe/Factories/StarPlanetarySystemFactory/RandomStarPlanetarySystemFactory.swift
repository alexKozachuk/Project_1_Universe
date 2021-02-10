//
//  RandomStarPlanetarySystemFactory.swift
//  Project_1_Universe
//
//  Created by Sasha on 05/02/2021.
//

import Foundation

class RandomStarPlanetarySystemFactory: StarPlanetarySystemFactory {
    
    private let starFactory: StarFactory = RandomStarFactory()
    
    func createStarPlanetarySystem() -> StarPlanetarySystem {
        
        let star = starFactory.createStar()
        let item = StarPlanetarySystem(star: star)
        star.starDelegate = item
        
        return item
    }
    
}
