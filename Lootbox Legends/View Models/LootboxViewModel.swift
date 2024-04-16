//
//  LootboxViewModel.swift
//  Lootbox Legends
//
//  Created by the CIS 1951 team on 4/15/24.
//

import SwiftUI
import ARKit
import RealityKit

class LootboxViewModel: ObservableObject {
    @Published var currentItem: LootboxItem?
    @Published var showUnableToPlaceMessage = false
    
    var arView: ARView?
    var anchor: AnchorEntity?
    
    init() {
        // TODO: Set up a template lootbox entity in step 1
        // TODO: Add collision and physics body components in step 3
    }
    
    func setup(in arView: ARView) {
        self.arView = arView
        
        // Create horizontal table anchor for the content
        let anchor = AnchorEntity(.plane(.horizontal, classification: .table, minimumBounds: SIMD2<Float>(0.2, 0.2)))
        anchor.components.set(CollisionComponent(shapes: [.generateBox(width: 100, height: 0.001, depth: 100)]))
        
        // Add a physics body for the table
        var physicsBodyComponent = PhysicsBodyComponent()
        physicsBodyComponent.mode = .static
        anchor.components.set(physicsBodyComponent)
        
        // Add the anchor to the scene and view model
        arView.scene.anchors.append(anchor)
        arView.physicsOrigin = anchor
        self.anchor = anchor
    }
    
    func addLootbox() {
        // TODO: Add a lootbox entity in step 1
        // TODO: Place the lootbox entity relative to the camera in step 2
        // TODO: Configure the lootbox with a LootboxComponent in step 4
    }
    
    func handleTap(at position: CGPoint) {
        // TODO: Handle user input in step 5
    }
}
