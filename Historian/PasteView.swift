import SwiftUI
import AppKit

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
    
    func pasteAndClose(_ text: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)

        let script = """
        tell application "System Events"
            set textToType to "\(text)"
            keystroke textToType
        end tell
        """
        if let appleScript = NSAppleScript(source: script) {
            var error: NSDictionary?
            appleScript.executeAndReturnError(&error)
            if let error = error {
                print("AppleScript Error: \(error)")
            }
        }
        
        if let keyWindow = NSApplication.shared.keyWindow {
            keyWindow.performClose(nil)
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
                            pasteAndClose(item)
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
