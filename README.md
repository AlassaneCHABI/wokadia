
# 📘 Wokadia

**Wokadia** is a modern **e-learning mobile application** built with Flutter.  
It offers a smart, interactive, and offline-friendly learning experience — helping learners access courses, play educational games, and track progress anytime, anywhere.

---

##  Key Features

- **Authentication** – Secure login and registration system  
- **History Tracking** – Keep track of completed courses and quiz attempts  
- **Download & Local Storage** – Access downloaded content offline  
- **Course Management** – Follow courses and take quizzes seamlessly  
- **Word Games** – Engage in fun, educational word games  
- **Data Synchronization** – Sync data between local and remote servers  

---

## Tech Stack

| Layer | Technology |
|-------|-------------|
| **Frontend** | Flutter (Dart) |
| **Backend** | Laravel |
| **Database** | SQLite (local), MySQL (server) |
| **Architecture** | MVC / Modular |
| **API Type** | RESTful |

---

## ⚙️ Installation

### 1️⃣ Clone the repository
```bash
git clone https://github.com/AlassaneCHABI/wokadia.git
cd wokadia
````

### 2️⃣ Install dependencies

```bash
flutter pub get
```

### 3️⃣ Run the app

```bash
flutter run
```

---

##  Configuration

1. Set your API URL in the config file:

   ```dart
   const String API_URL = "https://your-laravel-backend.com/api";
   ```
2. Ensure your Laravel backend is running and accessible.

---

##  Project Structure

```
lib/
 ├── feature/
 │   ├── auth/           # Authentication & user sessions
 │   ├── home/           # Home screen and navigation
 │   ├── cours/          # Courses and lessons
 │   ├── jeux/           # Word games and interactive modules
 │   ├── historique/     # History & progress tracking
 │   ├── utils/          # Local storage, preferences, constants
 │   └── widget/         # Reusable UI components
 ├── models/             # Data models (User, Course, Quiz, etc.)
 ├── services/           # API and database services
 └── main.dart           # App entry point
```

---


## 📸 Screenshots

| Home                             | Course                               | Quiz                             | Profile                                |
| -------------------------------- | ------------------------------------ | -------------------------------- | -------------------------------------- |
| ![Home](assets/screens/home.png) | ![Course](assets/screens/course.png) | ![Quiz](assets/screens/quiz.png) | ![Profile](assets/screens/profile.png) |

---

## 👨🏽‍💻 Author

**Alassane CHABI**
💼 Flutter & Laravel Developer
📧 [alassanechabi5@gmail.com](mailto:your.email@example.com)


---

## 🙌 Acknowledgements

* Flutter & Dart Team
* Laravel Community
* Open Source Flutter Packages
* Everyone contributing to digital education 💙

---
