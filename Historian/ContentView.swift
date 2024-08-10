//
//  ContentView.swift
//  Historian
//
//  Created by Milind Contractor on 8/8/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var manager = CopiedItemsManager()
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "list.bullet.clipboard")
                Text("Clipboard History - Historian")
            }
            .font(.title)
            
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
