import 'package:assignment1/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:assignment1/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  await Firebase.initializeApp();
  runApp(MaterialApp(home: Messages()));
}

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var userRole;
  var messages;

  @override
  void initState() {
    super.initState();
  }

  void getMessages() {
    firestore
        .collection("messages")
        .orderBy('postTime', descending: true)
        .get()
        .then((querySnapshot) {
      setState(() => messages = querySnapshot.docs);
    });
  }

  void _postMessage(BuildContext context) {
    CollectionReference messages = firestore.collection('messages');
    final messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text('Enter a message for your fans!'),
            content: TextField(
              controller: messageController,
              decoration: const InputDecoration(hintText: "I love my fans!"),
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
            actions: <Widget>[
              ElevatedButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Colors.blueGrey,
                ),
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              ElevatedButton(
                style: TextButton.styleFrom(
                  primary: Colors.white,
                ),
                child: Text('POST MESSAGE'),
                onPressed: () {
                  messages.add({
                    'message': messageController.text,
                    'postTime': DateTime.now().microsecondsSinceEpoch,
                    'messageId': "#KS" +
                        DateTime.now().microsecondsSinceEpoch.toString(),
                  });
                  getMessages();
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
            ]);
      },
    );
  }

  Widget _adminMessages() {
    // final items = List<String>.generate(1, (i) => "Item $i");
    return ListView.builder(
      itemCount: messages != null ? messages.length : 0,
      // itemBuilder: (context, index) {
      //   return ListTile(title: Text(items[index]));
      // },
      itemBuilder: (context, index) {
        return Card(
            child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: ListTile(
                  title: Text(messages[index]['message'],
                      style: const TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.bold)),
                  subtitle: Text(messages[index]['messageId']),
                  trailing: Icon(Icons.announcement_outlined),
                )));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var currentUser = auth.currentUser;

    if (userRole == null) {
      firestore
          .collection("users")
          .where('email', isEqualTo: currentUser!.email.toString())
          .get()
          .then((querySnapshot) {
        setState(() => userRole = querySnapshot.docs[0].data()['userRole']);
      });
    }

    if (messages == null && userRole != null) {
      getMessages();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Here\'s what Karan is saying'),
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                        title: const Text('Are you sure you want to logout?'),
                        // content: TextField(
                        //   controller: messageController,
                        //   decoration: const InputDecoration(hintText: "I love my fans!"),
                        //   keyboardType: TextInputType.multiline,
                        //   maxLines: null,
                        // ),
                        actions: <Widget>[
                          ElevatedButton(
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Colors.blueGrey,
                            ),
                            child: Text('CANCEL'),
                            onPressed: () {
                              setState(() {
                                Navigator.pop(context);
                              });
                            },
                          ),
                          ElevatedButton(
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                            ),
                            child: Text('LOGOUT'),
                            onPressed: () {
                              getMessages();
                              setState(() {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Login()));
                              });
                            },
                          ),
                        ]);
                  },
                );
              })
        ],
      ),
      body: _adminMessages(),
      floatingActionButton: Visibility(
        child: FloatingActionButton.extended(
            onPressed: () {
              _postMessage(context);
            },
            label: Text('New'),
            icon: Icon(Icons.messenger)),
        visible: userRole == 'admin' ? true : false,
      ),
    );
  }
}
