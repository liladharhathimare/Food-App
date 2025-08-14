#  Food Delivery App

A Flutter-based mobile application for exploring and ordering food, featuring secure user authentication via Firebase. This app offers intuitive browsing of restaurants, menu selection, cart functionality, and seamless order placement—designed for both Android and iOS.

---

##  Description

**Food Delivery App** allows users to log in, browse local restaurants, view menus, customize orders, and place food orders—all with an elegantly designed, responsive UI. It’s powered by Firebase for authentication, storage, and backend services.

---

##  Features

-  **Firebase Authentication** – Secure email/password login and registration.
-  **Restaurant & Menu Navigation** – Browse restaurants and view item details.
-  **Search Functionality** – Search restaurants or dishes by keywords.
-  **Cart Management** – Add, edit, or remove items before checkout.
-  **Order Summary** – Review your selections before placing an order.
-  **Image Handling** – Display restaurant and menu item images via Firebase Storage.
-  **Responsive UI** – Works seamlessly on Android and iOS.

---

##  Tech Stack

- **Framework:** [Flutter](https://flutter.dev)
- **Language:** Dart
- **Backend:** [Firebase](https://firebase.google.com)
  - Firebase Authentication
  - Cloud Firestore or Realtime Database (depending on your setup)
  - Firebase Storage (for image uploads)
- **State Management:** *(Please specify: Provider, Riverpod, Bloc, GetX, etc.)*
- **Key Packages:** `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`, `image_picker`, `provider`, `cached_network_image`, etc.


##  Getting Started

### Prerequisites

- Flutter SDK installed
- Android Studio or VS Code with Flutter plugin
- A configured Firebase project with Authentication, Firestore/Database, and Storage enabled
- `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)

### Steps

1. Clone the repo:
   ```bash
   git clone https://github.com/liladharhathimare/Food-App.git
   cd Food-App
