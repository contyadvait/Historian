import Cocoa

class CustomWindow: NSWindow {
    override var canBecomeKey: Bool {
        return true
    }

    override var canBecomeMain: Bool {
        return true
    }
}

class WindowDelegate: NSObject, NSWindowDelegate {
    func windowDidResignMain(_ notification: Notification) {
        if let window = notification.object as? NSWindow {
            window.orderOut(nil)  // Hide the window
        }
    }
}
