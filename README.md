# Ancient Egyptian Monuments

A polished Flutter application for exploring Egypt's landmark heritage, translating hieroglyphs, and interacting with rich monument content.

## Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [Architecture](#architecture)
- [Repository Structure](#repository-structure)
- [Dependencies](#dependencies)
- [Environment Setup](#environment-setup)
- [Running the App](#running-the-app)
- [Backend Service](#backend-service)
- [Asset & Theme Notes](#asset--theme-notes)
- [Development Workflow](#development-workflow)
- [Contributing](#contributing)
- [License](#license)

## Overview

`Ancient Egyptian Monuments` is a cross-platform Flutter experience designed to showcase iconic Egyptian sites, provide visitor guidance, and support hieroglyph image translation through a lightweight backend service.

The app blends:

- a curated monument discovery experience,
- interactive timelines and travel tips,
- a hieroglyph scanning workflow powered by a local Flask prediction API,
- theming support for light and dark modes.

## Key Features

- **Featured Monuments**: browse a selectable list of landmark cards with detail navigation.
- **Visitor Tips**: travel and preparation guidance for site visits.
- **Historical Timeline**: learn major Egyptian eras with clean timeline cards.
- **Hieroglyph Scanner**: capture or select an image and send it to the backend for symbol recognition.
- **AR Scan Shortcut**: quick access to monument scanning functionality.
- **Theme Toggle**: switch between light and dark appearance.

## Architecture

The project is organized as a two-part system:

1. **Flutter Frontend** (`lib/`)
   - `lib/main.dart` bootstraps the app.
   - `lib/src/app.dart` defines the root `MaterialApp` with theme management.
   - `lib/src/features/` contains feature modules such as `home`, `translate`, `history`, `landmarks`, and `monuments`.
   - `lib/src/shared/` contains reusable theming, colors, and UI utilities.

2. **Python Backend** (`backend/`)
   - `backend/app.py` implements a Flask service exposing a `/predict` endpoint.
   - The backend loads a pre-trained Keras model from `backend/models/hieromodel/hiero_model.h5` and class labels from `backend/models/hieromodel/labels.json`.

The Flutter frontend communicates with the backend at `http://10.0.2.2:5000/predict` when running against an Android emulator.

## Repository Structure

- `lib/`
  - `main.dart` — Flutter entrypoint.
  - `src/app.dart` — app shell, theme provider registration.
  - `src/features/` — feature modules for home, chat, history, translate, landmarks, and monuments.
  - `src/shared/` — shared theme, UI components, utilities.
- `assets/` — application images and fonts.
- `backend/` — Flask prediction service and model artifacts.
- `pubspec.yaml` — Flutter dependencies and asset configuration.

## Dependencies

### Flutter Dependencies

- `flutter`
- `cupertino_icons`
- `http`
- `shared_preferences`
- `provider`
- `url_launcher`
- `image_picker`
- `permission_handler`
- `flutter_dotenv`

### Backend Dependencies

- `Flask`
- `tensorflow`
- `keras`
- `numpy`
- `Pillow`

## Environment Setup

### Prerequisites

- Flutter SDK compatible with Dart `^3.7.0`
- Python 3.10+ for backend service
- Android Studio or Xcode for mobile device/emulator support
- A device or emulator configured for Flutter deployment

### Flutter Setup

1. Open the repository root.
2. Install Flutter dependencies:

```bash
flutter pub get
```

3. Ensure `.env` is available in the project root. The app loads environment values from this file using `flutter_dotenv`.

### Backend Setup

1. Change directory to the backend folder:

```bash
cd backend
```

2. Create and activate a Python virtual environment (recommended):

```bash
python3 -m venv venv
source venv/bin/activate
```

3. Install backend dependencies:

```bash
pip install -r requirements.txt
```

4. Confirm the model and labels exist at:

- `backend/models/hieromodel/hiero_model.h5`
- `backend/models/hieromodel/labels.json`

## Running the App

### Start the Backend Service

From `backend/`:

```bash
python app.py
```

The Flask API listens on `http://127.0.0.1:5000` by default.

### Launch the Flutter App

From the repository root:

```bash
flutter run
```

> Note: When using an Android emulator, the frontend connects to the backend using `http://10.0.2.2:5000/predict`.

If you run on a physical device or a non-Android platform, update the API host accordingly so the device can reach the backend service.

## Backend Service

The Python backend is purpose-built for hieroglyph recognition:

- Receives an uploaded image via multipart form data.
- Resizes input images to `224x224` and normalizes pixels.
- Predicts the class label with the loaded Keras model.
- Returns a JSON response with `class` and `confidence`.

### Important Backend Notes

- The model is loaded once when the Flask app starts.
- The endpoint is defined at `POST /predict`.
- The current frontend expects the response field `class` and uses the numeric prediction confidence.

## Asset & Theme Notes

- Custom fonts are defined in `pubspec.yaml`:
  - `Cinzel`
  - `Lora`
- Image assets are declared in `pubspec.yaml` and stored under `assets/images/`.
- The app includes a dark theme and a light theme managed by `ThemeProvider`.

## Development Workflow

- Use `flutter pub get` after modifying `pubspec.yaml`.
- Keep `backend/app.py` running while testing the hieroglyph scanning feature.
- For UI work, open `lib/src/features/home/home_page.dart` and `lib/src/features/translate/hiero_translate_tab.dart`.
- Use `flutter analyze` to catch static issues and `flutter test` for any widget/unit tests you add.

## Contributing

Contributions are welcome. When adding new features:

1. Keep UI styles consistent with the existing Egyptian heritage theme.
2. Add assets to `pubspec.yaml` and `assets/images/`.
3. Document new routes, API changes, or environment requirements in this README.

## License

This repository does not currently specify a license. Add a `LICENSE` file if you want to define reuse terms.

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
