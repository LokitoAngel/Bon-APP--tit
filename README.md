# Bonappetit

Bonappetit is a Flutter-based mobile application designed for young adults or university students living away from home. The app provides a practical way to discover, save, and organize basic, quick, and easy-to-prepare recipes, especially suitable for meal prepping and storing in containers (topers).

## Features

- Browse categorized recipes such as breakfast, vegan, main courses, and more
- Mark recipes as favorites
- Add recipes to a shopping list
- Automatically calculate total ingredients needed
- Generate and print shopping lists in PDF format
- Watch embedded YouTube videos for step-by-step tutorials
- Switch between light and dark mode
- View user profile and app preferences

## Project Structure

```
lib/
├── pages/              # Main screens (home, list, favorites, etc.)
│   ├── widgets/        # UI components specific to pages
├── providers/          # State management (favorites, list)
├── theme/              # Theme switching logic and configuration
├── widgets/            # Global reusable widgets
└── main.dart           # Application entry point

assets/
├── General.json        # Recipe data
└── Users.json          # User profile data
```

## Installation

To run the app locally:

```bash
git clone https://github.com/your-username/bonappetit.git
cd bonappetit
flutter pub get
flutter run
```

## Dependencies

This project uses the following packages:

- provider
- youtube_player_flutter
- pdf
- printing
- cupertino_icons

## Contributors

- LokitoAngel  
- Carlos161104  

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
