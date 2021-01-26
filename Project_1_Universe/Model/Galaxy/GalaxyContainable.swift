//
//  GalaxyContainable.swift
//  Project_1_Universe
//
//  Created by Sasha on 26/01/2021.
//

import Foundation

protocol GalaxyContainable: Handler, TopImagePresentable {
    
    func getMass() -> Int
    func getID() ->UUID
    
}
