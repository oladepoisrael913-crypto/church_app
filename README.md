# Gatherly
### Church Member Management App

> Flutter • Firebase • Riverpod • Dart
> 
 Project Overview

Gatherly is a cross-platform mobile application built with Flutter and Firebase that helps churches manage their members efficiently. It provides a clean, intuitive interface for viewing, adding, editing, and deleting church members, along with announcements and events management.

The app is designed to be simple and accessible — no login required for regular church members. Anyone can open the app and browse content. The admin has a separate hidden login for full management access.

 Features

 Member Management
- View all church members in a searchable list
- Add new members with name, phone, department and role
- Edit existing member information
- Delete members from the database
- Real-time updates powered by Firestore streams
- Search members by name instantly



 Tech Stack

| Technology | Version | Purpose |
|---|---|---|
| Flutter | 3.x | UI Framework |
| Dart | 3.x | Programming Language |
| Firebase Auth | Latest | 
| Cloud Firestore | Latest | Database |
| Riverpod | 2.x | State Management |

 Project Structure


lib/
├── main.dart                  App entry point           
├── MemberScreen.dart           Public member list screen
├── AddMembers.dart             Add / Edit member form
├── member_tile.dart            Member list item widget
├── member_provider.dart        Riverpod providers
├── members.dart                Member data model                
└        





Prerequisites
- Flutter SDK installed (3.x or above)
- Dart SDK installed
- A Firebase project created
- Android Studio or VS Code
- A physical device or emulator
 Installation

1. Clone the repository:
bash
git clone https://github.com/yourusername/gatherly.git
cd gatherly


2. Install dependencies:
```bash
flutter pub get


3. Connect Firebase:
   - Go to console.firebase.google.com
   - Create a new project named Gatherly
   - Add an Android app with your package name
   - Download `google-services.json` and place it in `android/app/`
   - Enable Firestore Database and Firebase Auth

4. Run the app:
```bash
flutter run
```

---

 Firestore Database Structure

 members collection

members/
  {docId}/
    name:        String
    phone:       String
    department:  String
    role:        String
    createdAt:   Timestamp
    updatedAt:   Timestamp




Users collection`
users/
  {uid}/
    firstname:   String
    lastname:    String
    email:       String
    role:        String   // 'admin' or 'member'
    createdAt:   Timestamp


Firestore Security Rules

```js
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /members/{memberId} {
      allow read, write: if true;
    }
   
    match /users/{userId} {
      allow read, write: if false;
    }
  
}






| Package | Usage |
|---|---|
| flutter_riverpod | State management |
| cloud_firestore | Firestore database |
| firebase_auth | Admin authentication |
| firebase_core | Firebase initialization |



 App Flow

Public User:

App opens → MemberScreen (no login needed)
         → Can view members, contacts, and other details
         → Cannot add, edit or delete




 Author

Built by Me FOLAWIYO —  Flutter Developer

Stack: Flutter • Firebase • Riverpod • Python

Gatherly is a portfolio project targeting the church app niche, built in 7 months of learning.


## License

This project is open source and available under the [MIT License](LICENSE).
