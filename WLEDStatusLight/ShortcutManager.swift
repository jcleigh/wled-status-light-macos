import Foundation
import AppKit
import Carbon

enum ShortcutAction: String, CaseIterable, Identifiable {
    case busy = "busy"
    case free = "free"
    case off = "off"
    
    var id: String { rawValue }
    
    var label: String {
        switch self {
        case .busy: return "Busy"
        case .free: return "Free"
        case .off: return "Off"
        }
    }
    
    var hotKeyID: UInt32 {
        switch self {
        case .busy: return 1
        case .free: return 2
        case .off: return 3
        }
    }
    
    var defaultShortcut: KeyShortcut {
        let defaultModifiers = UInt32(controlKey | optionKey | cmdKey)
        switch self {
        case .busy:
            return KeyShortcut(keyCode: UInt32(kVK_ANSI_1), carbonModifiers: defaultModifiers)
        case .free:
            return KeyShortcut(keyCode: UInt32(kVK_ANSI_2), carbonModifiers: defaultModifiers)
        case .off:
            return KeyShortcut(keyCode: UInt32(kVK_ANSI_3), carbonModifiers: defaultModifiers)
        }
    }
}

struct KeyShortcut: Codable, Equatable {
    var keyCode: UInt32
    var carbonModifiers: UInt32
    
    var displayString: String {
        var result = ""
        if carbonModifiers & UInt32(controlKey) != 0 { result += "⌃" }
        if carbonModifiers & UInt32(optionKey) != 0 { result += "⌥" }
        if carbonModifiers & UInt32(shiftKey) != 0 { result += "⇧" }
        if carbonModifiers & UInt32(cmdKey) != 0 { result += "⌘" }
        result += Self.keyName(for: keyCode)
        return result
    }
    
    static func carbonModifiers(from flags: NSEvent.ModifierFlags) -> UInt32 {
        var mods: UInt32 = 0
        if flags.contains(.control) { mods |= UInt32(controlKey) }
        if flags.contains(.option) { mods |= UInt32(optionKey) }
        if flags.contains(.shift) { mods |= UInt32(shiftKey) }
        if flags.contains(.command) { mods |= UInt32(cmdKey) }
        return mods
    }
    
    static func isFunctionKey(_ keyCode: UInt32) -> Bool {
        switch Int(keyCode) {
        case kVK_F1, kVK_F2, kVK_F3, kVK_F4, kVK_F5, kVK_F6,
             kVK_F7, kVK_F8, kVK_F9, kVK_F10, kVK_F11, kVK_F12,
             kVK_F13, kVK_F14, kVK_F15, kVK_F16, kVK_F17, kVK_F18,
             kVK_F19, kVK_F20:
            return true
        default:
            return false
        }
    }
    
