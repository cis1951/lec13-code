//
//  LootboxItem+AI.swift
//  Lootbox Legends
//
//  Created by Anthony Li on 11/19/25.
//

import FoundationModels
import Foundation
import SwiftUI
import OSLog

@available(iOS 26.0, *)
@Generable(description: "A reward from a loot box.")
private struct GeneratedLootboxItemContent {
    @Guide(description: "A flashy and trendy title for the item.")
    var title: String
    
    @Guide(description: "Some flavor text for what the item does. Be funny.")
    var description: String
    
    @Guide(description: "An emoji representing the item. The emoji should represent the item itself, not of the loot box containing it.")
    var emoji: String
}

@available(iOS 26.0, *)
extension LootboxItemContent {
    private init(generated: GeneratedLootboxItemContent) {
        self.emoji = generated.emoji
        self.title = generated.title
        
        if let attributedString = try? AttributedString(markdown: generated.description) {
            self.description = "\(attributedString)"
        } else {
            self.description = "\(generated.description)"
        }
    }
    
    static func generate() async throws -> LootboxItemContent {
        let session = LanguageModelSession {
            "You are an expert game developer who develops free-to-play but infuriating gacha games. Your games include loot boxes, which give rewards that are ostentatious but provide very little actual value."
        }
        
        let generated = try await session.respond(to: "Generate a tacky loot box item:", generating: GeneratedLootboxItemContent.self)
        return LootboxItemContent(generated: generated.content)
    }
}
