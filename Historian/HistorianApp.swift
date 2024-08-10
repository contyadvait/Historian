import Cocoa
import SwiftUI
import HotKey
import AppKit


@main
struct YourApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView() // Hide any default settings window
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var window: NSWindow?
    var hotKey: HotKey?

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "pencil.and.list.clipboard", accessibilityDescription: "Menu bar icon")
            button.action = #selector(menuBarIconClicked)
        }
        NSApp.setActivationPolicy(.accessory)

        setupGlobalHotKey()
    }
    
    func setupGlobalHotKey() {
        hotKey = HotKey(key: .v, modifiers: [.command, .option])
        hotKey?.keyDownHandler = { [weak self] in
            self?.openContentView()
        }
    }
    
    @objc func menuBarIconClicked() {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Open", action: #selector(openSettingsView), keyEquivalent: "O"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "Q"))
        statusItem?.menu = menu
        statusItem?.button?.performClick(nil)
    }
    
    @objc func openSettingsView() {
        if window == nil {
            let contentView = ContentView()
            
            window = NSWindow(
                contentRect: NSRect(x: 0, y: 0, width: 500, height: 500),
                styleMask: [.titled, .closable, .miniaturizable],
                backing: .buffered, defer: false)
            window?.center()
            window?.setFrameAutosaveName("Settings - Historian")
            window?.contentView = NSHostingView(rootView: contentView)
        }
        
        window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
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