    static func keyName(for keyCode: UInt32) -> String {
        switch Int(keyCode) {
        case kVK_ANSI_A: return "A"
        case kVK_ANSI_B: return "B"
        case kVK_ANSI_C: return "C"
        case kVK_ANSI_D: return "D"
        case kVK_ANSI_E: return "E"
        case kVK_ANSI_F: return "F"
        case kVK_ANSI_G: return "G"
        case kVK_ANSI_H: return "H"
        case kVK_ANSI_I: return "I"
        case kVK_ANSI_J: return "J"
        case kVK_ANSI_K: return "K"
        case kVK_ANSI_L: return "L"
        case kVK_ANSI_M: return "M"
        case kVK_ANSI_N: return "N"
        case kVK_ANSI_O: return "O"
        case kVK_ANSI_P: return "P"
        case kVK_ANSI_Q: return "Q"
        case kVK_ANSI_R: return "R"
        case kVK_ANSI_S: return "S"
        case kVK_ANSI_T: return "T"
        case kVK_ANSI_U: return "U"
        case kVK_ANSI_V: return "V"
        case kVK_ANSI_W: return "W"
        case kVK_ANSI_X: return "X"
        case kVK_ANSI_Y: return "Y"
        case kVK_ANSI_Z: return "Z"
        case kVK_ANSI_0: return "0"
        case kVK_ANSI_1: return "1"
        case kVK_ANSI_2: return "2"
        case kVK_ANSI_3: return "3"
        case kVK_ANSI_4: return "4"
        case kVK_ANSI_5: return "5"
        case kVK_ANSI_6: return "6"
        case kVK_ANSI_7: return "7"
        case kVK_ANSI_8: return "8"
        case kVK_ANSI_9: return "9"
        case kVK_ANSI_Minus: return "-"
        case kVK_ANSI_Equal: return "="
        case kVK_ANSI_LeftBracket: return "["
        case kVK_ANSI_RightBracket: return "]"
        case kVK_ANSI_Backslash: return "\\"
        case kVK_ANSI_Semicolon: return ";"
        case kVK_ANSI_Quote: return "'"
        case kVK_ANSI_Comma: return ","
        case kVK_ANSI_Period: return "."
        case kVK_ANSI_Slash: return "/"
        case kVK_ANSI_Grave: return "`"
        case kVK_ANSI_Keypad0: return "Num0"
        case kVK_ANSI_Keypad1: return "Num1"
        case kVK_ANSI_Keypad2: return "Num2"
        case kVK_ANSI_Keypad3: return "Num3"
        case kVK_ANSI_Keypad4: return "Num4"
        case kVK_ANSI_Keypad5: return "Num5"
        case kVK_ANSI_Keypad6: return "Num6"
        case kVK_ANSI_Keypad7: return "Num7"
        case kVK_ANSI_Keypad8: return "Num8"
        case kVK_ANSI_Keypad9: return "Num9"
        case kVK_ANSI_KeypadDecimal: return "Num."
        case kVK_ANSI_KeypadMultiply: return "Num*"
        case kVK_ANSI_KeypadPlus: return "Num+"
        case kVK_ANSI_KeypadClear: return "NumClear"
        case kVK_ANSI_KeypadDivide: return "Num/"
        case kVK_ANSI_KeypadEnter: return "Num↩"
        case kVK_ANSI_KeypadMinus: return "Num-"
        case kVK_ANSI_KeypadEquals: return "Num="
        case kVK_F1: return "F1"
        case kVK_F2: return "F2"
        case kVK_F3: return "F3"
        case kVK_F4: return "F4"
        case kVK_F5: return "F5"
        case kVK_F6: return "F6"
        case kVK_F7: return "F7"
        case kVK_F8: return "F8"
        case kVK_F9: return "F9"
        case kVK_F10: return "F10"
        case kVK_F11: return "F11"
        case kVK_F12: return "F12"
        case kVK_F13: return "F13"
        case kVK_F14: return "F14"
        case kVK_F15: return "F15"
        case kVK_F16: return "F16"
        case kVK_F17: return "F17"
        case kVK_F18: return "F18"
        case kVK_F19: return "F19"
        case kVK_F20: return "F20"
        case kVK_Space: return "Space"
        case kVK_Return: return "↩"
        case kVK_Tab: return "⇥"
        case kVK_UpArrow: return "↑"
        case kVK_DownArrow: return "↓"
        case kVK_LeftArrow: return "←"
        case kVK_RightArrow: return "→"
        case kVK_Home: return "↖"
        case kVK_End: return "↘"
        case kVK_PageUp: return "⇞"
        case kVK_PageDown: return "⇟"
        default: return "Key\(keyCode)"
        }
    }
}

class ShortcutManager: ObservableObject {
    @Published private(set) var shortcuts: [ShortcutAction: KeyShortcut] = [:]
    @Published var recordingAction: ShortcutAction? = nil
    
    private var hotKeyRefs: [ShortcutAction: EventHotKeyRef] = [:]
    private var eventHandlerRef: EventHandlerRef?
    private var keyMonitor: Any?
    private var onTrigger: ((ShortcutAction) -> Void)?
    
    private let defaultsKey = "keyboardShortcuts"
    private let signature: OSType = 0x574C4544 // 'WLED'
    
    init(onTrigger: ((ShortcutAction) -> Void)? = nil) {
        self.onTrigger = onTrigger
        loadShortcuts()
        installEventHandler()
        registerAllHotKeys()
    }
    
    deinit {
        stopRecording()
        unregisterAllHotKeys()
        if let handler = eventHandlerRef {
            RemoveEventHandler(handler)
        }
    }
    
    func setTriggerHandler(_ handler: @escaping (ShortcutAction) -> Void) {
        self.onTrigger = handler
    }
    
    func shortcut(for action: ShortcutAction) -> KeyShortcut? {
        shortcuts[action]
    }
    
    func updateShortcut(_ shortcut: KeyShortcut?, for action: ShortcutAction) {
        if let shortcut = shortcut {
            // Remove duplicate assignment if another action uses the same shortcut
            for (otherAction, existing) in shortcuts where otherAction != action && existing == shortcut {
                shortcuts.removeValue(forKey: otherAction)
            }
            shortcuts[action] = shortcut
        } else {
            shortcuts.removeValue(forKey: action)
        }
        saveShortcuts()
        if recordingAction == nil {
            registerAllHotKeys()
        }
    }
    
    func resetToDefaults() {
        stopRecording()
        var defaults: [ShortcutAction: KeyShortcut] = [:]
        for action in ShortcutAction.allCases {
            defaults[action] = action.defaultShortcut
        }
        shortcuts = defaults
        saveShortcuts()
        registerAllHotKeys()
    }
    
