import 'package:flutter/material.dart';
import 'package:jockes_card/jockesApp_UI.dart';
import 'package:firebase_core/firebase_core.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(apiKey: "AIzaSyCdyRuSj7ElzNTmnY6T9gLmPF1kVEcrmmc", appId: "1:810087984566:android:32d4c019c412f1dc8a6517", messagingSenderId: "810087984566", projectId: "fir-crud-e175e",),
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: JockesappUi(),
    );
  }
}
