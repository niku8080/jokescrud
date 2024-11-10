import 'package:cloud_firestore/cloud_firestore.dart';
class DataBaseMethods{
  Future addJokeDetails(Map<String,dynamic> jokeInfoMAp,String id)async{
    return await FirebaseFirestore.instance.collection("Joke").doc(id).set(jokeInfoMAp);
  }

  Future<Stream<QuerySnapshot>>getDataTOFirebase()async{
    return FirebaseFirestore.instance.collection("Joke").snapshots();
  }
   // Update joke details in Firebase
  Future updateJokeDetails(String id, Map<String, dynamic> updatedInfoMap) async {
    return await FirebaseFirestore.instance.collection("Joke").doc(id).update(updatedInfoMap);
  }

  // Delete joke details from Firebase
  Future deleteJokeDetails(String id) async {
    return await FirebaseFirestore.instance.collection("Joke").doc(id).delete();
  }
}