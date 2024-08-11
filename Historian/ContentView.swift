//
//  ContentView.swift
//  Historian
//
//  Created by Milind Contractor on 8/8/24.
//

import SwiftUI
import AXSwift

struct ContentView: View {
    @ObservedObject var manager = CopiedItemsManager()
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "list.bullet.clipboard")
                Text("Clipboard History - Historian")
            }
            .font(.title)
            .onAppear {
                guard UIElement.isProcessTrusted(withPrompt: true) else {
                    NSLog("No accessibility API permission, exiting")
                    NSRunningApplication.current.terminate()
                    return
                }
            }
            
            List(manager.copiedItems, id: \.self) { item in
                Text(item)
                    .lineLimit(5)
            }
            .frame(height: 400)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
