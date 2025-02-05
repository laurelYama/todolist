import 'package:flutter/material.dart';
import 'package:todolist/pages/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyD66rIcusjQ0wqGmoZZ6J274YElqDQSxow",
        authDomain: "todolist-d675a.firebaseapp.com",
        projectId: "todolist-d675a",
        storageBucket: "todolist-d675a.firebasestorage.app",
        messagingSenderId: "332568406963",
        appId: "1:332568406963:web:59cb9899fda190d6c2b9c6"
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
