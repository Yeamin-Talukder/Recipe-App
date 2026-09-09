<h1 align="center">🍽️ Recipe App</h1>

<p align="center">
  A stunning, dark-themed recipe application built with Flutter, Provider, and Firebase. 
  Features a vast database of recipes, smart search, weekly meal planning, and an immersive cooking mode.
</p>

<div align="center">
  
  ![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
  ![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)
  ![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
  ![Provider](https://img.shields.io/badge/Provider-State_Management-blue?style=for-the-badge)
  
  <br>

  [![GitHub release (latest by date)](https://img.shields.io/github/v/release/Yeamin-Talukder/Recipe-App?style=flat-square)](https://github.com/Yeamin-Talukder/Recipe-App/releases)
  [![GitHub all releases](https://img.shields.io/github/downloads/Yeamin-Talukder/Recipe-App/total?style=flat-square)](https://github.com/Yeamin-Talukder/Recipe-App/releases)
  [![Visitors](https://visitor-badge.laobi.icu/badge?page_id=Yeamin-Talukder.Recipe-App)](https://github.com/Yeamin-Talukder/Recipe-App)
  [![License](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square)](LICENSE)

  <br><br>
  <a href="https://github.com/Yeamin-Talukder/Recipe-App/releases/latest">
    <img src="https://img.shields.io/badge/Download_Latest_App-%232ECC71?style=for-the-badge&logo=android&logoColor=white" alt="Download Latest App" />
  </a>

</div>

## ✨ Key Features

- 🎨 **Premium Dark UI**: A breathtaking, dark-mode first design featuring smooth micro-animations, glassmorphism, and vibrant green accents.
- 🍳 **Vast Recipe Database**: 30+ curated, high-quality recipes spanning breakfasts, lunches, dinners, and desserts, complete with gorgeous high-res images.
- 🔍 **Smart Search & Filters**: Effortlessly find your favorite meals based on categories and prep time.
- 📅 **Weekly Meal Planner**: Organize your week with an integrated, intuitive meal planner calendar.
- 👩‍🍳 **Immersive Cooking Mode**: A distraction-free, step-by-step cooking view to guide you seamlessly through the kitchen.
- ☁️ **Firebase Cloud Sync**: Secure Google Sign-In with real-time cloud data storage for favorites and meal plans.
- 👤 **Guest Mode**: Try the app instantly without signing in. Beautifully tailored prompts encourage users to create an account when trying to save favorites.

---

## 📱 App Screenshots

<div align="center">
  <table>
    <tr>
      <td><img src="https://via.placeholder.com/250x500.png?text=Home+Screen" width="200"/></td>
      <td><img src="https://via.placeholder.com/250x500.png?text=Recipe+Details" width="200"/></td>
      <td><img src="https://via.placeholder.com/250x500.png?text=Meal+Planner" width="200"/></td>
      <td><img src="https://via.placeholder.com/250x500.png?text=Cooking+Mode" width="200"/></td>
    </tr>
  </table>
  <p><i>Note: Upload your own screenshots to your repository and replace the placeholder URLs above.</i></p>
</div>

---

## 🚀 Quick Start

### Prerequisites
- [Flutter](https://flutter.dev/docs/get-started/install) SDK (latest version)
- Android Studio or VS Code
- A Firebase Project (for Authentication & Firestore)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Yeamin-Talukder/Recipe-App.git
   cd Recipe-App
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a project on [Firebase Console](https://console.firebase.google.com/)
   - Enable **Authentication** (Google Sign-In) and **Cloud Firestore**
   - Run `flutterfire configure` to connect your project and generate the `firebase_options.dart` file.

4. **Run the app**
   ```bash
   flutter run
   ```

---

## 📦 Download APK

You can download the latest optimized, production-ready APK directly from our [Releases page](https://github.com/Yeamin-Talukder/Recipe-App/releases).

**Optimized File Size**: The app is compiled using AOT, heavily obfuscated, and split per ABI (`arm64-v8a`, `armeabi-v7a`) to ensure the absolute smallest file size possible (usually < 20MB despite including Firebase).

---

## 🏗️ Project Architecture

This project follows a clean, feature-first Provider architecture to ensure separation of concerns:

```text
lib/
├── core/             # Global constants, themes, and design tokens
├── models/           # Dart data classes (Recipe, MealPlan, User)
├── providers/        # State Management (Auth, Recipe, Favorite, Settings)
├── repositories/     # Data Layer & Firebase Integrations
├── services/         # Core external services (AuthService, FirestoreService)
├── ui/
│   ├── screens/      # Full-page views (Home, Recipe Details, Cooking Mode)
│   └── widgets/      # Reusable UI components (RecipeCard, Banner)
└── utils/            # Helper functions and Mock Data
```

---

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **Language**: [Dart](https://dart.dev/)
- **Backend & Auth**: [Firebase](https://firebase.google.com/) (Firestore, Auth)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Icons**: [Iconsax](https://pub.dev/packages/iconsax)

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the [issues page](https://github.com/Yeamin-Talukder/Recipe-App/issues).

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is [MIT](LICENSE) licensed.
