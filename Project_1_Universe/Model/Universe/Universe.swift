//
//  Universe.swift
//  Project_1_Universe
//
//  Created by Sasha on 22/01/2021.
//

import Foundation

class Universe {
     
    private var galaxies: [UUID:Galaxy] = [:]
    private var timer: Timer?
    private var properties: UniversProperties
    private var lifetime: TimeInterval = 0.0
    
    weak var delegate: TrackerDelegate?
    
    init(properties: UniversProperties) {
        self.properties = properties
        self.timer = Timer.scheduledTimer(timeInterval: properties.virtualInterval, target: self, selector: #selector(timerRequest), userInfo: nil, repeats: true)
    }
    
    @objc private func timerRequest() {
        handle(properties)
        delegate?.trackerDidUpdate()
    }
    
}

extension Universe: Handler {
    
    func handle(_ properties: UniversProperties) {
        
        lifetime += properties.realInterval
        
        galaxies.values.forEach {
            $0.handle(properties)
        }
        
        let uuid = UUID()
        let galaxy = Galaxy(id: uuid)
        galaxies[uuid] = galaxy
        
        checkColision()
        
    }
    
    func checkColision() {
        
        if Int(lifetime) % 30 == 0 {
            var items = galaxies.filter { $0.value.getLifeTime() > 180 }
            let count = items.count
            if count > 1 {
                
                guard let firstItem = items.randomElement() else { return }
                items[firstItem.key] = nil
                guard let secondItem = items.randomElement() else { return }
                
                galaxies[secondItem.key]?.collision(with: secondItem.value)
                galaxies[firstItem.key] = nil
                //galaxies[firstItem.key]?.delegate?.trackerDidRemoved()
                
            }
            
        }
    }
    
}

extension Universe {
    
    func getGalaxies() -> [Galaxy] {
        return Array(galaxies.values).sorted { first, second in
            first.getLifeTime() > second.getLifeTime()
        }
    }
    
}
