# Dhikr Counter

A modern, responsive Flutter application for tracking Islamic recitations (Dhikr).

---

## 📋 Project Overview

**Dhikr Counter** is a spiritual and practical tool designed to help users:

- **Count recitations** with an intuitive, large circular orb interface
- **Track progress** with visual indicators (counter, percentage complete, progress bar)
- **Manage sessions** by setting custom goals from presets (10, 25, 50, 100) or entering custom values
- **Switch between phrases** among multiple Islamic recitations (Subhanallah, Alhamdulillah, Allahu Akbar)
- **Persist data** across app restarts using SharedPreferences
- **Daily reset** mechanism that automatically resets session counters while preserving lifetime counts

### Key Features

- ✨ **Beautiful UI** - Modern design with golden accents and smooth animations
- 📊 **Visual feedback** - Linear progress indicator showing session completion percentage
- 💾 **Data persistence** - All user data saved locally (goals, counts, preferences)
- 📱 **Responsive design** - Adapts to different screen sizes with compact mode for small devices
- ⚡ **Fast & lightweight** - Minimal dependencies, optimized performance
- 🎯 **Session management** - Editable goals and one-tap session reset

---

## 🚀 Setup Instructions

### Prerequisites

- Flutter SDK: `>=3.0.0` (check with `flutter --version`)
- Dart SDK: Included with Flutter
- A code editor (VS Code, Android Studio, or IntelliJ IDEA)
- An emulator or physical device for testing

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/JubaerFaysal/Dhikr_Counter.git
   cd dhikr_counter
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # On emulator/device
   flutter run
   
   # Release build (optimized)
   flutter run --release
   ```


### Supported Platforms

- ✅ Android (API level 21+)
- ✅ iOS (13.0+)
- ✅ Web
- ✅ Linux
- ✅ macOS
- ✅ Windows

---

## 📁 Project Structure

```
dhikr_counter/
├── lib/
│   ├── main.dart                         
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   └── app_constants.dart                
│   │   ├── services/
│   │   │   └── shared_preferences_service.dart  
│   │   ├── theme/
│   │   │   └── app_theme.dart             
│   │   └── utils/
│   │       └── helpers.dart              
│   │
│   └── features/
│       └── dhikr/
│           ├── data/
│           │   ├── models/
│           │   │   └── dhikr_model.dart   
│           │   └── repositories/
│           │       └── dhikr_repository.dart  
│           │
│           └── presentation/
│               ├── providers/
│               │   └── dhikr_provider.dart    
│               ├── screens/
│               │   └── dhikr_screen.dart      
│               └── widgets/
│                   ├── circle_button.dart     
│                   ├── counter_display.dart   
│                   ├── goal_picker.dart       
│                   ├── increment_button.dart        
│                   └── reset_button.dart     
│                 
│
├── pubspec.yaml                           
├── analysis_options.yaml                 
└── README.md                              
```

### Architecture Pattern: MVVM with Riverpod

**Flow:** UI → ViewModel (Provider) → Repository → Service → SharedPreferences

---

## 🔄 State Management (Riverpod)

The app uses **Riverpod** for reactive, compile-safe state management.

### Providers

#### 1. **Dhikr ViewModel Provider** (`features/dhikr/presentation/providers/dhikr_provider.dart`)

```dart
final dhikrViewModelProvider = NotifierProvider<DhikrViewModel, DhikrModel>((ref) {
  final repository = ref.watch(dhikrRepositoryProvider);
  return DhikrViewModel(repository);
});
```

- **Purpose:** Manages dhikr counter, goals, and phrase selection
- **State type:** `DhikrModel` (contains count, goal, lifetimeCount, currentDhikrIndex, etc.)
- **Key methods:**
  - `recite()` - Increments count if below goal, triggers debounced save
  - `switchDhikr()` - Rotates to next phrase
  - `updateGoal(int newGoal)` - Sets session goal
  - `resetSession()` - Resets count to 0, preserves lifetime count
  - `_normalizeForToday()` - Auto-resets daily counters when new day detected
- **Debouncing:** Saves persist after 200ms of inactivity (prevents excessive disk writes)

#### 2. **Repository Provider** (`features/dhikr/data/repositories/dhikr_repository.dart`)

```dart
final dhikrRepositoryProvider = Provider<DhikrRepository>((ref) {
  throw UnimplementedError('Must be overridden in main.dart');
});
```

- **Purpose:** Provides abstraction for persistence
- **Implementations:**
  - `SharedPrefsDhikrRepository` - Uses SharedPreferences (production)
  - `InMemoryDhikrRepository` - In-memory storage (testing)

#### 3. **SharedPreferences Service Provider**

```dart
final sharedPreferencesServiceProvider = Provider<SharedPreferencesService>((ref) {
  throw UnimplementedError('Must be overridden in main.dart');
});
```

- **Purpose:** Provides unified persistence interface
- **Methods:**
  - Theme: `getTheme()`, `setTheme(bool isDark)`
  - Dhikr: `loadDhikrState()`, `saveDhikrState(DhikrModel model)`

### Provider Initialization (`main.dart`)

```dart
ProviderScope(
  overrides: <Override>[
    dhikrRepositoryProvider.overrideWithValue(
      SharedPrefsDhikrRepository(service),
    ),
  ],
  child: const MyApp(),
)
```

- Providers are overridden at app startup with actual implementations
- Tests override with mocks (no real SharedPreferences needed)

### State Flow Example: User taps orb

```
User tap → IncrementButton.onTap() 
  → viewModel.recite() [watched from provider]
  → state.count++
  → _debounce timer starts (200ms)
  → After 200ms: repository.saveState()
  → UI rebuilds with new count via ref.watch(dhikrViewModelProvider)
