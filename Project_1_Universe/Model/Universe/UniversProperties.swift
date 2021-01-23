//
//  UniversProperties.swift
//  Project_1_Universe
//
//  Created by Sasha on 22/01/2021.
//

import Foundation

struct UniversProperties {
    
    var realInterval: TimeInterval = 10
    var massΒoundary: Int
    var radiusBoundary: Int
    var virtualInterval: TimeInterval
    
    init(massΒoundary: Int, radiusBoundary: Int, virtualInterval: TimeInterval) {
        self.massΒoundary = massΒoundary
        self.radiusBoundary = radiusBoundary
        self.virtualInterval = virtualInterval
    }
}
