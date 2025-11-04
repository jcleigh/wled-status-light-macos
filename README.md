# WLED Status Light - macOS Menu Bar App

A native macOS menu bar application for controlling WLED status lights, perfect for indicating meeting availability.

## Why this project exists

This project originated from an idea I had after attending [GitHub Universe 2025](https://githubuniverse.com/). I assembled an [Octolamp kit](https://github.com/martinwoodward/octolamp), 
which I realized would be a great "in a meeting" status light for my home office! I wanted a way to easily control the light remotely from my desk without
using the built-in WLED web UI or mobile app. 

| Screenshot | Octolamp in Busy (Red) mode | Octolamp in Free (Pacifica) mode |
|------------|-----------------------------|----------------------------------|
| <img width="170" height="169" alt="app screenshot" src="https://github.com/user-attachments/assets/d88ad83e-2b19-4512-b5e0-018aeb47cab6" /> | <img width="115" height="169" alt="busy light" src="https://github.com/user-attachments/assets/6bdf8731-12b0-4772-a908-c8b72475fefc" /> | <img width="115" height="169" alt="free light" src="https://github.com/user-attachments/assets/55effaf3-b69e-4323-949d-a2a533f292f4" /> |

**Protip:** run the USB power cable through the wall behind the light and plug it in on the other side. Fortunately for me, the other side of that wall is my unfinished utility room!



## Installation

### From Release (Recommended)

1. Download the latest `WLEDStatusLight.dmg` from [Releases](../../releases)
2. Open the DMG and drag the app to your Applications folder
3. Run `xattr -cr /Applications/WLEDStatusLight.app` in Terminal to remove the quarantine flag
4. Open WLEDStatusLight from your Applications folder
5. **Alternative:** Clone the repo and build from source to create your own copy locally. This circumvents the quarantine.

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

- **"Cannot be opened because the developer cannot be verified"**: Run `xattr -cr /Applications/WLEDStatusLight.app` in Terminal to remove the quarantine flag
- **Connection issues**: Verify your WLED device is on the same network and the IP address is correct
- **Effect not working**: Ensure your WLED firmware supports the selected effect
- **App not appearing in menu bar**: The app runs as an agent (LSUIElement = true) so it won't appear in the Dock

## License

MIT

## Shout outs
- [GitHub Copilot CLI](https://github.com/features/copilot/cli) for coding this entire app
- [Martin Woodward](https://github.com/martinwoodward) and [GitHub](https://github.com) for the Octolamp kit
- All the great [WLED project](https://github.com/WLED/WLED) contributors 
