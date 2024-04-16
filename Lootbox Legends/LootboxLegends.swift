//
//  LootboxLegends.swift
//  Lootbox Legends
//
//  Created by the CIS 1951 team on 4/15/24.
//

import UIKit
import SwiftUI

@main
struct LootboxLegends: App {
    init() {
        LootboxComponent.registerComponent()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
