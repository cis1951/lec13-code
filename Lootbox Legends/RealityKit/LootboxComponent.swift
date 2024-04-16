//
//  LootboxComponent.swift
//  Lootbox Legends
//
//  Created by the CIS 1951 team on 4/15/24.
//

import Foundation
import RealityKit

struct LootboxComponent: Component {
    var tapsReceived: Int = 0 {
        didSet {
            lastUpdate = Date()
        }
    }
    
    let requiredTaps: Int
    
    var lastUpdate: Date?
}
