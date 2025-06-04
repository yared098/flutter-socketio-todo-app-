File stracture

lib/
├── data/
│   ├── datasources/
│   │   └── local_todo_datasource.dart
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
│       └── todo_page.dart
│
└── main.dart


# Flutter Todo App (Clean Architecture + Socket.IO)

A robust and scalable **Flutter Todo CRUD application** built with **Clean Architecture** and **Bloc state management**. The app supports two data sources: **real-time updates via Socket.IO** and **local state management**. If the Socket.IO server is online, all operations are synchronized across clients in real time. If it's offline, operations fall back to the local state.

---

## ✨ Features

-  Clean Architecture for better scalability and testability
-  State management using `flutter_bloc`
-  Real-time communication with Socket.IO
-  Offline support via local state fallback
-  Add, update, delete, and search todos
-  Integrated search bar
-  Responsive UI with modern UX

---

##  Architecture Overview

The project follows the Clean Architecture principles, dividing the codebase into:

- `data/`: Models and data sources Socket or local-based CRUD implementations
- `domain/`: Entities and use cases (if added later)
- `presentation/`: UI widgets, pages, and Bloc


---

## 🔌 Socket.IO Integration

- When the backend (Socket.IO server) is running, the app connects to it.
- All create, update, and delete operations are broadcast to all connected clients.
- Notifications are shown via SnackBars to confirm real-time changes.

### Fallback Mode (Local State)

- If the backend is not running or disconnected, the app automatically uses local Bloc state for CRUD operations.
- This ensures a smooth and functional offline experience.

---

## 🚀 Getting Started

### Prerequisites

- Flutter 3.x installed
- Node.js and Socket.IO for the backend (optional)

### 1. Clone the Repository

```bash

git clone https://github.com/yared098/flutter-socketio-todo-app-.git
cd cd frontend 


