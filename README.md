# WLED Status Light - macOS Menu Bar App

A native macOS menu bar application for controlling WLED status lights, perfect for indicating meeting availability.

## Installation

### From Release (Recommended)

1. Download the latest `WLEDStatusLight.dmg` from [Releases](../../releases)
2. Open the DMG and drag the app to your Applications folder
3. **First launch only**: Right-click the app and select "Open" to bypass Gatekeeper
   - This is required because the app is ad-hoc signed (not notarized by Apple)
   - After the first launch, you can open it normally

### Building from Source

See the "Building the App" section below.

## Features

- **Menu bar integration**: Lives in your macOS menu bar with other system icons
- **Quick status control**: 
  - **Busy** - Sets light to red
  - **Free** - Sets light to your preferred mode (configurable)
  - **Off** - Turns the light off
- **Right-click toggle**: Right-click the menu bar icon to quickly toggle the light on/off
- **Configurable Free mode**: Choose from:
  - White
  - Green
  - Pink
  - Rainbow effect
  - Pacifica effect
- **Configurable IP address**: Set your WLED device's IP address (default: 192.168.1.29)
- **Persistent settings**: Your IP and Free mode preferences are saved

## Requirements

- macOS 13.0 or later
- Apple Silicon Mac
- Xcode 14+ (to build from source)
- WLED device on your local network

## Building the App

1. Open the project in Xcode:
   ```bash
   open WLEDStatusLight.xcodeproj
   ```

2. Select the WLEDStatusLight scheme and your Mac as the target

3. Build and run (⌘R) or build for release:
   - Product → Archive
   - Distribute App → Copy App

### Building from Command Line

Use the included build script:

```bash
./build.sh
```

This will build the app and optionally create a DMG installer.

## Running Tests

Run tests in Xcode with ⌘U, or from the command line:

```bash
xcodebuild test -project WLEDStatusLight.xcodeproj -scheme WLEDStatusLight -destination 'platform=macOS'
```

The test suite includes:
- **Unit tests** for WLEDController functionality
- **FreeMode enum tests** for all color/effect modes
- **Integration tests** for complete user workflows

## Usage

1. Launch the app - it will appear in your menu bar as a lightbulb icon
2. Click the icon to open the control panel
3. Configure your WLED device's IP address
4. Choose your preferred "Free" mode from the dropdown
5. Click Busy, Free, or Off to control your light
6. Right-click the menu bar icon for quick on/off toggle

## WLED API

This app uses the WLED JSON API to control your device:
- **Busy**: Sets solid red color (RGB: 255, 0, 0)
- **Free modes**:
  - White: RGB 255, 255, 255
  - Green: RGB 0, 255, 0
  - Pink: RGB 255, 105, 180
  - Rainbow: Effect ID 9
  - Pacifica: Effect ID 101

## Troubleshooting

- **"Cannot be opened because the developer cannot be verified"**: Right-click the app and select "Open" on first launch
- **Connection issues**: Verify your WLED device is on the same network and the IP address is correct
- **Effect not working**: Ensure your WLED firmware supports the selected effect
- **App not appearing in menu bar**: The app runs as an agent (LSUIElement = true) so it won't appear in the Dock

## License

MIT
