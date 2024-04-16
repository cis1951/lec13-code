//
//  ContentView.swift
//  Lootbox Legends
//
//  Created by the CIS 1951 team on 4/15/24.
//

import SwiftUI
import RealityKit

struct ContentView : View {
    @StateObject var lootboxViewModel = LootboxViewModel()
    
    var body: some View {
        ZStack {
            ARViewContainer(lootboxViewModel: lootboxViewModel)
                .onTapGesture { point in
                    lootboxViewModel.handleTap(at: point)
                }
            
            Button("🤑 Tap to add loot box") {
                lootboxViewModel.addLootbox()
            }
            .fontWeight(.bold)
            .controlSize(.large)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .buttonStyle(BorderedProminentButtonStyle())
            .padding(.bottom, 48)
            
            Text("Try aiming your device at a table")
                .fontWeight(.medium)
                .padding()
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 12))
                .multilineTextAlignment(.center)
                .opacity(lootboxViewModel.showUnableToPlaceMessage ? 1 : 0)
            
            if let item = lootboxViewModel.currentItem {
                LootboxItemDetail(item: item) {
                    lootboxViewModel.currentItem = nil
                }
                .animation(nil, value: lootboxViewModel.currentItem?.id)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.thinMaterial)
                .transition(.opacity)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .animation(.default, value: lootboxViewModel.currentItem?.id)
        .task(id: lootboxViewModel.showUnableToPlaceMessage) {
            if lootboxViewModel.showUnableToPlaceMessage {
                try? await Task.sleep(for: .seconds(1))
                withAnimation {
                    lootboxViewModel.showUnableToPlaceMessage = false
                }
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    @ObservedObject var lootboxViewModel: LootboxViewModel
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        lootboxViewModel.setup(in: arView)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

#Preview {
    ContentView()
}
