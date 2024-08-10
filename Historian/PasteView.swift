import SwiftUI
import AppKit
import Foundation

struct TransparentWindowView: NSViewRepresentable {
    func makeNSView(context: Context) -> NSView {
        let nsView = NSView()
        DispatchQueue.main.async {
            if let window = nsView.window {
                window.isOpaque = false
                window.backgroundColor = .clear
                
                
                window.titleVisibility = .hidden
                window.titlebarAppearsTransparent = true
                window.styleMask.remove(.titled)
                window.styleMask.insert(.fullSizeContentView)
            }
        }
        return nsView
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}
}

struct PasteView: View {
    @ObservedObject var manager = CopiedItemsManager()
    
    func typeTextIntoTextBox(text: String) {
        let script = """
        tell application "System Events" to keystroke "\(text)"
        tell application "Historian" to quit
        """
        
        let scriptObject = NSAppleScript(source: script)
        var error: NSDictionary?
        let output = scriptObject?.executeAndReturnError(&error)
        
        if let error = error {
            print("Error executing AppleScript: \(error)")
        }
    }
    
    var body: some View {
        ZStack {
            TransparentWindowView()
            
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "pencil.and.list.clipboard")
                        .font(.system(size: 20))
                    Text("Historian")
                        .font(.system(size: 20))
                    Spacer()
                }
                
                Text("Select which item you would like to paste")
                    .font(.system(size: 14))
                    .italic()
                
                VStack {
                    ForEach(manager.copiedItems, id: \.self) { item in
                        Button {
                            typeTextIntoTextBox(text: item)
                        } label: {
                            HStack {
                                Text(item)
                                    .font(.system(size: 13))
                                    .lineLimit(3)
                                    .multilineTextAlignment(.leading)
                                    .padding(5)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                Spacer()
                            }
                            .frame(minWidth: 500, minHeight: 50)
                            .background(Color.clear) // Ensure button background is clear
                        }
                    }
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(10)
            .shadow(radius: 5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
        .ignoresSafeArea()
    }
}

#Preview {
    PasteView()
}