```

---

## 📌 Assumptions Made

1. **Single User Per Device** - No multi-user support; data persists for one user
2. **Daily Reset Based on System Date** - Uses device date (YYYY-MM-DD) to detect new day
3. **Offline-First** - App works entirely offline; no cloud sync
4. **Session Goals** - Recitation count stops incrementing after reaching goal (visual-only, no lock)
5. **Lifetime Tracking** - Lifetime count auto-increments whenever session count does
6. **Fixed Phrase Set** - Three core Islamic phrases; not user-editable
7. **No Auth Required** - No login/account system

---

## ✨ Improvements & Creative Additions

### 1. **LinearProgressIndicator()**
- **Purpose:** Visualizes session progress percentage
- **Implementation:** `value: state.progress` where `progress = count / goal`
- **Styling:** Golden color (0xFFD2B44F) with dark background for contrast
- **Benefit:** Users see at-a-glance how close they are to the session goal

### 2. **ResetButton()**
- **Purpose:** One-tap session reset without losing lifetime count
- **Implementation:** Calls `viewModel.resetSession()`
- **Behavior:** Resets `count` to 0, preserves `lifetimeCount`
- **Benefit:** Enables quick start of new session while maintaining historical progress

### 3. **Responsive Design with Breakpoints**
- **Compact Mode:** Triggered at `width < 380px`
- **Adaptive Sizing:**
  - Orb size: `width * 0.66` (scales proportionally)
  - Header title: `compact ? 24 : 26` font size
  - Text in orb: Percentage-based (`orbSize * 0.120` for Arabic, etc.)
- **Benefit:** Seamless experience on phones, tablets, and landscape modes

### 4. **Daily Auto-Reset Mechanism**
- **Function:** `_normalizeForToday()` in DhikrViewModel
- **Logic:** Compares `lastActiveDate` with today's date
- **Effect:** Resets daily counters on app launch if new day detected
- **Benefit:** Clean tracking of "daily global count" separate from lifetime

### 5. **Debounced Persistence**
- **Implementation:** 200ms `Timer` in `recite()` method
- **Effect:** Saves user data only after inactivity
- **Benefit:** Reduces disk writes, improves performance during rapid taps

### 6. **Custom Goal Dialog**
- **Features:** Preset buttons (10, 25, 50, 100) + custom input field
- **Validation:** Only accepts positive integers, disables save button for invalid input
- **UX:** Bottom sheet for presets, modal dialog for custom entry
- **Benefit:** Flexible goal setting without forced presets

### 7. **Shared Phrases with Translations**
- **Data Model:** `DhikrPhraseModel` with `arabic`, `english`, `meaning` fields
- **Display:** All three layers shown in the orb for educational value
- **Flexibility:** Easy to add more phrases by extending the `phrases` list

### 8. **Unified Persistence Service**
- **Consolidation:** Single `SharedPreferencesService` handles all storage 
- **Benefit:** Centralized, maintainable persistence logic; no duplicate code

---


## 📦 Dependencies

- **flutter_riverpod** - State management
- **shared_preferences** - Local persistence
- **flutter** - Framework

See `pubspec.yaml` for exact versions.

---

## 🎨 Theme Colors

### Dark Theme
- Scaffold: `#050608` (deep black)
- Accent: `#B79B43` (golden)
- Text: White with gray accents

---

## 📝 License

This project is open source.

---


## 📞 Support

For questions, bug reports, or support, please reach out using any of the following:

- **Email:** [jubaerfaysal@gmail.com](mailto:jubaerfaysal@gmail.com)
- **Phone:** +8801641420456

We're here to help and appreciate your feedback!

---

**Built with ❤️ using Flutter & Riverpod**
