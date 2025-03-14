# DevBank Flutter Application

## 📌 Project Overview

DevBank is a cross-platform mobile banking application built using **Flutter**. The app provides secure authentication, real-time financial data display, secure payments, and seamless UI/UX. It uses **Riverpod** for state management, **RESTful/GraphQL API integration**, and **Firebase push notifications**.

## 📂 Project Structure

```
repo-root/
 ├── src/
 │    ├── devbank/  # Flutter project folder
 │    │    ├── lib/
 │    │    ├── android/
 │    │    ├── ios/
 │    │    ├── pubspec.yaml
 │    │    ├── main.dart
 │    │    └── ...
 ├── README.md
 ├── .gitignore
 └── (other repo files)
```

---

## 🛠️ Setup Instructions

### 1️⃣ Prerequisites

Ensure you have the following installed:

- **Flutter SDK**: [Install Flutter](https://flutter.dev/docs/get-started/install)
- **Dart SDK** (included with Flutter)
- **Android Studio/Xcode** (for Android/iOS development)
- **VS Code/Android Studio** (recommended IDEs)
- **Git**: [Install Git](https://git-scm.com/downloads)

### 2️⃣ Clone the Repository

```sh
git clone https://github.com/devt1412/XNL-21BIT0290-MAD-1.git
cd XNL-21BIT0290-MAD-1/src/devbank
```

### 3️⃣ Install Dependencies

```sh
flutter pub get
```

### 4️⃣ Run the Application

For Android:

```sh
flutter run
```

For iOS:

```sh
flutter run --no-sound-null-safety
```

For Web:

```sh
flutter run -d chrome
```

---

## 🔄 Version Control (Git)

### Initializing Git (If Not Set Up)

```sh
git init
git remote add origin https://github.com/devt1412/XNL-21BIT0290-MAD-1.git
git pull origin main --rebase
```

### Regular Workflow

1. **Check status:**
   ```sh
   git status
   ```
2. **Add changes:**
   ```sh
   git add .
   ```
3. **Commit changes:**
   ```sh
   git commit -m "Your commit message"
   ```
4. **Push changes to GitHub:**
   ```sh
   git push origin main
   ```

---

## ⚡ Project Guidelines

### Branching Strategy

- `main` - Stable release
- `dev` - Development branch
- Feature branches (e.g., `feature/login-screen`)

### Code Style

- Follow **Flutter’s best practices**
- Use **Riverpod** for state management
- Keep UI and business logic separate

---

## 🛡️ Security Measures

- API keys and sensitive data **must not be committed** (Use `.env` or Firebase)
- Always **pull latest changes** before pushing

---

##
