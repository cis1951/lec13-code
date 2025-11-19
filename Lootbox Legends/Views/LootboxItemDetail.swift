//
//  LootboxItemDetail.swift
//  Lootbox Legends
//
//  Created by the CIS 1951 team on 4/16/24.
//

import SwiftUI

struct LootboxItemDetail: View {
    var item: LootboxItem
    var onClose: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            if let content = item.content {
                Text(content.emoji)
                    .font(.system(size: 128))
                    .padding(.bottom)
                
                Text("You got \(content.title)!")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(content.description)
                    .foregroundStyle(.secondary)
                    .italic()
                    .padding(.bottom)
                
                Button("Accept") {
                    onClose()
                }
                .controlSize(.large)
                .fontWeight(.bold)
                .buttonStyle(BorderedProminentButtonStyle())
            } else {
                ProgressView()
                    .controlSize(.extraLarge)
            }
        }
        .frame(maxWidth: 400)
        .padding()
        .multilineTextAlignment(.center)
    }
}

#Preview {
    LootboxItemDetail(item: .init(.items[0])) {}
}
