# pionixbox

Flutter app for pionix charging box (Linux OS)

## Build for Raspberry Pi
Run the following commands on a x64 Intel/AMD machine, you CAN NOT build the app directly on the Raspberry Pi!
```bash
cd build
cmake ..
make install
```

You can then deploy the app to your Raspberry Pi using the following command:
```bash
rsync -a --info=progress2 ./dist/flutter_assets/ pi@<YOUR_RASPBERRY_PI_HOSTNAME>:/home/pi/pionixbox
```

To run the app on the Raspberry Pi you should follow the [instructions in the flutter-pi README](https://github.com/ardera/flutter-pi#-building-flutter-pi-on-the-raspberry-pi).

Here is short summary on how to get flutter-pi to run on your Raspberry Pi, all the following steps MUST be performed on the Raspberry Pi:
1. Install dependencies:
   ```bash
   sudo apt install cmake libgl1-mesa-dev libgles2-mesa-dev libegl1-mesa-dev libdrm-dev libgbm-dev ttf-mscorefonts-installer fontconfig libsystemd-dev libinput-dev libudev-dev  libxkbcommon-dev
   ```

2. Update system fonts
   ```bash
   sudo fc-cache
   ```

3. Checkout and install flutter-engine-binaries-for-arm
   ```bash
   git clone https://github.com/ardera/flutter-engine-binaries-for-arm.git
   cd flutter-engine-binaries-for-arm
   git checkout deaf44bacae971edfa1ffe84ba39874118a622cc
   sudo ./install.sh
   ```

4. Checkout and install flutter-pi
   ```bash
   git clone https://github.com/ardera/flutter-pi.git
   cd flutter-pi
   git checkout a11107b95920861e4bb8f19c4e71cb870c3aa42e
   mkdir build && cd build
   cmake ..
   make
   sudo make install
   ```

5. Run the pionixbox app:
   ```bash
   flutter-pi --release pionixbox/
   ```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
