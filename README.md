<div align="center">

  <img src="assets/logo.png" alt="Recipe App Logo" width="110" style="border-radius: 24px; box-shadow: 0 8px 24px rgba(0,0,0,0.15);"/>

  # 🍽️ FlavorCraft — Smart Recipe & Meal Planner
  
  <p align="center">
    <strong>A next-generation culinary companion built with Flutter, Provider, and Firebase.</strong><br>
    Featuring intelligent meal planning, real-time cloud sync, lightning-fast discovery, and a distraction-free cooking mode.
  </p>

  <p align="center">
    <a href="#-features">Features</a> •
    <a href="#-app-showcase">Showcase</a> •
    <a href="#-tech-stack">Tech Stack</a> •
    <a href="#-architecture">Architecture</a> •
    <a href="#-getting-started">Getting Started</a> •
    <a href="#-download-apk">Download APK</a>
  </p>

  <!-- Badges -->
  <p align="center">
    <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter" />
    <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart" />
    <img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" alt="Firebase" />
    <img src="https://img.shields.io/badge/Provider-State%20Management-2ECC71?style=for-the-badge" alt="Provider" />
  </p>

  <p align="center">
    <a href="https://github.com/Yeamin-Talukder/Recipe-App/releases/latest">
      <img src="https://img.shields.io/github/v/release/Yeamin-Talukder/Recipe-App?color=2ECC71&label=Release&style=flat-square" alt="Latest Release"/>
    </a>
    <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-orange?style=flat-square" alt="Platform" />
    <img src="https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square" alt="License" />
    <img src="https://visitor-badge.laobi.icu/badge?page_id=Yeamin-Talukder.Recipe-App" alt="Visitors" />
  </p>

  <br>

  <a href="https://github.com/Yeamin-Talukder/Recipe-App/releases/latest">
    <img src="https://img.shields.io/badge/⚡_DOWNLOAD_LATEST_RELEASE-2ECC71?style=for-the-badge&logo=android&logoColor=white" height="42" alt="Download APK" />
  </a>

</div>

---

## 📱 App Showcase

<div align="center">
  <table>
    <thead>
      <tr>
        <th align="center">🏠 Home & Explore</th>
        <th align="center">❤️ Saved Favourites</th>
        <th align="center">📅 Smart Meal Planner</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td align="center">
          <img src="assets/screenshots/home_screen.jpg" width="230" alt="Home Screen" style="border-radius: 14px; box-shadow: 0 6px 18px rgba(0,0,0,0.12);" />
        </td>
        <td align="center">
          <img src="assets/screenshots/favorites_screen.jpg" width="230" alt="Favourites Screen" style="border-radius: 14px; box-shadow: 0 6px 18px rgba(0,0,0,0.12);" />
        </td>
        <td align="center">
          <img src="assets/screenshots/meal_plan_screen.jpg" width="230" alt="Meal Planner Screen" style="border-radius: 14px; box-shadow: 0 6px 18px rgba(0,0,0,0.12);" />
        </td>
      </tr>
      <tr>
        <td align="center"><b>Smart Search & Categories</b></td>
        <td align="center"><b>Instant Cloud-Synced Recipes</b></td>
        <td align="center"><b>Weekly Breakfast, Lunch & Dinner</b></td>
      </tr>
    </tbody>
  </table>

  <br>

  <table>
    <thead>
      <tr>
        <th align="center">🌙 Dark Theme Elegance</th>
        <th align="center">☀️ Light Mode Clarity</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td align="center">
          <img src="assets/screenshots/settings_dark_screen.jpg" width="250" alt="Settings Dark Theme" style="border-radius: 14px; box-shadow: 0 6px 18px rgba(0,0,0,0.2);" />
        </td>
        <td align="center">
          <img src="assets/screenshots/settings_light_screen.jpg" width="250" alt="Settings Light Theme" style="border-radius: 14px; box-shadow: 0 6px 18px rgba(0,0,0,0.1);" />
        </td>
      </tr>
      <tr>
        <td align="center"><b>Deep OLED Contrast & Modern Accents</b></td>
        <td align="center"><b>Crisp, Accessible & Minimalist</b></td>
      </tr>
    </tbody>
  </table>
</div>

---

## ✨ Key Highlights

```
 ╭──────────────────╮      ╭──────────────────╮      ╭──────────────────╮
 │  ⚡ Instant Sync │      │  📅 Meal Planner │      │  🎨 Adaptive UI  │
 │  Firebase Cloud  │ ───> │  Organize Week   │ ───> │  OLED Dark Mode  │
 │  Google Sign-In  │      │  Breakfast/Lunch │      │  & Light Mode    │
 ╰──────────────────╯      ╰──────────────────╯      ╰──────────────────╯
```

