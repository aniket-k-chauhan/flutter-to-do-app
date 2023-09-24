import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";

import "package:flutter_to_do_app/Custom/TodoCard.dart";
import "package:flutter_to_do_app/pages/AddTodoPage.dart";
import "package:flutter_to_do_app/pages/SignUpPage.dart";
import "package:flutter_to_do_app/pages/ViewTodoPage.dart";
import "package:flutter_to_do_app/services/Auth_Service.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthClass authCLass = AuthClass();
  final Stream<QuerySnapshot<Map<String, dynamic>>> _stream =
      FirebaseFirestore.instance.collection("Todo").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Text(
          "Today's Schedule",
          style: TextStyle(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Tooltip(
            message: "Logout",
            child: IconButton(
              onPressed: () async {
                await authCLass.logout();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (builder) => SignUpPage()),
                    (route) => false);
              },
              icon: Icon(Icons.logout),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        backgroundColor: Colors.black87,
        items: [
          BottomNavigationBarItem(
            label: "Home",
            icon: Icon(
              Icons.home,
              size: 32,
              color: Colors.white,
            ),
          ),
          BottomNavigationBarItem(
            label: "Add Todo",
            icon: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => AddTodoPage()));
              },
              child: Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [
                      Colors.indigoAccent,
                      Colors.purple,
                    ])),
                child: Icon(
                  Icons.add,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _stream,
        builder: ((context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> document =
                    snapshot.data!.docs[index].data();
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (builder) => ViewTodoPage(
                          document: document,
                          id: snapshot.data!.docs[index].id,
                        ),
                      ),
                    );
                  },
                  child: TodoCard(
                    title: document["title"],
                    time: "10 AM",
                    check: document["completed"],
                    id: snapshot.data!.docs[index].id,
                    onTaskCompleteToggle: onTaskCompleteToggle,
                  ),
                );
              });
        }),
      ),
    );
  }

  void onTaskCompleteToggle(String id, bool check) {
    FirebaseFirestore.instance
        .collection("Todo")
        .doc(id)
        .update({"completed": !check});
  }
}
