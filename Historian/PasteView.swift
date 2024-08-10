//
//  PasteView.swift
//  Historian
//
//  Created by Milind Contractor on 8/8/24.
//

import SwiftUI

struct VisualEffectBlur: NSViewRepresentable
{
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView
    {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
        visualEffectView.state = NSVisualEffectView.State.active
        return visualEffectView
    }

    func updateNSView(_ visualEffectView: NSVisualEffectView, context: Context)
    {
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
    }
}



struct PasteView: View {
    @ObservedObject var manager = CopiedItemsManager()
    var body: some View {
        ZStack {
            VisualEffectBlur(material: .sidebar, blendingMode: .withinWindow)
            VStack {
                HStack {
                    Text("Historian")
                        .font(.system(size: 14))
                    Spacer()
                }
                
                ForEach(manager.copiedItems, id: \.self) { item in
                    Text(item)
                        .multilineTextAlignment(.leading)
                        .lineLimit(5)
                        .padding(5)
                        .background(.thickMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
            }
        }
        .presentedWindowStyle(.hiddenTitleBar)
        .padding()
        .background(.ultraThinMaterial)
    }
}

#Preview {
    PasteView()
        .presentedWindowStyle(.hiddenTitleBar)
}
