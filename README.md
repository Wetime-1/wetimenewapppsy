# Passive Discovery Travel App

A "Zero-Tap" travel discovery app built with Flutter.

## Setup

1.  **Dependencies**:
    Run the following command to install the necessary packages (since the initial creation might have been skipped):
    ```bash
    flutter pub get
    ```

2.  **Platform Setup**:
    - **Android**: Ensure you have an emulator running or a device connected.
    - **iOS**: Require macOS and Xcode.
    - **Permissions**:
        - Add `<uses-permission android:name="android.permission.INTERNET"/>` to `android/app/src/main/AndroidManifest.xml` (usually there by default for debug).
        - For Location (Geolocator), you'd need to add permissions, but for this *Mock* version, we simulate the location so no permissions are needed yet.

3.  **Run**:
    ```bash
    flutter run
    ```

## Features Implemented

-   **Zero-Tap Feed**: Opens immediately to a video feed.
-   **Context-Aware**: Filters videos based on simulated "Rainy Night" context.
-   **One-Tap Interface**: "Solo vs Group" bubble appears after 5 seconds of watching.
-   **Gamified Profile**: Tracks "Vibe" and "Tokens" locally.
-   **Mock Data**: Uses network videos (requires internet).

## Architecture

-   **State Management**: `flutter_riverpod`
-   **Video**: `video_player`
-   **Local Storage**: `hive`
-   **Structure**: 
    -   `lib/features/feed`: The main video feed logic.
    -   `lib/core/services`: Mock context and profile services.
