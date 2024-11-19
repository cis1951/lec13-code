//
//  LootboxViewModel.swift
//  Lootbox Legends
//
//  Created by the CIS 1951 team on 4/15/24.
//

import SwiftUI
import RealityKit
import OSLog

private let logger = Logger(subsystem: "Lootbox Legends", category: "LootboxViewModel")

@Observable @MainActor class LootboxViewModel {
    var currentItem: LootboxItem?
    var showUnableToPlaceMessage = false
    
    var realityViewContent: RealityViewCameraContent?
    var anchor: AnchorEntity?
    
    var lootboxTemplate: Entity?
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    func setUp(in realityViewContent: RealityViewCameraContent) async {
        self.realityViewContent = realityViewContent
        
        // TODO: Set up a template lootbox entity in step 1
        
        // TODO: Add collision and physics body components in step 3
        
        // Create horizontal table anchor for the content
        let anchor = AnchorEntity(.plane(.horizontal, classification: .table, minimumBounds: SIMD2<Float>(0.2, 0.2)))
        anchor.components.set(CollisionComponent(shapes: [.generateBox(width: 100, height: 0.001, depth: 100)]))
        
        // Add a physics body for the table
        var tablePhysicsBodyComponent = PhysicsBodyComponent()
        tablePhysicsBodyComponent.mode = .static
        anchor.components.set(tablePhysicsBodyComponent)
        
        // Add the anchor to the scene and view model
        realityViewContent.entities.append(anchor)
        self.anchor = anchor
    }
    
    func addLootbox(at point: CGPoint) {
        guard let anchor, let realityViewContent, let lootboxTemplate else {
            return
        }
        
        // TODO: Add a lootbox entity in step 1
        
        // TODO: Place the lootbox entity relative to the camera in step 2
        
        // TODO: Configure the lootbox with a LootboxComponent in step 4
    }
    
    func handleTap(at position: CGPoint) {
        guard let realityViewContent else {
            return
        }
        
        // TODO: Handle user input in step 5
    }
}
