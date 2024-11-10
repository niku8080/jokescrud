import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:random_string/random_string.dart';
import 'package:flutter/material.dart';
import 'package:jockes_card/jocks_model.dart';
import 'package:jockes_card/joke.dart';
class JockesappUi extends StatefulWidget {
  const JockesappUi({super.key});
  @override
  State<JockesappUi> createState() => _TodoState();
}

class _TodoState extends State<JockesappUi> {
  TextEditingController titleController = TextEditingController();
  TextEditingController jokesController = TextEditingController();
  TextEditingController emojesController = TextEditingController();
  Stream ? jokeStream;

  getOnTheLoad()async{
    jokeStream=await DataBaseMethods().getDataTOFirebase();
    setState(() {
      
    });
  }
  Widget alljokeDetail(){
    return StreamBuilder(stream: jokeStream, builder: (context,AsyncSnapshot snapshot){
      return snapshot.hasData? ListView.builder(
        itemCount: snapshot.data.docs.length,
        itemBuilder: (context,index){
          DocumentSnapshot ds=snapshot.data.docs[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
              
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue,width: 2)
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 100,
                        clipBehavior: Clip.antiAlias,
                        height: 100,
                        padding: const EdgeInsets.all(8.0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                       child: Image.asset("assets/j1.jpeg",
                       fit: BoxFit.cover,),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              // todoCards[index].title,
                              ""+ds["title"],
                              //titleController.text,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                color: Color.fromRGBO(2, 167, 177, 1),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 243,
                            //height: 80,
                            child: Text(
                              ""+ds["jokes"],
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Row(
                        children: [
                          Text(
                            ""+ds["emoje"],
                            style: const TextStyle(
                              fontSize: 25,
                            ),
                          ),
                          const Spacer(),
                         
                         GestureDetector(
                       onTap: () {
                         String id = ds.id; // Get the document ID of the joke
                         JocksModel jokeModel = JocksModel.fromDocumentSnapshot(ds); // Convert to JocksModel
                         titleController.text = jokeModel.title;
                         jokesController.text = jokeModel.jokes;
                         emojesController.text = jokeModel.emojes;
                     
                         openAddnote(true, jokeModel, id); // Pass JocksModel and ID for editing
                         setState(() {});
                       },
                       child: const Icon(
                         Icons.edit_outlined,
                         color: Color.fromRGBO(2, 167, 177, 1),
                       ),
                     ),
                     
                     
                     
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                       onTap: () async {
                         String id = ds.id; // Get the document ID of the joke
                         await DataBaseMethods().deleteJokeDetails(id);
                         setState(() {}); // Update the UI
                       },
                       child: const Icon(
                         Icons.delete_outline,
                         color: Color.fromRGBO(2, 167, 177, 1),
                       ),
                     ),
                        ],
                      ),
                   ),
                ],
              ),
            ),
          );
        }):Container();
    });
  }

  Color? boxColor(int i) {
    i = (i % 4);
    switch (i) {
      case 0:
        return const Color.fromRGBO(250, 232, 232, 1);
        
      case 1:
        return const Color.fromRGBO(232, 237, 250, 1);

      case 2:
        return const Color.fromRGBO(250, 249, 232, 1);

      case 3:
        return const Color.fromRGBO(250, 232, 250, 1);
    }
    return null;
  }

  List<JocksModel> todoCards = [
   
  ];

 
void submit(bool doEdit, [JocksModel? obj, String? id]) async {
  if (titleController.text.trim().isNotEmpty &&
      jokesController.text.trim().isNotEmpty &&
      emojesController.text.trim().isNotEmpty) {
    if (doEdit && id != null) {
      // Update Firestore directly for existing joke
      Map<String, dynamic> updatedJokeMap = {
        "title": titleController.text,
        "jokes": jokesController.text,
        "emoje": emojesController.text,
      };
      await DataBaseMethods().updateJokeDetails(id, updatedJokeMap);
    } else {
      // Add a new joke
      String newId = randomAlphaNumeric(10);
      Map<String, dynamic> jokeInfoMap = {
        "title": titleController.text,
        "jokes": jokesController.text,
        "emoje": emojesController.text,
        "ID": newId,
      };
      await DataBaseMethods().addJokeDetails(jokeInfoMap, newId);
    }
    Navigator.of(context).pop(); // Close the modal bottom sheet
    clearField(); // Clear the text fields
    setState(() {}); // Refresh the UI to show updated list
  }
}
 

  void clearField() {
    titleController.clear();
    jokesController.clear();
    emojesController.clear();
  }

  void openAddnote(bool doEdit, [JocksModel? obj, String? id]) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          top: 8.0,
          left: 8,
          right: 8,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Create Jokes",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            // Title Input
            const Text("Title of Joke", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
            TextField(controller: titleController, decoration: const InputDecoration(border: OutlineInputBorder())),

            // Joke Input
            const Text("Joke", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            TextField(controller: jokesController, decoration: const InputDecoration(border: OutlineInputBorder())),

            // Emoje Input
            const Text("Emoje", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            TextField(controller: emojesController, decoration: const InputDecoration(border: OutlineInputBorder())),

            const SizedBox(height: 20),

            // Submit Button
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  submit(doEdit, obj, id); // Only calls submit to handle add/edit
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color.fromRGBO(7, 7, 7, 1)),
                child: const Text(
                  "Add",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}


  @override
  void initState(){
    getOnTheLoad();
    super.initState();
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Jokes App",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          toolbarHeight: 70,
          backgroundColor:  Colors.blue,
        ),
        body: Container(
          child: Column(children: [
              Expanded(child: alljokeDetail())
          ],),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            clearField();
            openAddnote(false);
          },
          backgroundColor: Colors.blue,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size:40,
          ),
        ),
      ),
    );
  }
}