# Mouse Jiggler

A lightweight macOS menu bar utility that subtly moves your mouse cursor at regular intervals to prevent your screen from locking or your Mac from going to sleep.

## Features

- Lives in the menu bar — no Dock icon
- Configurable jiggle interval (15s, 30s, 1m, 2m, 5m)
- Adjustable movement amount (1px to 10px)
- Start, pause, and stop controls
- Launch at login support
- Auto-starts jiggling on launch

## Requirements

- macOS 14.0 (Sonoma) or later
- Xcode 16.0 or later (to build from source)
- Accessibility permission (the app will prompt you on first launch)

## Installation

### Build from Source

1. Clone the repository:

   ```bash
   git clone https://github.com/bkawk-open/mouse-jiggler.git
   cd mouse-jiggler
   ```

2. Open the Xcode project:

   ```bash
   open MouseJiggler.xcodeproj
   ```

3. Select your signing team in Xcode under **Signing & Capabilities**.

4. Build and run with **Cmd+R**, or archive for a release build via **Product > Archive**.

5. To install, drag the built `MouseJiggler.app` from your build folder into `/Applications`.

### Grant Accessibility Permission

Mouse Jiggler needs Accessibility access to move the cursor. On first launch you'll see a prompt in the menu bar dropdown:

1. Click **Grant Permission** in the app.
2. macOS will open **System Settings > Privacy & Security > Accessibility**.
3. Toggle **Mouse Jiggler** on.
4. You may need to restart the app for the permission to take effect.

## Usage

Once running, Mouse Jiggler appears as a mouse icon in your menu bar:

- **Active** — the icon is filled and pulses gently
- **Inactive** — the icon is an outline
- **Permission needed** — a warning triangle is shown

Click the menu bar icon to access controls:

- **Start / Stop** — toggle jiggling on and off
- **Pause / Resume** — temporarily pause without fully stopping
- **Interval** — choose how often the cursor moves
- **Movement** — choose how far the cursor moves (subtle 1px up to noticeable 10px)

Open **Settings** (Cmd+,) to configure launch at login.

## License

Copyright 2026 bkawk. All rights reserved.
