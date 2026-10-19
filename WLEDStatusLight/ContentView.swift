import SwiftUI

struct ContentView: View {
    @ObservedObject var controller: WLEDController
    @ObservedObject var shortcutManager: ShortcutManager
    
    var body: some View {
        VStack(spacing: 16) {
            Text("WLED Status Light")
                .font(.headline)
            
            HStack {
                Button(action: {
                    controller.setBusy()
                }) {
                    VStack(spacing: 4) {
                        HStack {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 12, height: 12)
                            Text("Busy")
                        }
                        if let shortcut = shortcutManager.shortcut(for: .busy) {
                            Text(shortcut.displayString)
                                .font(.caption2)
                                .opacity(0.85)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                
                Button(action: {
                    controller.setFree()
                }) {
                    VStack(spacing: 4) {
                        HStack {
                            Circle()
                                .fill(Color.green)
                                .frame(width: 12, height: 12)
                            Text("Free")
                        }
                        if let shortcut = shortcutManager.shortcut(for: .free) {
                            Text(shortcut.displayString)
                                .font(.caption2)
                                .opacity(0.85)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                
                Button(action: {
                    controller.turnOff()
                }) {
                    VStack(spacing: 4) {
                        HStack {
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 12, height: 12)
                            Text("Off")
                        }
                        if let shortcut = shortcutManager.shortcut(for: .off) {
                            Text(shortcut.displayString)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            
            Divider()
            
            HStack {
                Text("Free mode:")
                    .font(.subheadline)
                Picker("", selection: $controller.freeMode) {
                    ForEach(FreeMode.allCases) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.menu)
                .frame(width: 120)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                Text("WLED IP Address:")
                    .font(.subheadline)
                TextField("192.168.1.29", text: $controller.ipAddress)
                    .textFieldStyle(.roundedBorder)
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Keyboard Shortcuts:")
                        .font(.subheadline)
                    Spacer()
                    Button("Reset") {
                        shortcutManager.resetToDefaults()
                    }
                    .buttonStyle(.link)
                    .font(.caption)
                }
                
                ForEach(ShortcutAction.allCases) { action in
                    ShortcutRowView(action: action, shortcutManager: shortcutManager)
                }
                
                if shortcutManager.recordingAction != nil {
                    Text("Press modifier(s) + key, Delete to clear, or Esc to cancel")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            if !controller.statusMessage.isEmpty {
                Text(controller.statusMessage)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            Divider()
            
            Button(action: {
                NSApplication.shared.terminate(nil)
            }) {
                Text("Quit")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .frame(width: 320)
        .onDisappear {
            shortcutManager.stopRecording()
        }
    }
}

struct ShortcutRowView: View {
    let action: ShortcutAction
    @ObservedObject var shortcutManager: ShortcutManager
    
    private var isRecording: Bool {
        shortcutManager.recordingAction == action
    }
    
    var body: some View {
        HStack {
            Text(action.label)
                .font(.caption)
            Spacer()
            Button(action: {
                if isRecording {
                    shortcutManager.stopRecording()
                } else {
                    shortcutManager.startRecording(for: action)
                }
            }) {
                Text(buttonLabel)
                    .font(.system(.caption, design: .monospaced))
                    .frame(minWidth: 90)
            }
            .buttonStyle(.bordered)
            .tint(isRecording ? .accentColor : nil)
        }
    }
    
    private var buttonLabel: String {
        if isRecording {
            return "Press keys…"
        }
        return shortcutManager.shortcut(for: action)?.displayString ?? "None"
    }
}
