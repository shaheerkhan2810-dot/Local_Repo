# ApexForge: Life Mastery Tracker

A god-tier personal life operating system built with Flutter. Track your purity streak, every life domain, habits, tasks, journal entries, and level up in 4 domains: Discipline, Body, Mind, and Wealth.

## Features

- **NoFap Streak Dashboard** — Giant streak counter, milestone badges (7/30/90/180/365 days), relapse logging with trigger analysis, urge logger with coping tools library
- **Universal Life Trackers** — Unlimited custom trackers with drag-and-drop form builder, heatmaps, charts, progress photos
- **Tasks + Pomodoro** — Daily task manager with recurring tasks, built-in 25/5 Pomodoro timer
- **Gamification** — XP system, 4 domains (Discipline/Body/Mind/Wealth), 17+ levels, unlockable badges
- **Rich Journal** — Mood tracking, photo/video attachments, voice-to-text, auto-save drafts
- **Analytics** — 365-day heatmap, correlation insights, weekly reports, domain radar chart
- **Challenges** — Pre-built challenges (Monk Mode 90 days, Gym 30x, etc.) + custom challenges
- **Morning/Night Routines** — Block-based routine builder with sequential countdown timer
- **Notifications** — Daily reminders, milestone alerts, motivational quotes
- **Offline-First** — Hive local storage + Firestore cloud sync

## Tech Stack

- **Flutter** (iOS + Android)
- **Firebase** (Auth + Firestore + Storage)
- **Riverpod** (state management)
- **go_router** (navigation)
- **Hive** (offline-first local storage)
- **fl_chart** (beautiful charts)
- **Lottie** (animations)

## Setup

### 1. Prerequisites
```bash
flutter --version  # requires >=3.22.0
dart --version     # requires >=3.3.0
```

### 2. Firebase Setup
1. Create a Firebase project at https://console.firebase.google.com
2. Enable Authentication (Email/Password + Google Sign-In)
3. Enable Firestore Database
4. Enable Storage
5. Install FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```
6. Configure Firebase:
   ```bash
   flutterfire configure --project=YOUR_PROJECT_ID
   ```
   This replaces `lib/firebase_options.dart` with your real credentials.

### 3. Deploy Firestore Rules
```bash
npm install -g firebase-tools
firebase login
firebase deploy --only firestore:rules,storage
```

### 4. Download Fonts
Place these in `assets/fonts/`:
- **Rajdhani**: Regular, SemiBold (600), Bold (700)
- **Nunito**: Regular, SemiBold (600), Bold (700)

Available at fonts.google.com

### 5. Install & Run
```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

## Design System

| Token | Value |
|-------|-------|
| Background | `#000000` |
| Surface | `#0D0D0D` |
| Card | `#1A1A1A` |
| Primary Green | `#1B5E20` |
| Accent Gold | `#FFD700` |
| Heading font | Rajdhani |
| Body font | Nunito |

## Domains

| Domain | Color | Description |
|--------|-------|-------------|
| ⚡ Discipline | `#7B1FA2` | Streak, challenges, habits |
| 💪 Body | `#1565C0` | Gym, health, fitness |
| 🧠 Mind | `#00695C` | Study, reading, meditation |
| 💰 Wealth | `#E65100` | Work, finances, skills |

