//
//  GalaxyFactory.swift
//  Project_1_Universe
//
//  Created by Sasha on 05/02/2021.
//

import Foundation

protocol GalaxyFactory {
    func createGalaxy(id: UUID) -> Galaxy
}
