import SwiftUI
import Cocoa

class Coordinator: NSObject, NSWindowDelegate {
    var parent: TransparentWindowView

    init(parent: TransparentWindowView) {
        self.parent = parent
    }

    // This method is called when the window loses focus
    func windowDidResignMain(_ notification: Notification) {
        if let window = notification.object as? NSWindow {
            window.orderOut(nil)  // Hide the window
        }
    }
}

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
                
                // Set the window delegate to the coordinator
                window.delegate = context.coordinator
            }
        }
        
        return nsView
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {
        // No updates are needed
    }
    
    // Create a Coordinator instance
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}



struct PasteView: View {
    @ObservedObject var manager = CopiedItemsManager()
    @State private var showConfirmation = false

    func handleButtonPress(_ text: String) {
        // Copy text to clipboard
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
        
        // Show confirmation message
        showConfirmation = true
        
        // Hide confirmation message after a few seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            showConfirmation = false
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

                Text("Select which item you would like to type")
                    .font(.system(size: 14))
                    .italic()

                VStack {
                    ForEach(manager.copiedItems, id: \.self) { item in
                        VStack {
                            Button {
                                handleButtonPress(item)
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
                if showConfirmation {
                    Text("Copied item to clipboard!")
                        .font(.system(size: 12))
                        .foregroundColor(.green)
                        .padding(.top, 5)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.5))
                    Text("_To paste, use ⌘V to paste_")
                        .font(.system(size: 12))
                        .foregroundColor(.green)
                        .padding(.top, 5)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.5))
                }
            }
            .padding()
            .cornerRadius(10)
            .shadow(radius: 5)
            .background(.black)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
        .ignoresSafeArea()
    }
}

#Preview {
    PasteView()
}