    func startRecording(for action: ShortcutAction) {
        stopRecording()
        recordingAction = action
        unregisterAllHotKeys()
        
        keyMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            guard let self = self, let currentAction = self.recordingAction else {
                return event
            }
            
            let keyCode = UInt32(event.keyCode)
            
            // Escape cancels recording
            if Int(keyCode) == kVK_Escape {
                self.stopRecording()
                return nil
            }
            
            let flags = event.modifierFlags.intersection([.control, .option, .shift, .command])
            let carbonMods = KeyShortcut.carbonModifiers(from: flags)
            
            // Delete/Backspace without modifiers clears the shortcut
            if (Int(keyCode) == kVK_Delete || Int(keyCode) == kVK_ForwardDelete) && carbonMods == 0 {
                self.recordingAction = nil
                self.removeKeyMonitor()
                self.updateShortcut(nil, for: currentAction)
                return nil
            }
            
            // Require at least one modifier key unless using F1-F20
            guard carbonMods != 0 || KeyShortcut.isFunctionKey(keyCode) else {
                NSSound.beep()
                return nil
            }
            
            let newShortcut = KeyShortcut(keyCode: keyCode, carbonModifiers: carbonMods)
            self.recordingAction = nil
            self.removeKeyMonitor()
            self.updateShortcut(newShortcut, for: currentAction)
            return nil
        }
    }
    
    func stopRecording() {
        guard recordingAction != nil else { return }
        recordingAction = nil
        removeKeyMonitor()
        registerAllHotKeys()
    }
    
    private func removeKeyMonitor() {
        if let monitor = keyMonitor {
            NSEvent.removeMonitor(monitor)
            keyMonitor = nil
        }
    }
    
    private func loadShortcuts() {
        if let data = UserDefaults.standard.data(forKey: defaultsKey),
           let saved = try? JSONDecoder().decode([String: KeyShortcut].self, from: data) {
            var loaded: [ShortcutAction: KeyShortcut] = [:]
            for (key, value) in saved {
                if let action = ShortcutAction(rawValue: key) {
                    loaded[action] = value
                }
            }
            shortcuts = loaded
        } else {
            for action in ShortcutAction.allCases {
                shortcuts[action] = action.defaultShortcut
            }
            saveShortcuts()
        }
    }
    
    private func saveShortcuts() {
        var rawDict: [String: KeyShortcut] = [:]
        for (action, shortcut) in shortcuts {
            rawDict[action.rawValue] = shortcut
        }
        if let data = try? JSONEncoder().encode(rawDict) {
            UserDefaults.standard.set(data, forKey: defaultsKey)
        }
    }
    
    private func installEventHandler() {
        var eventType = EventTypeSpec(
            eventClass: OSType(kEventClassKeyboard),
            eventKind: UInt32(kEventHotKeyPressed)
        )
        
        let selfPtr = Unmanaged.passUnretained(self).toOpaque()
        
        InstallEventHandler(
            GetApplicationEventTarget(),
            { _, event, userData -> OSStatus in
                guard let event = event, let userData = userData else {
                    return OSStatus(eventNotHandledErr)
                }
                var hotKeyID = EventHotKeyID()
                let status = GetEventParameter(
                    event,
                    EventParamName(kEventParamDirectObject),
                    EventParamType(typeEventHotKeyID),
                    nil,
                    MemoryLayout<EventHotKeyID>.size,
                    nil,
                    &hotKeyID
                )
                guard status == noErr else { return status }
                
                let manager = Unmanaged<ShortcutManager>.fromOpaque(userData).takeUnretainedValue()
                manager.handleHotKey(id: hotKeyID.id)
                return noErr
            },
            1,
            &eventType,
            selfPtr,
            &eventHandlerRef
        )
    }
    
    private func handleHotKey(id: UInt32) {
        guard let action = ShortcutAction.allCases.first(where: { $0.hotKeyID == id }) else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.onTrigger?(action)
        }
    }
    
    private func registerAllHotKeys() {
        unregisterAllHotKeys()
        for action in ShortcutAction.allCases {
            guard let shortcut = shortcuts[action] else { continue }
            let hotKeyID = EventHotKeyID(signature: signature, id: action.hotKeyID)
            var ref: EventHotKeyRef?
            let status = RegisterEventHotKey(
                shortcut.keyCode,
                shortcut.carbonModifiers,
                hotKeyID,
                GetApplicationEventTarget(),
                0,
                &ref
            )
            if status == noErr, let ref = ref {
                hotKeyRefs[action] = ref
            }
        }
    }
    
    private func unregisterAllHotKeys() {
        for (_, ref) in hotKeyRefs {
            UnregisterEventHotKey(ref)
        }
        hotKeyRefs.removeAll()
    }
}
