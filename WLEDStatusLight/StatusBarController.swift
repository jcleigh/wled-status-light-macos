import SwiftUI
import AppKit
import Combine

class StatusBarController: ObservableObject {
    private var statusItem: NSStatusItem
    private var popover: NSPopover
    @Published var wledController: WLEDController
    @Published var shortcutManager: ShortcutManager
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        popover = NSPopover()
        let controller = WLEDController()
        wledController = controller
        shortcutManager = ShortcutManager { action in
            switch action {
            case .busy:
                controller.setBusy()
            case .free:
                controller.setFree()
            case .off:
                controller.turnOff()
            }
        }
        
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "lightbulb.circle", accessibilityDescription: "WLED Status")
            button.action = #selector(togglePopover)
            button.target = self
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        
        popover.contentViewController = NSHostingController(
            rootView: ContentView(controller: wledController, shortcutManager: shortcutManager)
        )
        popover.behavior = .transient
        
        // Observe isOn changes and update icon
        wledController.$isOn
            .sink { [weak self] _ in
                self?.updateIcon()
            }
            .store(in: &cancellables)
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        guard let button = statusItem.button else { return }
        
        if let event = NSApp.currentEvent {
            if event.type == .rightMouseUp {
                wledController.toggleLight()
                updateIcon()
                return
            }
        }
        
        if popover.isShown {
            popover.performClose(sender)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            popover.contentViewController?.view.window?.makeKey()
        }
    }
    
    func updateIcon() {
        if let button = statusItem.button {
            let symbolName = wledController.isOn ? "lightbulb.circle.fill" : "lightbulb.circle"
            button.image = NSImage(systemSymbolName: symbolName, accessibilityDescription: "WLED Status")
        }
    }
}
