# Currency Exchange Calculator

A Flutter app that calculates real-time exchange rates between FIAT and CRYPTO currencies using a public API.

## Architecture

The app is structured into distinct layers:

- **Models**: Data classes for currencies and API responses
- **Services**: API client and business logic for exchange calculations
- **Providers**: State management using Provider pattern
- **Widgets**: Reusable UI components 
- **Screens**: Screens of the app

## Key Features

- **Auto-calculation**: Exchange rates update automatically as you type (with 500ms debouncing)
- **Input validation**: Amount field limited to 4 digits before decimal, 2 after
- **Responsive design**: Consistent widget heights and overflow handling
- **Real-time API**: Fetches rates from external exchange API

## Internationalization

The app supports English localization using Flutter's built-in i18n system:

- ARB files for string definitions
- Generated localization classes

## Tech Stack

- Flutter 3.x
- Provider for state management
- Dio package for API calls
- Logger for debugging and error tracking
- Comprehensive unit and widget tests

## Getting Started

1. Clone the repo
2. Run `flutter pub get`
3. Run `flutter test` to verify everything works
4. Launch the app with `flutter run` (preferably on a android device)

The app will automatically fetch available currencies and allow you to start calculating exchange rates immediately.
