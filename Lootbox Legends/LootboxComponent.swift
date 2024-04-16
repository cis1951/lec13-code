//
//  LootboxComponent.swift
//  Lootbox Legends
//
//  Created by the CIS 1951 team on 4/15/24.
//

import RealityKit

struct LootboxComponent: Component {
    var tapsReceived: Int
    var requiredTaps: Int
    
    mutating func tap() {
        tapsReceived += 1
    }
}
