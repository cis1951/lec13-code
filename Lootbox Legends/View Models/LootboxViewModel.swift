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
    
    let lootboxTemplate: Entity
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    init() {
        lootboxTemplate = try! Entity.load(named: "lootbox")
        lootboxTemplate.components.set(CollisionComponent(shapes: [.generateBox(width: 0.2, height: 0.13, depth: 0.1)]))
        
        var physicsBodyComponent = PhysicsBodyComponent()
        physicsBodyComponent.massProperties.mass = 0.5
        physicsBodyComponent.mode = .dynamic
        lootboxTemplate.components.set(physicsBodyComponent)
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
        guard let anchor, let arView else {
            return
        }
        
        let hits = arView.hitTest(arView.center, query: .nearest)
        guard let hit = hits.first else {
            showUnableToPlaceMessage = true
            return
        }
        
        let position = anchor.convert(position: hit.position, from: nil)
        let lootbox = lootboxTemplate.clone(recursive: true)
        lootbox.position = position + SIMD3(x: 0, y: 0.5, z: 0)
        lootbox.components.set(LootboxComponent(requiredTaps: Int.random(in: 2..<11)))
        anchor.addChild(lootbox)
        
        feedbackGenerator.impactOccurred()
    }
    
    func handleTap(at position: CGPoint) {
        guard let arView else {
            return
        }
        
        let hits = arView.hitTest(position, query: .all)
        guard let hit = hits.first(where: { $0.entity.components.has(LootboxComponent.self) }) else {
            return
        }
        
        feedbackGenerator.impactOccurred()
        
        var lootboxComponent: LootboxComponent = hit.entity.components[LootboxComponent.self]!
        lootboxComponent.tapsReceived += 1
        
        if lootboxComponent.tapsReceived >= lootboxComponent.requiredTaps {
            hit.entity.removeFromParent()
            currentItem = LootboxItem.items.randomElement()
        } else {
            hit.entity.components.set(lootboxComponent)
        }
    }
}
