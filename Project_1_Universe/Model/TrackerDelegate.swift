//
//  TrackerDelegate.swift
//  Project_1_Universe
//
//  Created by Sasha on 22/01/2021.
//

import Foundation

protocol TrackerDelegate: class {
    func trackerDidUpdate()
    func trackerDidRemove()
}
