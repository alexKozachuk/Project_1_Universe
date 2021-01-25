//
//  Universe.swift
//  Project_1_Universe
//
//  Created by Sasha on 22/01/2021.
//

import Foundation

final class Universe {
     
    private var galaxies: [UUID:Galaxy] = [:]
    private var timer: Timer?
    private var properties: UniversProperties
    private var lifetime: TimeInterval = 0.0
    
    weak var delegate: TrackerDelegate?
    
    init(properties: UniversProperties) {
        self.properties = properties
        runTime()
    }
    
    var isPaused: Bool = false {
        didSet {
            if isPaused {
                pauseTimer()
            } else {
                runTime()
            }
        }
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
       
        createGalaxy()
        checkColision()
    }
    
}

private extension Universe {
    
    func createGalaxy() {
        
        let uuid = UUID()
        let galaxy = Galaxy(id: uuid)
        galaxies[uuid] = galaxy
        
    }
    
    func checkColision() {
        
        if Int(lifetime) % 30 == 0 {
            var items = galaxies.filter { $0.value.lifetime > 180 }
            let count = items.count
            if count > 1 {
                
                guard let firstItem = items.randomElement() else { return }
                items[firstItem.key] = nil
                guard let secondItem = items.randomElement() else { return }
                
                guard let maxItem = [firstItem, secondItem].max (by:{ lhs, rhs in
                    lhs.value < rhs.value
                }) else { return }
                
                guard let minItem = [firstItem, secondItem].min (by:{ lhs, rhs in
                    lhs.value < rhs.value
                }) else { return }
                
                galaxies[maxItem.key]?.collision(with: minItem.value)
                galaxies[minItem.key] = nil
                
            }
            
        }
        
    }
    
}

extension Universe {
    
    func setVirtualTime(time: TimeInterval) {
        properties.virtualInterval = time
    }
    
    func getGalaxies() -> [Galaxy] {
        return Array(galaxies.values).sorted { first, second in
            first.lifetime > second.lifetime
        }
    }
    
    func runTime() {
        self.timer = Timer.scheduledTimer(timeInterval: properties.virtualInterval, target: self, selector: #selector(timerRequest), userInfo: nil, repeats: true)
    }
    
    func pauseTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
}
