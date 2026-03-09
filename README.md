# DietApp
Final Project for my IOS development  course at ABB Innovation.


# 🥗 DietApp

A modern iOS meal planning application built with **SwiftUI** and **Firebase**. DietApp allows users to explore recipes, manage their favorites, build personalized weekly diet plans, and track meals — all with a clean, intuitive interface.

---

## 📱 Screenshots

| Login | Main | Detail | My Diet | Profile |
|-------|------|--------|---------|---------|
| Auth screen with Sign In / Sign Up | Recipe grid with category filters | Full recipe detail with ingredients & steps | Weekly diet plan grouped by day | Profile with dark mode & photo upload |

---

## 🚀 Features

### Authentication
- Email/password **Sign In** and **Sign Up** via Firebase Auth
- Persistent session — users stay logged in across app launches
- Real-time auth state listener — automatic routing between Login and Main
- Secure logout with confirmation dialog

### Recipe Discovery
- Browse all recipes in a responsive **2-column grid**
- Filter by category: Breakfast, Lunch, Dinner, Desserts, Vegan, Fast Food, SeaFood, Snack
- Animated rotating greeting banner on the home screen
- Full **DetailView** with header image, cooking time, calories, category, ingredients, and step-by-step instructions

### Search & Filter
- Real-time recipe search by title
- Advanced filter sheet with:
  - Multi-select category chips
  - **Custom dual-handle RangeSlider** for cooking time (0–120 min)
  - **Custom dual-handle RangeSlider** for calories (0–1200 kcal)

### Favorites
- Add/remove recipes to favorites directly from the recipe card
- Favorites stored per user in Firestore (`users/{uid}/favorites/{recipeId}`)
- Swipe-to-delete with instant UI update
- Full recipe data (including ingredients & instructions) preserved in favorites

### My Diet — Weekly Planner
- Create a personalized weekly meal plan
- Select recipes per day of the week (Monday → Sunday)
- Visual day-selector with per-day recipe count badges
- Diet plan **persisted to Firestore** — survives app restarts
- Weekly summary: dishes count + total calories per day
- Horizontal recipe card scroll per day

### Profile
- Display name and email from Firebase Auth
- **Profile photo** — pick from gallery or take with camera
- **Header background photo** — fully customizable
- Photos saved locally via `@AppStorage` (UserDefaults)
- **Dark Mode toggle** — persists across launches
- Logout with confirmation alert

---

## 🏗 Architecture

The app follows the **MVVM (Model-View-ViewModel)** pattern:

```
DietApp/
├── App/
│   ├── DietAppApp.swift          # @main entry point, Firebase setup
│   └── RootView.swift            # Auth state router (Splash → Login / Main)
│
├── Models/
│   ├── Recipe.swift              # Codable recipe model
│   └── DietDayPlan.swift         # Weekly plan model
│
├── Services/
│   ├── FirebaseAuth.swift        # FirebaseAuthService (singleton, ObservableObject)
│   └── RecipeService.swift       # Firestore recipe fetch (single source of truth)
│
├── Screens/
│   ├── LoginView.swift           # Sign In + Sign Up navigation
│   ├── SignUpView.swift          # Registration with validation
│   ├── SplashView.swift          # Launch animation
│   ├── MainView/                 # Recipe grid + category filter
│   ├── SearchView/               # Search + FilterSheetView
│   ├── FavoritesView/            # Saved recipes list
│   ├── Detail/                   # Full recipe detail
│   ├── MyDietView/               # Weekly diet planner
│   └── ProfileView/              # User profile & settings
│
├── ExternalViews/
│   ├── RecipeCard.swift          # Reusable grid card
│   ├── FavoritesRowView.swift    # Reusable list row
│   ├── AddDishCard.swift         # Selection card for diet planner
│   ├── DietRecipeCard.swift      # Horizontal scroll card for diet plan
│   ├── FilterSheetView.swift     # Advanced filter bottom sheet
│   ├── RangeSlider.swift         # Custom dual-handle range slider
│   └── WrapCategoriesView.swift  # Wrapping category chip grid
│
├── Enums/
│   ├── WeekDay.swift             # Mon–Sun enum
│   └── RecipeCategory.swift      # All recipe categories enum
│
├── Extensions/
│   └── Extensions.swift          # cornerRadius(corners:) + Color(hex:)
│
├── ImagePicker/
│   └── ImagePicker.swift         # UIImagePickerController SwiftUI wrapper
│
└── Tabbars/
    └── MainTabbarView.swift      # 5-tab navigation
```

