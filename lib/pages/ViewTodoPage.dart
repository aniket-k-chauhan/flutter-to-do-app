import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewTodoPage extends StatefulWidget {
  const ViewTodoPage({super.key, required this.document, required this.id});

  final Map<String, dynamic> document;
  final String id;

  @override
  State<ViewTodoPage> createState() => _ViewTodoPageState();
}

class _ViewTodoPageState extends State<ViewTodoPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String type;
  bool edit = false;

  @override
  void initState() {
    super.initState();
    String description = widget.document["description"];
    _titleController = TextEditingController(text: widget.document["title"]);
    _descriptionController = TextEditingController(text: description);
    type = widget.document["type"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff1d1e26),
              Color(0xff252041),
            ],
          ),
        ),
        child: ListView(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    alignment: Alignment.topLeft,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      CupertinoIcons.arrow_left,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        alignment: Alignment.topRight,
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection("Todo")
                              .doc(widget.id)
                              .delete()
                              .then((value) => Navigator.pop(context));
                        },
                        icon: Icon(
                          Icons.delete_rounded,
                          color: Colors.red[400],
                          size: 28,
                        ),
                      ),
                      IconButton(
                        alignment: Alignment.topRight,
                        onPressed: () {
                          setState(() {
                            edit = !edit;
                          });
                        },
                        icon: Icon(
                          Icons.edit,
                          color: edit ? Colors.green[400] : Colors.white,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    edit ? "Edit" : "View",
                    style: TextStyle(
                      fontSize: 33,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Your Todo",
                    style: TextStyle(
                      fontSize: 33,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  labelText("Title"),
                  SizedBox(
                    height: 12,
                  ),
                  title(context),
                  SizedBox(
                    height: 30,
                  ),
                  labelText("Task Type"),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    children: [
                      typeSelect("Important", 0xff2664fa),
                      SizedBox(
                        width: 20,
                      ),
                      typeSelect("Planned", 0xff2bc8d9),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  labelText("Description"),
                  SizedBox(
                    height: 12,
                  ),
                  description(context),
                  SizedBox(
                    height: 50,
                  ),
                  edit ? button(context) : Container(),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  InkWell button(BuildContext context) {
    return InkWell(
      onTap: () {
        if (_titleController.text.isEmpty) {
          final snackBar = SnackBar(content: Text("Please enter todo title."));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return;
        }
        FirebaseFirestore.instance.collection("Todo").doc(widget.id).update({
          "title": _titleController.text,
          "type": type,
          "description": _descriptionController.text
        });
        Navigator.pop(context);
      },
      child: Container(
        height: 56,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xff8a32f1),
            Color(0xffad32f9),
          ]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            "Update Todo",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Container description(BuildContext context) {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _descriptionController,
        enabled: edit,
        maxLines: null,
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "No Description",
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
          contentPadding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
        ),
      ),
    );
  }

  Widget typeSelect(String labelText, int color) {
    return InkWell(
      onTap: edit
          ? () {
              setState(() {
                type = labelText;
              });
            }
          : null,
      child: Chip(
        backgroundColor: type == labelText ? Colors.white : Color(color),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        side: BorderSide(width: 2, color: Color(color)),
        label: Text(
          labelText,
          style: TextStyle(
            color: type == labelText ? Colors.black : Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        labelPadding: EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 3.8,
        ),
      ),
    );
  }

  Container title(BuildContext context) {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _titleController,
        enabled: edit,
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Task Title",
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
          contentPadding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
        ),
      ),
    );
  }

  Text labelText(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.5,
        fontWeight: FontWeight.w600,
        letterSpacing: 2,
      ),
    );
  }
}
