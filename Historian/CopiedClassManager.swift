import SwiftUI
import Combine

class CopiedItemsManager: ObservableObject {
    @Published var copiedItems: [String] = []
    private var lastChangeCount = NSPasteboard.general.changeCount

    init() {
        loadCopiedItems()
        startMonitoringClipboard()
    }

    func startMonitoringClipboard() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.checkClipboard()
        }
    }

    private func checkClipboard() {
        let pasteboard = NSPasteboard.general
        if pasteboard.changeCount != lastChangeCount {
            lastChangeCount = pasteboard.changeCount
            if let copiedString = pasteboard.string(forType: .string) {
                self.addCopiedText(copiedString)
            }
        }
    }

    private func addCopiedText(_ text: String) {
        // Add new item and remove the oldest if there are more than 5 items
        copiedItems.insert(text, at: 0)
        if copiedItems.count > 5 {
            copiedItems.removeLast()
        }
        saveCopiedItems()
    }

    private func loadCopiedItems() {
        copiedItems = UserDefaults.standard.stringArray(forKey: "CopiedItems") ?? []
    }

    private func saveCopiedItems() {
        UserDefaults.standard.set(copiedItems, forKey: "CopiedItems")
    }
}
