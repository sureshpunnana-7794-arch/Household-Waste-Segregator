# EcoSort – Household Waste Segregator

A Flutter/Dart college mini-project starter with a polished Material 3 interface.

## Features included
- Dashboard with Eco Points, total recorded waste and recent activity
- Four waste categories: wet, dry, metallic and sanitary
- Add waste entries with item name and quantity
- Local in-memory waste totals and category distribution
- Disposal guide with practical sorting tips
- Daily eco challenge presentation
- Impact dashboard and collection planner demo entry point
- Bottom navigation and responsive scrollable layouts

## Run
1. Install Flutter SDK and Android Studio (or VS Code with Flutter extensions).
2. Extract this project.
3. Open a terminal in the `ecosort` folder.
4. Run:
   ```bash
   flutter pub get
   flutter run
   ```

## Important project notes
This version stores entries in memory, so data resets when the app restarts. For a complete deployed product, add persistent storage (for example, Hive or SQLite), authentication and a backend. Photo-based AI classification, real pickup booking, notifications and a live household leaderboard are extension points and are not represented as already-working integrations.

## Suggested future enhancements
- TensorFlow Lite image classification for waste recognition
- Firebase Authentication and Cloud Firestore
- Local notifications for collection reminders
- Municipal pickup partner integration
- Verified recycling data for environmental impact calculations
