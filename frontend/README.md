# ✅ Flutter Socket.io Todo App

A simple mobile application demonstrating **CRUD (Create, Read, Update, Delete)** operations using Flutter. The app uses **BLoC** for state management and follows **Clean Architecture** principles for scalable, maintainable code.

---

## ✨ Features

- ✅ **Create**: Add new items to the list.

- 📖 **Read**: View all items.

- 📝 **Update**: Edit existing items.

- ❌ **Delete**: Remove items from the list.

- ⚙️ **State Management**: Built using the BLoC (Business Logic Component) pattern.
- 🧱 **Clean Architecture**: Separation of data, domain, and presentation layers.

- 🌐 **- Real-time Socket Support**:
  - Live broadcast of add/update/delete events to all connected users.
  - Real-time counter of active users (via Socket.io).

---
## 🧩 Project Structure


lib/
├── data/
│   ├── datasources/
│   │   └── local_todo_datasource.dart
|   |   └── socket_todo_datasource.dart
|   |    
│   ├── models/
│   │   └── todo_model.dart
│   └── repositories/
│       └── todo_repository_impl.dart
│
├── domain/
│   ├── entities/
│   │   └── todo.dart
│   ├── repositories/
│   │   └── todo_repository.dart
│   └── usecases/
│       ├── add_todo.dart
│       ├── delete_todo.dart
│       ├── get_todos.dart
│       └── update_todo.dart
│
├── presentation/
│   ├── bloc/
│   │   ├── todo_bloc.dart
│   │   ├── todo_event.dart
│   │   └── todo_state.dart
│   └── pages/
│   |   └── todo_page.dart
|   └── widgets/
│       └── search_form.dart
|       └── todo_form_widget.dart
│
└── main.dart


## 🚀 Getting Started

### ✅ Prerequisites

- Flutter SDK (>= 3.x)
- Android Studio or VS Code with Flutter plugin
- A connected Android device or emulator

---

## 🛠 Installation

### 1. Clone the Repository

git clone https://github.com/yared098/flutter-socketio-todo-app-.git
cd frontend

###2. Install Dependencies
    flutter pub get

###3 Run the App
   flutter run


Backend Server Setup

The backend is built with Node.js and Socket.IO.

Steps:
   1. cd backend

   2. npm install

   3. npm run dev 



📬 Contact
GitHub: yared098

phone : +251988107722

Email: fdessalew@gmail.com
 
website :https://desst-46d7c-5e781.web.app/
