# 𓂀 My Pharogo

> A multi-platform Flutter application for Egyptian cultural tourism, monument discovery, and AI-powered hieroglyph recognition.

<p align="center">
  <img src="assets/images/pyramids.jpg" alt="Ancient Egyptian Monuments App" width="100%">
</p>

<p align="center">
  <img alt="Flutter" src="https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter&logoColor=white">
  <img alt="Python" src="https://img.shields.io/badge/Python-3.x-3776AB?style=flat-square&logo=python&logoColor=white">
  <img alt="TensorFlow" src="https://img.shields.io/badge/TensorFlow-FF6F00?style=flat-square&logo=tensorflow&logoColor=white">
  <img alt="Flask" src="https://img.shields.io/badge/Flask-000000?style=flat-square&logo=flask&logoColor=white">
  <img alt="License" src="https://img.shields.io/badge/license-MIT-green?style=flat-square">
</p>

---

## ✨ Features

- **Monument Discovery** — Explore 10 iconic Egyptian landmarks with rich educational content and direct map integration
- **Hieroglyph Scanner** — Upload or photograph hieroglyphs and get AI-powered translations via a local Python backend
- **Egyptian Design System** — A fully custom light/dark theme with an authentic palette (Pharaoh Gold · Papyrus · Obsidian · Amber)
- **Historical Timeline** — Curated timeline of major Egyptian civilizational periods
- **Cross-Platform** — Runs on Android, iOS, Web, Windows, macOS, and Linux

---

## 📸 App Overview

| Home Dashboard                                                  | Hieroglyph Scanner                                          | Landmark Detail                                         |
| --------------------------------------------------------------- | ----------------------------------------------------------- | ------------------------------------------------------- |
| Hero section, quick actions, statistics, and featured monuments | Camera/gallery image selection with live prediction results | Full-width imagery, map launch, and descriptive content |

---

## 🏗️ Architecture

The project is divided into two main components:

```
finalproject/
├── lib/                        # Flutter frontend
│   ├── main.dart               # App entrypoint
│   ├── src/
│   │   ├── app.dart            # Root MaterialApp + theme wiring
│   │   ├── features/
│   │   │   ├── home/           # Dashboard UI
│   │   │   ├── landmarks/      # Monument data + detail pages
│   │   │   ├── translate/      # Hieroglyph scanner tab
│   │   │   ├── navigation/     # Tab navigation shell
│   │   │   ├── monuments/      # Monument detection stub
│   │   │   ├── chat/           # Chat feature module
│   │   │   └── history/        # History feature module
│   │   └── utils/
│   │       └── maps.dart       # Multi-platform map launcher
│   └── shared/
│       ├── theme/              # AppTheme, ThemeProvider, colors
│       └── utils/              # Landmark icon mapping
├── backend/                    # Python prediction service
│   ├── app.py                  # Flask API server
│   ├── requirements.txt        # Python dependencies
│   └── models/hieromodel/
│       ├── hiero_model.h5      # Trained Keras model
│       ├── labels.json         # Glyph class label map
│       └── history.json        # Training history
├── assets/
│   ├── images/                 # Landmark photo assets
│   └── fonts/                  # Cinzel + Lora typefaces
└── pubspec.yaml
```

