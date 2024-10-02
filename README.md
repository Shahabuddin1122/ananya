# Ananya - Menstrual Period Tracker App

Ananya is a mobile app designed to help users track their menstrual cycles, manage their period history, and receive timely notifications. The app supports two types of users:

1. **Normal User**: Can track their own menstrual period data.
2. **Superuser**: Can track the menstrual period of multiple users and manage their data.

The project consists of two parts:

1. **Ananya (Flutter App)**: The mobile app built using Flutter.
2. **Backend (Django Server)**: The backend server built using Django to handle user data, authentication, and notifications.

## Features

- Period tracking based on user input.
- Notifications for period cycles.
- History management of menstrual cycles.
- Superuser role to track and manage multiple users' period data.

## Project Structure

- `ananya/`: Contains the Flutter mobile app.
- `backend/`: Contains the Django backend server.

## Tech Stack

### Frontend (Flutter App)
- **Flutter**: Framework for building cross-platform mobile apps.
- **Dart**: Programming language used in Flutter.

### Backend (Django Server)
- **Django**: Web framework for building the backend API.
- **Django REST Framework**: Used to build the API for managing user data and period tracking.
- **PostgreSQL**: Database for storing user and period tracking information.
- **JWT Authentication**: Used for secure user authentication.
  
## Requirements

### Frontend (Ananya Flutter App)
- Flutter SDK 3.24.0 or higher
- Dart 3.5.0 or higher

### Backend (Django Server)
- Python 3.9 or higher
- Django 5.1.0
- PostgreSQL

## Setup Instructions

### Clone the Repository

  ```bash
  git clone https://github.com/Shahabuddin1122/ananya.git
  ```
## Frontend (Ananya Flutter App)

1. Navigate to the ananya/ folder:
   
   ```bash
   cd ananya/ananya
   ```
2. Install the required Flutter dependencies:
   
   ```bash
   flutter pub get
   ```
3. Run the Flutter app:

   ```bash
   flutter run
   ```
## Backend (Django Server)

1. Navigate to the backend/ folder:
   
   ```bash
   cd ananya/backend
   ```
   
2. Set up a virtual environment:
   
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows, use venv\Scripts\activate
   ```
   
3. Install the required Python dependencies:

   ```bash
   pip install -r requirements.txt
   ```
   
4. Set up the environment variables:
   - Create a .env file based on the provided .env.example file.

5. Run database migrations:

   ```bash
   python manage.py migrate
   ```

6. Start the development server:

   ```bash
   python manage.py runserver
   ```