- 🌟 **Adaptive Dark & Light System**: Seamless toggle between an ultra-sleek dark theme (#2C3E50 surfaces with refined emerald accents) and an airy, polished light theme.
- 🔍 **Interactive Discovery & Instant Filtering**: Browse recipes by dynamic tags (Dinner, Lunch, Breakfast, Desserts) with sub-millisecond search query filtering.
- 📅 **Interactive Weekly Meal Planner**: Allocate planned recipes across Monday through Sunday for Breakfast, Lunch, and Dinner with quick-action counters.
- ☁️ **Cloud Synchronization & Google Auth**: One-tap sign-in with Google keeps your personalized meal plans and bookmarked recipes synchronized across all your devices via Cloud Firestore.
- 👤 **Frictionless Guest Experience**: Dive straight into recipes without forced authentication — with tasteful contextual prompts when saving personal lists.
- ⚡ **Performance & Caching**: Powered by `cached_network_image` and optimized local states for smooth 60/120 FPS scrolling and offline-friendly responsiveness.

---

## 🏗️ Project Architecture

Built following clean architecture and state management standards with **Provider**:

```text
lib/
├── core/                   # Design system tokens, color palettes, and themes
│   ├── constants.dart      # Global keys, margins, and app constants
│   └── theme.dart          # Dark & Light ThemeData configurations
│
├── models/                 # Strongly-typed data models
│   ├── recipe.dart         # Recipe data structure, macros & instructions
│   ├── meal_plan.dart      # Weekly scheduled meal models
│   └── user_model.dart     # Firebase user entity
│
├── providers/              # Reactive state controllers (ChangeNotifiers)
│   ├── auth_provider.dart       # User session & Google authentication
│   ├── recipe_provider.dart     # Search, filter, and recipe state
│   ├── favorite_provider.dart   # Bookmarks & favorites state
│   ├── meal_plan_provider.dart  # Weekly scheduling logic & counters
│   └── theme_provider.dart      # Theme persistence & brightness toggle
│
├── repositories/           # Abstracted data access layers
│   ├── recipe_repository.dart   # Local & remote recipe sources
│   └── user_repository.dart     # Cloud Firestore sync & user doc updates
│
├── services/               # Third-party integrations
│   ├── auth_service.dart        # FirebaseAuth & GoogleSignIn integration
│   └── firestore_service.dart   # Firestore CRUD operations
│
└── ui/                     # UI Layer
    ├── screens/            # Application views (Home, Favourites, Planner, Settings)
    └── widgets/            # Modular reusable components (Cards, BottomNav, Chips)
```

---

## 🛠️ Tech Stack & Dependencies

| Category | Technology | Usage |
|---|---|---|
| **Core Framework** | [Flutter](https://flutter.dev/) | Cross-platform UI toolkit |
| **Language** | [Dart](https://dart.dev/) | Null-safe modern client programming language |
| **State Management** | [Provider](https://pub.dev/packages/provider) | Decoupled, reactive state & dependency injection |
| **Backend & Database**| [Cloud Firestore](https://firebase.google.com/products/firestore) | Scalable NoSQL real-time cloud persistence |
| **Authentication** | [Firebase Auth](https://firebase.google.com/products/auth) + [Google Sign-In](https://pub.dev/packages/google_sign_in) | Secure OAuth2 single sign-on |
| **Typography** | [Google Fonts (Inter)](https://fonts.google.com/specimen/Inter) | Clean modern typographical hierarchy |
| **Icons** | [Iconsax](https://pub.dev/packages/iconsax) & Cupertino Icons | Polished outline & bold icon set |
| **Image Caching** | [CachedNetworkImage](https://pub.dev/packages/cached_network_image) | High-efficiency asynchronous image loading |
| **Preferences** | [SharedPreferences](https://pub.dev/packages/shared_preferences) | Local key-value store for theme and user settings |

---

## 🚀 Getting Started

### 1. Prerequisites
Ensure you have the following installed on your machine:
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (`^3.11.1` or higher)
* [Android Studio](https://developer.android.com/studio) or [VS Code](https://code.visualstudio.com/) with Flutter extensions
* An active [Firebase](https://console.firebase.google.com/) project

### 2. Clone & Install
```bash
# Clone the repository
git clone https://github.com/Yeamin-Talukder/Recipe-App.git

# Navigate into project directory
cd Recipe-App

# Fetch dependencies
flutter pub get
```

### 3. Firebase Configuration
1. Activate the FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```
2. Link your Firebase project:
   ```bash
   flutterfire configure
   ```
3. Enable **Google Sign-In** under *Firebase Console > Authentication > Sign-in method*.
4. Enable **Cloud Firestore** rules for authenticated user access.

### 4. Run the Application
```bash
# Run in debug mode on connected device/emulator
flutter run

# Or build release APK directly
flutter build apk --release
```

---

## 📦 Download APK

Pre-built binaries are ready for testing on real Android devices.

* Download the latest release from the [Releases Page](https://github.com/Yeamin-Talukder/Recipe-App/releases).
* **Split ABI Builds**: Built using `--split-per-abi` (`arm64-v8a`, `armeabi-v7a`) for minimum download size and blistering performance.

---

## 🤝 Contributing

Contributions are what make the open-source community such an inspiring place to learn and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'feat: add some amazing feature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 👨‍💻 Author

**MD YEAMEN TALUKDER**
* GitHub: [@Yeamin-Talukder](https://github.com/Yeamin-Talukder)
* Email: [mdyeamen611@gmail.com](mailto:mdyeamen611@gmail.com)

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

<div align="center">
  <sub>Crafted with passion, coffee, and Flutter by MD Yeamen Talukder.</sub>
</div>
