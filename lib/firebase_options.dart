import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => web;

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyD5pvw-zT_uhY5LR_3Uq5eUkFvgT4EscGo",
    authDomain: "foodapp-66eda.firebaseapp.com",
    projectId: "foodapp-66eda",
    storageBucket: "foodapp-66eda.appspot.com",
    messagingSenderId: "170876312897",
    appId: "1:170876312897:web:94748319fc3daf6a2c55c0",
    measurementId: "G-G4JKLERNET",
  );
}
