import Foundation
import Combine

enum FreeMode: String, CaseIterable, Identifiable {
    case white = "White"
    case green = "Green"
    case pink = "Pink"
    case rainbow = "Rainbow"
    case pacifica = "Pacifica"
    
    var id: String { rawValue }
}

class WLEDController: ObservableObject {
    @Published var ipAddress: String {
        didSet {
            UserDefaults.standard.set(ipAddress, forKey: "wledIP")
        }
    }
    
    @Published var freeMode: FreeMode {
        didSet {
            UserDefaults.standard.set(freeMode.rawValue, forKey: "freeMode")
        }
    }
    
    @Published var isOn: Bool = false
    @Published var statusMessage: String = ""
    
    private let defaultIP = "192.168.1.29"
    
    init() {
        self.ipAddress = UserDefaults.standard.string(forKey: "wledIP") ?? defaultIP
        let savedMode = UserDefaults.standard.string(forKey: "freeMode") ?? FreeMode.green.rawValue
        self.freeMode = FreeMode(rawValue: savedMode) ?? .green
    }
    
    func setBusy() {
        isOn = true
        statusMessage = "Set to Busy (Red)"
        sendCommand(color: [255, 0, 0], effect: 0, brightness: 255)
    }
    
    func setFree() {
        isOn = true
        statusMessage = "Set to Free (\(freeMode.rawValue))"
        switch freeMode {
        case .white:
            sendCommand(color: [255, 255, 255], effect: 0, brightness: 255)
        case .green:
            sendCommand(color: [0, 255, 0], effect: 0, brightness: 255)
        case .pink:
            sendCommand(color: [255, 105, 180], effect: 0, brightness: 255)
        case .rainbow:
            sendCommand(effect: 9, brightness: 255)
        case .pacifica:
            sendCommand(effect: 101, brightness: 255)
        }
    }
    
    func turnOff() {
        isOn = false
        statusMessage = "Turned Off"
        sendCommand(on: false)
    }
    
    func toggleLight() {
        if isOn {
            turnOff()
        } else {
            setFree()
        }
    }
    
    private func sendCommand(on: Bool? = nil, color: [Int]? = nil, effect: Int? = nil, brightness: Int? = nil) {
        guard let url = URL(string: "http://\(ipAddress)/json/state") else {
            statusMessage = "Invalid IP address"
            return
        }
        
        var json: [String: Any] = [:]
        
        if let on = on {
            json["on"] = on
        } else {
            json["on"] = true
        }
        
        if let brightness = brightness {
            json["bri"] = brightness
        }
        
        var segment: [String: Any] = [:]
        
        if let color = color {
            segment["col"] = [color]
        }
        
        if let effect = effect {
            segment["fx"] = effect
        }
        
        if !segment.isEmpty {
            json["seg"] = [segment]
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: json)
        } catch {
            statusMessage = "Error creating request"
            return
        }
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.statusMessage = "Error: \(error.localizedDescription)"
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        // Status message already set by calling function
                    } else {
                        self?.statusMessage = "Error: Status \(httpResponse.statusCode)"
                    }
                }
            }
        }.resume()
    }
}
