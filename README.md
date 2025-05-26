# Welcome App - Language Learning Game

This is a Flutter-based language learning application designed to help users practice matching cases of letters. It includes features for tracking game attempts, saving session data, and exporting that data for analysis.

## Project Structure

The core logic and UI components of the application are organized within the `lib/` directory:

-   `main.dart`: The entry point of the Flutter application, setting up the main `MaterialApp` and defining the initial routes.
-   `lib/welcome_screen.dart`: The initial screen of the application, typically where the user starts the game.
-   `lib/match_case_screen.dart`: The main game screen where users interact with the letter matching game. It manages game state, user input, and session attempt collection.
-   `lib/game_end_screen.dart`: The screen displayed after a game session ends. It summarizes the session and provides options, including data export.
-   `lib/database_helper.dart`: A utility class responsible for all database interactions, including creating session-specific databases, saving game attempts, and exporting data to CSV.
-   `lib/styles.dart` and `lib/tailwind_styles.dart`: (If present) These files would contain styling definitions and constants used throughout the application to maintain a consistent look and feel.
-   `assets/`: Contains static assets like fonts and sound files used in the game.

## Core Functionality

### Match the Case Game (`lib/match_case_screen.dart`)

This screen presents a target letter (uppercase) and a set of option letters (lowercase). The user's goal is to tap the matching lowercase letter.

-   **Game Logic**:
    -   Randomly selects a target letter.
    -   Generates a set of unique option letters, including the correct match.
    -   Plays audio feedback for correct/incorrect attempts.
    -   Tracks each `GameAttempt` (correctness and time taken) in an in-memory list (`_sessionAttempts`).
-   **Exit Game**: An "Exit Game" button is provided in the app bar. Tapping this button ends the current game session and navigates the user to the `GameEndScreen`, passing the collected session data.

### Game End Screen (`lib/game_end_screen.dart`)

Displayed upon exiting a game session.

-   **Session Summary**: Shows basic statistics like the total number of attempts in the session.
-   **Download Game Data (CSV)**: Provides a button to export the `_sessionAttempts` data into a CSV file.
-   **Play Again**: Allows the user to return to the welcome screen to start a new game.

### Database Integration (`lib/database_helper.dart`)

The `DatabaseHelper` class manages the persistence of game session data.

-   **Session-Specific Databases**: Instead of a single, persistent database, each game session's attempts are saved to a *new*, uniquely named SQLite database file (e.g., `20240526_123456_789.db`). This ensures that each session's data is isolated and easily manageable.
-   **`_createAttemptsTable`**: Defines the schema for the `attempts` table, storing `correct` (1 for true, 0 for false) and `time_taken` (in milliseconds).
-   **`saveAttemptsToNewDb(String dbFileName, List<Map<String, dynamic>> attemptsData)`**: Takes a list of game attempts (converted to `Map<String, dynamic>`) and saves them to the specified new database file.
-   **`exportAttemptsToCsv(String dbFileName)`**: Reads data from a given session database file, converts it into a CSV string, and returns it.
-   **`downloadCsv(String csvContent, String fileName)`**: Handles requesting storage permissions, writing the CSV content to a file in the device's documents directory, and then attempting to open the file using `open_filex`.

## Data Model (`GameAttempt` in `lib/match_case_screen.dart`)

The `GameAttempt` class is a simple data model used to represent a single attempt within a game session:

```dart
class GameAttempt {
  final bool wasCorrect;
  final int timeTakenMs;

  GameAttempt({required this.wasCorrect, required this.timeTakenMs});

  Map<String, dynamic> toMap() {
    return {
      'correct': wasCorrect ? 1 : 0,
      'time_taken': timeTakenMs,
    };
  }
}
```
The `toMap()` method is crucial for converting `GameAttempt` objects into a format suitable for insertion into the SQLite database.

## Dependencies

Key dependencies used in this project (defined in `pubspec.yaml`):

-   `flutter`: The core Flutter framework.
-   `sqflite`: SQLite plugin for Flutter, used for local database operations.
-   `path_provider`: Provides platform-specific access to the file system locations.
-   `permission_handler`: Handles runtime permissions (e.g., storage access) for Android and iOS.
-   `path`: A cross-platform path manipulation library.
-   `audioplayers`: For playing audio files (e.g., letter sounds, success/failure sounds).
-   `intl`: For internationalization, specifically used here for date formatting to create unique database filenames.
-   `csv`: For converting lists of data into CSV format.
-   `open_filex`: For opening files on the device after they are saved (e.g., opening the generated CSV).

## How to Run

1.  **Clone the repository**:
    ```bash
    git clone [repository_url]
    cd welcome_app
    ```
2.  **Get Flutter dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Run the application**:
    ```bash
    flutter run
    ```
    Ensure you have a device or emulator connected.

This project aims to provide a robust and extensible foundation for a language learning game, with a focus on clear code structure and data management.
