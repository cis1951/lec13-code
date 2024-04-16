//
//  LootboxViewModel.swift
//  Lootbox Legends
//
//  Created by the CIS 1951 team on 4/15/24.
//

import SwiftUI
import RealityKit

class LootboxViewModel: ObservableObject {
    var arView: ARView?
    var anchor: AnchorEntity?
    
    let lootboxTemplate: Entity
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
    
    init() {
        lootboxTemplate = try! Entity.load(named: "lootbox")
        lootboxTemplate.scale *= 0.1
        lootboxTemplate.components.set(CollisionComponent(shapes: [.generateBox(width: 2, height: 1.5, depth: 1)]))
        
        var physicsBodyComponent = PhysicsBodyComponent()
        physicsBodyComponent.massProperties.mass = 0.5
        physicsBodyComponent.mode = .dynamic
        lootboxTemplate.components.set(physicsBodyComponent)
    }
    
    func setup(in arView: ARView) {
        self.arView = arView
        
        // Create horizontal plane anchor for the content
        let anchor = AnchorEntity(.plane(.horizontal, classification: .table, minimumBounds: SIMD2<Float>(0.2, 0.2)))
        anchor.components.set(CollisionComponent(shapes: [.generateBox(width: 100, height: 0.001, depth: 100)]))
        
        var physicsBodyComponent = PhysicsBodyComponent()
        physicsBodyComponent.mode = .static
        anchor.components.set(physicsBodyComponent)
        
        arView.scene.anchors.append(anchor)
        arView.physicsOrigin = anchor
        
        self.anchor = anchor
    }
    
    func addLootbox() {
        guard let anchor, let arView else {
            return
        }
        
        guard let (origin, direction) = arView.ray(through: arView.center) else {
            return
        }
        
        let diff = origin.y - anchor.position(relativeTo: nil).y
        guard diff != 0 else {
            return
        }
        
        let projectedPoint = origin - direction * (diff / direction.y)
        let mappedPoint = anchor.convert(position: projectedPoint, from: nil)
        
        let lootbox = lootboxTemplate.clone(recursive: true)
        lootbox.position = mappedPoint + SIMD3(x: 0, y: 0.5, z: 0)
        anchor.addChild(lootbox)
        
        feedbackGenerator.impactOccurred()
    }
}
