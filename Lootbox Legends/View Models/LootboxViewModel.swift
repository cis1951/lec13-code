//
//  LootboxViewModel.swift
//  Lootbox Legends
//
//  Created by the CIS 1951 team on 4/15/24.
//

import SwiftUI
import RealityKit
import OSLog
import FoundationModels

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
        
        let lootboxTemplate = try! await ModelEntity(named: "lootbox")
        self.lootboxTemplate = lootboxTemplate
        
        lootboxTemplate.components.set(CollisionComponent(shapes: [.generateBox(width: 0.2, height: 0.13, depth: 0.1)]))
        
        var lootboxPhysicsBodyComponent = PhysicsBodyComponent()
        lootboxPhysicsBodyComponent.massProperties.mass = 0.5
        lootboxPhysicsBodyComponent.mode = .dynamic
        lootboxTemplate.components.set(lootboxPhysicsBodyComponent)
        
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
        
        let hits = realityViewContent.hitTest(point: point, in: .local, query: .all)
        guard let hit = hits.first(where: { $0.entity === anchor }) else {
            showUnableToPlaceMessage = true
            return
        }
        
        let position = anchor.convert(position: hit.position, from: nil)
        let lootbox = lootboxTemplate.clone(recursive: true)
        logger.debug("Hit test with \(hit.entity.debugDescription) at \(hit.position) -> \(position)")
        lootbox.position = position + SIMD3(x: 0, y: 0.5, z: 0)
        lootbox.components.set(LootboxComponent(requiredTaps: Int.random(in: 2..<11)))
        anchor.addChild(lootbox)
        
        feedbackGenerator.impactOccurred()
    }
    
    func handleTap(at position: CGPoint) {
        guard let realityViewContent else {
            return
        }
        
        let hits = realityViewContent.hitTest(point: position, in: .local, query: .all)
        guard let hit = hits.first(where: { $0.entity.components.has(LootboxComponent.self) }) else {
            return
        }
        
        feedbackGenerator.impactOccurred()
        
        var lootboxComponent: LootboxComponent = hit.entity.components[LootboxComponent.self]!
        lootboxComponent.tapsReceived += 1
        
        if lootboxComponent.tapsReceived >= lootboxComponent.requiredTaps {
            hit.entity.removeFromParent()
            startGeneratingLootboxContent()
        } else {
            hit.entity.components.set(lootboxComponent)
        }
    }
    
    func startGeneratingLootboxContent() {
        let item = LootboxItem()
        
        guard #available(iOS 26.0, *), SystemLanguageModel.default.isAvailable else {
            item.content = LootboxItemContent.items.randomElement()!
            currentItem = item
            return
        }
        
        Task {
            do {
                item.content = try await LootboxItemContent.generate()
            } catch {
                logger.error("Couldn't generate lootbox content: \(error)")
                item.content = LootboxItemContent.items.randomElement()!
            }
        }
        
        currentItem = item
    }
}
