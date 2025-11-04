import SwiftUI

struct ContentView: View {
    @ObservedObject var controller: WLEDController
    
    var body: some View {
        VStack(spacing: 16) {
            Text("WLED Status Light")
                .font(.headline)
            
            HStack {
                Button(action: {
                    controller.setBusy()
                }) {
                    HStack {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 12, height: 12)
                        Text("Busy")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                
                Button(action: {
                    controller.setFree()
                }) {
                    HStack {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 12, height: 12)
                        Text("Free")
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                
                Button(action: {
                    controller.turnOff()
                }) {
                    HStack {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 12, height: 12)
                        Text("Off")
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
    }
}
