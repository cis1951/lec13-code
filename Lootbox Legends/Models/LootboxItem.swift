//
//  LootboxItem.swift
//  Lootbox Legends
//
//  Created by the CIS 1951 team on 4/16/24.
//

import SwiftUI
import FoundationModels

struct LootboxItemContent {
    var emoji: String
    var title: String
    var description: LocalizedStringKey
    
    static let items: [LootboxItemContent] = [
        .init(emoji: "🖼️", title: "Useless Collectible", description: "We probably generated it with AI anyway."),
        .init(emoji: "🤮", title: "1920 Commons Chicken", description: "oops"),
        .init(emoji: "💡", title: "Million Dollar Idea", description: "Too bad it's our intellectual property."),
        .init(emoji: "💎", title: "Rare Skin", description: "Now you can show off how much you like wasting money!"),
        .init(emoji: "💰", title: "$10 Dining Dollars", description: "[Tap here to claim now!](https://www.youtube.com/watch?v=xvFZjo5PgG0)"),
        .init(emoji: "🍋‍🟩", title: "Lime", description: "Let's hope you're on iOS 17.4"),
        .init(emoji: "🫥", title: "a feeling of emptiness", description: ""),
        .init(emoji: "❤️", title: "a thank you message from the CIS 1951 staff", description: "Thanks for taking our course, and we hope you enjoyed it! Best of luck in the future, whether you continue developing for iOS or not."),
    ]
}

@Observable class LootboxItem: Identifiable {
    let id = UUID()
    var content: LootboxItemContent?
}

extension LootboxItem {
    convenience init(_ content: LootboxItemContent) {
        self.init()
        self.content = content
    }
}
