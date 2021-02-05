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
    private let galaxyFactory: GalaxyFactory = RandomGalaxyFactory()
    
    weak var delegate: TrackerDelegate?
    
    init(properties: UniversProperties) {
        self.properties = properties
        self.isPaused = false
    }
    
    var isPaused: Bool {
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
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.trackerDidUpdate()
        }
        
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
        let galaxy = galaxyFactory.createGalaxy(id: uuid)
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
        
        let queue = DispatchQueue(label: "project.universe.timer.async", qos: .utility)
        queue.async { [weak self] in
            guard let self = self else { return }
            self.timer = Timer.scheduledTimer(timeInterval: self.properties.virtualInterval, target: self, selector: #selector(self.timerRequest), userInfo: nil, repeats: true)
            RunLoop.current.run()
        }
        
    }
    
    func pauseTimer() {
        self.timer?.invalidate()
        self.timer = nil
    }
    
}
