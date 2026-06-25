# BunHut POS — Flutter + Firebase 

> Based on the BunHut POS React prototype (POS · Dashboard · Expenses · Profile screens)

---

## Table of Contents

1. [Project Setup](#1-project-setup)
2. [Folder Structure](#2-folder-structure)
3. [Firebase Setup](#3-firebase-setup)
4. [Dependencies (pubspec.yaml)](#4-dependencies)
5. [Testing Checklist](#19-testing-checklist)

---

## 1. Project Setup

### Prerequisites
- Flutter SDK ≥ 3.19 (stable channel)
- Dart ≥ 3.3
- Android Studio or VS Code with Flutter plugin
- Firebase CLI (`npm install -g firebase-tools`)
- FlutterFire CLI (`dart pub global activate flutterfire_cli`)
- A Firebase project created at console.firebase.google.com

### Create the project

```bash
flutter create bunhut_pos --org com.bunhut --platforms android,ios
cd bunhut_pos
```

### Connect Firebase

```bash
firebase login
flutterfire configure --project=YOUR_FIREBASE_PROJECT_ID
```

This generates `lib/firebase_options.dart` automatically.

---

---

## 3. Firebase Setup

### Enable in Firebase Console:
- **Authentication** → Email/Password
- **Firestore Database** → Start in production mode
- **Cloud Storage** (optional, for future product images)

### Firestore Collections:

```
/products/{productId}
  name: string
  price: number
  stock: number
  category: string       // "Bakery" | "Beverages" | "Spices"
  tone: string           
  createdAt: timestamp

/orders/{orderId}
  invoiceId: string     
  total: number
  subtotal: number
  tax: number
  items: array of { productId, name, price, qty }
  cashierName: string
  createdAt: timestamp

/expenses/{expenseId}
  category: string       // "Spices" | "Gas" | "Salary" ...
  amount: number
  note: string
  createdAt: timestamp
```

### Firestore Security Rules (firestore.rules):

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

---

## 4. Dependencies

### `pubspec.yaml`

```yaml
name: bunhut_pos
description: BunHut Bakery Point of Sale System
version: 1.0.0+1

environment:
  sdk: ">=3.3.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter

  # Firebase
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
  cloud_firestore: ^5.4.4

  # State management
  provider: ^6.1.2

  # UI & utilities
  intl: ^0.19.0
  google_fonts: ^6.2.1
  flutter_slidable: ^3.1.1   # swipe-to-delete on cart items
  connectivity_plus: ^6.0.5
  uuid: ^4.5.1
  lottie: ^3.1.2              # optional loading animations

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/images/
```

Run: `flutter pub get`

---

## 5. Testing Checklist

Run these commands before each build:

```bash
flutter analyze          # static analysis
flutter test             # unit tests
flutter build apk        # Android release build
flutter build ios        # iOS release build (Mac only)
```

### Feature Checklist:
- [ ] Products load from Firestore in real-time
- [ ] Stock decrements when product is added to cart
- [ ] Stock restores when item is removed from cart
- [ ] Cart total = subtotal + 8% tax
- [ ] Receipt shows correct invoice ID and line items
- [ ] Order saved to Firestore on "Print via Bluetooth"
- [ ] Expenses grouped by category with running total
- [ ] New expense shows immediately (Firestore stream)
- [ ] Delete expense removes from list and Firestore
- [ ] Dashboard shows today's orders and total revenue
- [ ] Bottom navigation switches screens without losing cart state
- [ ] App works offline (Firestore offline persistence is on by default)

### Bluetooth Printing (optional):
Add `flutter_bluetooth_serial` or `esc_pos_bluetooth` packages to integrate
with the EPSON TM-T82 printer already referenced in the Profile screen.

---

*Guide generated from BunHut POS React prototype — all screen logic, colors, and data structures mirror the original UI.*