---

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.x or later)
- [Python 3.x](https://www.python.org/downloads/)
- [Android Studio](https://developer.android.com/studio) or Xcode (for mobile targets)

---

### 1. Clone the Repository

```bash
git clone https://github.com/omarrrefaatt/MyPharogo.git
cd final project
```

### 2. Configure Environment Variables

Create a `.env` file in the project root:

```env
# Add any runtime configuration values here
```

### 3. Install Flutter Dependencies

```bash
flutter pub get
```

### 4. Set Up the Python Backend

```bash
cd backend
pip install -r requirements.txt
python app.py
```

The Flask server will start at `http://localhost:5000`.

> **Note for Android Emulator:** The app currently targets `http://10.0.2.2:5000/predict` as the backend URL, which maps to `localhost` from within the emulator.

### 5. Run the Flutter App

```bash
flutter run
```

---

## 🔌 Backend API

The prediction service exposes a single endpoint:

**`POST /predict`**

| Field        | Value                 |
| ------------ | --------------------- |
| Content-Type | `multipart/form-data` |
| Field name   | `file`                |
| Payload      | Image file (JPEG/PNG) |

**Response:**

```json
{
  "class": "ankh",
  "confidence": 0.9823
}
```

**Processing pipeline:**

1. Receive image file via multipart form
2. Resize to `224×224` and normalize pixel values
3. Expand dims to `(1, 224, 224, 3)`
4. Run `model.predict(...)` using the trained Keras model
5. Return the highest-scoring label and its confidence score

---

## 🗺️ Landmarks

The app includes curated content for 10 major Egyptian monuments:

| Monument                      | Location |
| ----------------------------- | -------- |
| Great Pyramid of Giza         | Giza     |
| Great Sphinx of Giza          | Giza     |
| Step Pyramid of Djoser        | Saqqara  |
| Valley of the Kings           | Luxor    |
| Mortuary Temple of Hatshepsut | Luxor    |
| Karnak Temple Complex         | Karnak   |
| Luxor Temple                  | Luxor    |
| Abu Simbel Temples            | Aswan    |
| Temple of Philae              | Aswan    |
| Grand Egyptian Museum         | Giza     |

Each landmark includes a name, description, coordinates, and a direct link to open it in Google Maps (with Apple Maps and web fallback).

---

## 🎨 Design System

The app uses an Egyptian-inspired visual language across both light and dark modes:

| Token      | Light Mode          | Dark Mode            |
| ---------- | ------------------- | -------------------- |
| Primary    | Pharaoh Gold        | Ancient Amber        |
| Background | Papyrus / Sandstone | Obsidian / Dark Tomb |
| Text       | Kohl Black          | Warm White           |
| Accent     | Desert Sand         | Ember Orange         |

**Typography:** `Cinzel` (headings & branding) · `Lora` (body text)

Theme selection persists across sessions via `SharedPreferences` and supports `light`, `dark`, and `system` modes.

---

## 🧩 Extending the Project

### Add a New Landmark

1. Place the image under `assets/images/`
2. Register it in `pubspec.yaml` under `flutter.assets`
3. Add an entry to `lib/src/features/landmarks/landmarks_data.dart`

### Add a New Hieroglyph Class

1. Retrain or expand the model with new class data
2. Update `backend/models/hieromodel/labels.json`
3. Replace `backend/models/hieromodel/hiero_model.h5` with the new artifact

### Add a New Tab

1. Create a widget in `lib/src/features/`
2. Add it to `TabsScreen._tabs`
3. Register it in `TabBarView`

---

## ✅ Running Checks

```bash
# Static analysis
flutter analyze

# Run all tests
flutter test

# Start the backend server
cd backend && python app.py
```

---

## ⚠️ Known Limitations

- Backend URL is hardcoded for Android emulator (`10.0.2.2:5000`) — configurable via `.env` in a future update
- The Flask service is for local development only and is not production-hardened
- Model artifact paths in `backend/app.py` may require adjustment for different environments
- No frontend error handling for missing model artifacts

---

## 🛣️ Roadmap

- [ ] Make backend URL configurable via environment variables
- [ ] Add authentication to the prediction API
- [ ] Expand hieroglyph model to support additional glyph classes
- [ ] Add user interaction analytics
- [ ] Harden Flask backend for production deployment
- [ ] Implement full monument AR scanning feature

---

## 📦 Dependencies

**Flutter**

| Package              | Purpose                      |
| -------------------- | ---------------------------- |
| `provider`           | State management             |
| `shared_preferences` | Theme persistence            |
| `http`               | Backend API communication    |
| `image_picker`       | Camera & gallery access      |
| `url_launcher`       | Map deep linking             |
| `permission_handler` | Runtime permission requests  |
| `flutter_dotenv`     | Environment variable loading |

**Python**

| Package                | Purpose             |
| ---------------------- | ------------------- |
| `flask`                | HTTP API server     |
| `tensorflow` / `keras` | Model inference     |
| `numpy`                | Array manipulation  |
| `Pillow`               | Image preprocessing |

---

## 📄 License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

---

<p align="center">
  Built with 🏺 and Flutter · Powered by TensorFlow · Inspired by 5,000 years of history
</p>
