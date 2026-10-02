# Parcel Delivery App

A full-featured Flutter application for managing parcel deliveries, with real-time tracking, Firebase authentication, and a dedicated rider interface. Customers can send and track parcels, while riders accept orders and update delivery status on the go.

[![Flutter](https://img.shields.io/badge/Flutter-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?logo=firebase&logoColor=black)](https://firebase.google.com)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green)](#)

**[Watch the demo video](https://youtu.be/Ux4seN-1yvA?si=kTfGd3ihJn7sMIzs)** · **[Download the Android APK](https://drive.google.com/file/d/1gxYh4HCkJ6oHNIvyU6LZsulUVB87ZxQT/view?usp=drive_link)**

---

## Overview

This project demonstrates a complete two-sided delivery platform: a customer experience for sending and tracking parcels, and a rider experience for managing deliveries. It combines Firebase real-time data, location services, external map navigation, and a clean, modular GetX architecture.

## Features

### Customer
- **Authentication**: secure login and registration with Firebase Auth.
- **Send parcels**: create and manage parcel deliveries.
- **Real-time tracking**: live parcel status updates powered by Cloud Firestore listeners.
- **Delivery history**: view recently sent parcels and their delivery status.
- **Location support**: location and address lookup, with locations opened in an external maps app.

### Ride
*In a real-world scenario, riders must submit all their documents and receive their credentials before they can log in. For this demo, use rider@gmail.com with the password 12345678 to log in as a rider.
- **Rider dashboard**: a dedicated interface for delivery personnel.
- **Order management**: view and accept delivery orders.
- **Navigation**: open pickup and delivery locations in an external maps app for turn-by-turn directions.
- **Status updates**: update parcel status in real time.
- **Earnings tracking**: monitor completed deliveries and performance.

### General
- **Responsive UI**: adapts to different screen sizes.
- **Light and dark themes**: full theme support with Google Fonts.
- **Lottie animations**: smooth loading and success animations.
- **Local persistence**: lightweight offline data storage with SharedPreferences.

## Tech Stack

| Area | Technology |
|---|---|
| Framework | Flutter (Dart) |
| Backend | Firebase Authentication, Cloud Firestore, Cloud Storage |
| State management | GetX |
| Location | Geolocator, Geocoding |
| Maps and navigation | External maps app launched via URL Launcher |
| UI | Google Fonts, Lottie, Flutter SpinKit, Marquee |
| Media and links | Image Picker, URL Launcher |
| Utilities | Intl, HTTP, Shared Preferences |

## Architecture

The app uses a layered architecture with clear separation of concerns:

- **Screens**: UI built with Flutter widgets.
- **Controllers**: business logic and state management with GetX.
- **Services**: Firebase integration, location services, and external APIs.
- **Models**: data classes for Firestore documents and local storage.

### Project Structure

```
lib/
├── main.dart
├── firebase_options.dart      # Firebase configuration
└── app/
    ├── configs/               # App configuration
    ├── controllers/           # GetX controllers
    │   ├── app_controllers/
    │   └── firebase/          # Firebase logic
    ├── rider/                 # Rider screens and logic
    ├── screens/
    │   ├── auths/             # Authentication screens
    │   └── app_screens/       # Main app screens
    └── widgets/               # Reusable UI components
```

## Implementation Highlights

- **Real-time updates**: Firestore listeners keep parcel status in sync across users and riders.
- **External map integration**: deep links through `url_launcher` open the user's preferred maps app, keeping the app lightweight without embedding a map SDK.
- **Performance**: optimized widget rebuilds using GetX reactive programming.
- **Code quality**: Flutter analyzer configured with best-practice lint rules.

## Getting Started

### Prerequisites

- Flutter SDK `^3.9.0`
- Android Studio / Android SDK (and Xcode for iOS, macOS only)
- A Firebase project

### Setup

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/parcel_delivery_app.git
cd parcel_delivery_app

# 2. Install dependencies
flutter pub get
```

### Configure Firebase

1. Create a Firebase project and add your Android/iOS app.
2. Enable **Authentication**, **Cloud Firestore**, and **Cloud Storage**.
3. Replace `android/app/google-services.json` with your own file.
4. Update `lib/firebase_options.dart` with your Firebase credentials (or regenerate it with `flutterfire configure`).
5. Set appropriate Firestore and Storage security rules.

### Run

```bash
flutter run
```

## Build for Production

```bash
# APK
flutter build apk --release

# App Bundle (Google Play)
flutter build appbundle --release
```

## Security

- Firebase Authentication controls access to the app.
- Firestore security rules protect user data.
- Cloud Storage handles files securely.
- Never commit private keys, signing keystores, or production secrets.

## Roadmap

- In-app view and live rider  tracking
- Unit, widget, and integration tests

## License

This project is private and intended for portfolio demonstration.

## Author

Open to collaboration and job opportunities. Feel free to reach out.