# Ponto Eletronico

Mini time clock app built with Flutter. The first supported environment is Android, while the code should remain portable for future iOS support.

## Current Scope

- Offline local data.
- Two work periods per day: before lunch and after lunch.
- Large autosave buttons on the home screen.
- Editing is allowed only for the current day.
- Settings screen for the half day value.
- Monthly report with only marked days.
- PDF export planned for sharing reports.

## Development

Install dependencies:

```bash
flutter pub get
```

Run checks:

```bash
flutter analyze
flutter test
```

Run on an Android device or emulator:

```bash
flutter run
```

Build an Android debug APK:

```bash
flutter build apk --debug
```
