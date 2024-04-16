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
        ZStack(alignment: .bottom) {
            ARViewContainer(lootboxViewModel: lootboxViewModel)
            
            Button {
                lootboxViewModel.addLootbox()
            } label: {
                Text("🤑 Add Lootbox")
                    .fontWeight(.medium)
                    .padding()
                    .background(.regularMaterial)
                    .clipShape(.rect(cornerRadius: 8))
            }
            .buttonStyle(.plain)
            .padding(.bottom, 32)
        }
        .edgesIgnoringSafeArea(.all)
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
