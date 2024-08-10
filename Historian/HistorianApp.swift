import Cocoa
import SwiftUI

@main
struct YourApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var window: NSWindow?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "star.fill", accessibilityDescription: "Menu bar icon")
            button.action = #selector(menuBarIconClicked)
        }
        NSApp.setActivationPolicy(.accessory)
    }
    
    @objc func menuBarIconClicked() {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Open", action: #selector(openContentView), keyEquivalent: "O"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "Q"))
        statusItem?.menu = menu
        statusItem?.button?.performClick(nil)
    }
    
    @objc func openContentView() {
        if window == nil {
            let contentView = PasteView()
            
            window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 500, height: 500),
                styleMask: [.titled, .closable, .miniaturizable],
                backing: .buffered, defer: false)
            window?.center()
            window?.setFrameAutosaveName("Clipboard History - Historian")
            window?.contentView = NSHostingView(rootView: contentView)
        }
        
        window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func quitApp() {
        NSApp.terminate(nil)
    }
}
