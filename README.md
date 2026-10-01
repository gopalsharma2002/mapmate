# MapMate 🗺️

A Flutter demo app for real-time location search, marker placement,
and route navigation — built using OpenStreetMap (no API key required).

## Features
- Current location detection with permission handling
- Location search (Nominatim API)
- Route/direction with distance & time (OSRM API)
- Clean error handling (GPS off, permission denied states)

## Tech Stack
- Flutter
- Geolocator
- Dio (API calls)
- flutter_map + OpenStreetMap tiles

## Screenshots

| Splash Screen                      | Permission Popup                                |
|------------------------------------|-------------------------------------------------|
| ![Splash](screenshots/splash.jpeg) | ![Permission](screenshots/permision_popup.jpeg) |

| Home Screen                    | Search & Route                   |
|--------------------------------|----------------------------------|
| ![Home](screenshots/home.jpeg) | ![Route](screenshots/route.jpeg) |

## Demo Video
Video will be added here after push (see below).

## Setup
\`\`\`bash
flutter pub get
flutter run
\`\`\`