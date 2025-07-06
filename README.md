# Notes App with Firebase

A Flutter application for taking notes with Firebase authentication and Firestore database integration.

## Features

- **Authentication**: Email and password signup/login using Firebase Auth
- **CRUD Operations**: Create, Read, Update, and Delete notes
- **Real-time Sync**: Notes are stored in Firestore and sync across devices
- **User-specific Data**: Each user has their own private notes
- **Modern UI**: Beautiful Material Design 3 interface
- **Empty State**: Friendly message when no notes exist

## Screenshots

### Authentication Screen
- Clean login/signup interface with toggle between modes
- Form validation for email and password
- Loading states and error handling

### Notes Screen
- List of user's notes with timestamps
- Add new notes via floating action button
- Edit and delete notes with confirmation dialogs
- Empty state message: "Nothing here yet—tap ➕ to add a note."
- Pull-to-refresh functionality

## Setup Instructions

### 1. Firebase Project Setup

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select an existing one
3. Enable Authentication:
   - Go to Authentication > Sign-in method
   - Enable Email/Password provider
4. Enable Firestore Database:
   - Go to Firestore Database
   - Create database in test mode (for development)
   - Set up security rules (see below)

### 2. Firebase Configuration

#### Android Setup
1. In Firebase Console, go to Project Settings > General
2. Add Android app with package name: `com.example.note_app_v2`
3. Download `google-services.json` and replace the placeholder file in `android/app/`
4. The build.gradle files are already configured

#### iOS Setup
1. In Firebase Console, go to Project Settings > General
2. Add iOS app with bundle ID: `com.example.noteAppV2`
3. Download `GoogleService-Info.plist` and replace the placeholder file in `ios/Runner/`

### 3. Firestore Security Rules

Set up the following security rules in your Firestore Database:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own notes
    match /users/{userId}/notes/{noteId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### 4. Install Dependencies

Run the following command to install all required dependencies:

```bash
flutter pub get
```

### 5. Run the App

```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point with Firebase initialization
├── models/
│   └── note.dart            # Note data model
├── services/
│   ├── auth_service.dart    # Firebase authentication service
│   └── notes_service.dart   # Firestore CRUD operations
└── screens/
    ├── auth_screen.dart     # Login/signup screen
    └── notes_screen.dart    # Main notes list screen
```

## CRUD Operations Implementation

The app implements all four CRUD operations as specified:

- **Create**: `await addNote(text)` - Add a new note via dialog
- **Read**: `await fetchNotes()` - Fetch all notes from Firestore
- **Update**: `await updateNote(id, text)` - Edit a note via edit icon
- **Delete**: `await deleteNote(id)` - Delete a note via delete icon

## Features in Detail

### Authentication Flow
- Users can sign up with email and password
- Users can sign in with existing credentials
- Automatic routing between auth and notes screens
- Sign out functionality in the app bar

### Notes Management
- Notes are displayed in a list with timestamps
- Each note shows when it was last updated
- Notes are sorted by most recently updated
- Empty state shows helpful message for new users

### User Experience
- Loading indicators during operations
- Error handling with user-friendly messages
- Form validation for all inputs
- Confirmation dialogs for destructive actions
- Pull-to-refresh for manual sync

## Dependencies

- `firebase_core`: Firebase initialization
- `firebase_auth`: Authentication services
- `cloud_firestore`: Database operations
- `flutter`: Core Flutter framework

## Development Notes

- The app uses Material Design 3 for modern UI
- All Firebase operations are properly error-handled
- The code follows Flutter best practices
- Authentication state is managed using Firebase Auth streams
- Notes are stored per user in Firestore subcollections

## Troubleshooting

1. **Firebase not initialized**: Make sure you've replaced the placeholder configuration files
2. **Authentication errors**: Verify that Email/Password provider is enabled in Firebase Console
3. **Database errors**: Check Firestore security rules and ensure database is created
4. **Build errors**: Run `flutter clean` and `flutter pub get` to refresh dependencies

## License

This project is created for educational purposes.
