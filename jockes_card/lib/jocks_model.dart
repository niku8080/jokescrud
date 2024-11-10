import 'package:cloud_firestore/cloud_firestore.dart';

class JocksModel {
  String title;
  String jokes;
  String emojes;

  JocksModel( {
    required this.title,
    required this.jokes,
    required this.emojes,

  });
  // Method to create a JocksModel from DocumentSnapshot
  static JocksModel fromDocumentSnapshot(DocumentSnapshot ds) {
    return JocksModel(
      title: ds['title'],
      jokes: ds['jokes'],
      emojes: ds['emoje'],
    );
  }
}