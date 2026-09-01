# Movie Explorer App

A modern Flutter-based movie discovery application that lets users browse popular movies, filter by genre, search titles, save favorites, and manage account authentication with Firebase.

The app integrates with The Movie Database (TMDB) API for live movie data and uses Firebase for authentication, user management, and persistent favorites.

## Features

- Email/password authentication
- Google Sign-In
- Movie browsing from TMDB
- Search and filter options
- Genre-based movie exploration
- Favorite movie saving
- Admin panel for movie management
- AI-style movie assistant/chat experience
- Remember-me functionality for login credentials
- Sleek dark UI with gradient-styled cards

## Tech Stack

- Flutter & Dart
- Firebase Authentication
- Firebase Firestore
- Google Sign-In
- TMDB API
- Provider for state management
- SharedPreferences for local persistence
- Flutter Dotenv for environment configuration

## Project Structure

- [demo/lib](demo/lib) — application source code
- [demo/lib/Pages](demo/lib/Pages) — screens such as login, signup, home, genres, movies, and admin panel
- [demo/lib/Components](demo/lib/Components) — reusable UI components
- [demo/lib/Providers](demo/lib/Providers) — state providers for movies and favorites
- [demo/lib/utils](demo/lib/utils) — helper functions and API utilities
- [demo/pubspec.yaml](demo/pubspec.yaml) — Flutter project dependencies
- [demo/.env](demo/.env) — environment variables for API access

## Getting Started

### Prerequisites

Before running the app, make sure you have:

- Flutter SDK installed
- Android Studio or VS Code with Flutter support
- A Firebase project configured
- A valid TMDB API read access token

### 1. Clone the project

```bash
git clone <repository-url>
cd Movie_Explorer_App
```

### 2. Install dependencies

```bash
cd demo
flutter pub get
```

### 3. Configure Firebase

Create or connect a Firebase project and add the app configuration files as required for Android/iOS/Web.

Make sure Firebase services are initialized correctly in the app startup flow.

### 4. Configure environment variables

Create a file named `.env` inside the [demo](demo) folder and add your TMDB token:

```env
TMDB_READ_ACCESS_TOKEN=your_tmdb_access_token_here
```

### 5. Run the app

```bash
flutter run
```

You can also target a specific device:

```bash
flutter run -d <device-id>
```

## App Flow

1. Users sign in or create an account.
2. They land on the main home screen.
3. Movies are loaded from TMDB and displayed in the app.
4. Users can search, filter by genre, and mark movies as favorites.
5. Admin users can manage movies through the admin panel.
6. Users can open a movie assistant to discover films based on preferences.

## Screens

- Login / Signup
- Home Dashboard
- Movies Feed
- Genre Explorer
- Movie Details
- Favorites
- Search
- Profile
- Admin Panel
- Chatbot Assistant

## Notes

- The app uses Firebase for secure user authentication and real-time data.
- The TMDB token must remain in the `.env` file and should not be committed to public repositories.
- This project is designed as a Flutter app for mobile and cross-platform use.

## License

This project is for educational and personal project use. Add an appropriate license if you plan to distribute or publish it publicly.

## Author

Movie Explorer App
