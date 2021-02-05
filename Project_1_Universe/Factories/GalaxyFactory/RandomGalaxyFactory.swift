//
//  RandomGalaxyFactory.swift
//  Project_1_Universe
//
//  Created by Sasha on 05/02/2021.
//

import Foundation

class RandomGalaxyFactory: GalaxyFactory {
    
    func createGalaxy(id: UUID) -> Galaxy {
        let items = GalaxyType.allCases
        let lastIndex = items.count - 1
        let type = items[Int.random(in: 0...lastIndex)]
        return Galaxy(id: id, type: type)
    }
    
}