---

## 🗄 Firestore Data Model

```
recipes/
└── {recipeId}/
    ├── title:        String
    ├── category:     String
    ├── cookingTime:  Int
    ├── calories:     Int
    ├── imageUrl:     String
    ├── ingredients:  [String]
    └── instructions: [String]

users/
└── {uid}/
    ├── favorites/
    │   └── {recipeId}/
    │       ├── title, cookingTime, calories, imageUrl, category
    │       ├── ingredients:  [String]
    │       └── instructions: [String]
    │
    └── dietPlan/
        └── {weekDay}/          # "Monday", "Tuesday", ...
            └── recipeIds: [String]
```

---

## 🛠 Tech Stack

| Technology | Usage |
|------------|-------|
| **SwiftUI** | All UI — declarative, reactive views |
| **Firebase Auth** | User authentication (email/password) |
| **Cloud Firestore** | Recipe database, favorites, diet plans |
| **Combine** | `ObservableObject` + `@Published` reactive state |
| `@AppStorage` | Dark mode preference, profile/header image persistence |
| `UIImagePickerController` | Camera & photo library access |
| `GeometryReader` | Responsive image sizing in DetailView |
| `LazyVGrid` / `LazyVStack` | Performant recipe grids |

---

## ⚙️ Setup & Installation

### Prerequisites
- Xcode 15+
- iOS 16.0+ deployment target
- A Firebase project with **Authentication** and **Firestore** enabled

### Steps

**1. Clone the repository**
```bash
git clone https://github.com/your-username/DietApp.git
cd DietApp
```

**2. Install Firebase via Swift Package Manager**

In Xcode: `File → Add Package Dependencies`
```
https://github.com/firebase/firebase-ios-sdk
```
Add the following packages:
- `FirebaseAuth`
- `FirebaseFirestore`

**3. Configure Firebase**

- Go to [Firebase Console](https://console.firebase.google.com)
- Create a new iOS app with your bundle ID
- Download `GoogleService-Info.plist`
- Drag it into `DietApp/Resources/` in Xcode (make sure "Copy items if needed" is checked)

**4. Set up Firestore**

Create a `recipes` collection with documents using this structure:
```json
{
  "title": "Grilled Chicken Salad",
  "category": "Lunch",
  "cookingTime": 30,
  "calories": 340,
  "imageUrl": "https://your-image-url.com/chicken.jpg",
  "ingredients": ["Chicken breast", "Lettuce", "Tomato", "Olive oil"],
  "instructions": ["Season the chicken", "Grill for 15 min", "Toss with salad"]
}
```

**5. Enable Firebase Auth**

In Firebase Console → Authentication → Sign-in method → Enable **Email/Password**

**6. Firestore Security Rules (recommended)**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /recipes/{id} {
      allow read: if request.auth != null;
    }
    match /users/{uid}/{document=**} {
      allow read, write: if request.auth.uid == uid;
    }
  }
}
```

**7. Build & Run**

Select your simulator or device and press `⌘R`.

---

## 📋 Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+
- Active internet connection (Firebase)
- Camera & Photo Library permissions (for profile photo — add to `Info.plist`):

```xml
<key>NSCameraUsageDescription</key>
<string>Used to set your profile and header photos</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Used to select your profile and header photos</string>
```

---

## 🔮 Future Improvements

- [ ] **Google & Apple Sign In** (buttons are present, implementation pending)
- [ ] **Firebase Storage** for profile photo upload (currently stored locally)
- [ ] **Push Notifications** — daily meal reminders
- [ ] **Custom recipe creation** — "My Own" tab in diet planner
- [ ] **Nutrition tracking** — macros (protein, carbs, fat) per recipe
- [ ] **Offline support** — Firestore persistence mode
- [ ] **async/await** migration from completion handlers
- [ ] **PHPickerViewController** migration from UIImagePickerController
- [ ] **Widget** — today's meal plan on home screen

---

## 👤 Author

**Omar Yunusov**
- Built with SwiftUI + Firebase
- March 2026

