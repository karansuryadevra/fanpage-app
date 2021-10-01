import 'package:assignment1/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  runApp(MaterialApp(home: SignUp()));
}

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    final firstnameController = TextEditingController();
    final lastnameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    const weakPasswordSnackBar = SnackBar(content: Text('Password too weak!'));
    const userExistsSnackBar =
        SnackBar(content: Text('An account already exists for that email'));
    const userCreatedSnackBar =
        SnackBar(content: Text('User Successfully created! Try Logging in!'));

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');

    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(
              height: 100.0,
            ),
            const Text(
              'Sign Up',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: firstnameController,
              decoration: InputDecoration(
                hintText: 'First Name',
                // suffixIcon: const Icon(Icons),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: lastnameController,
              decoration: InputDecoration(
                hintText: 'Last Name',
                // suffixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: 'Email',
                suffixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                suffixIcon: const Icon(Icons.visibility_off),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Re-Type Password',
                suffixIcon: const Icon(Icons.visibility_off),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  UserCredential userCredential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text);
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(weakPasswordSnackBar);
                  } else if (e.code == 'email-already-in-use') {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(userExistsSnackBar);
                  }
                }
                ScaffoldMessenger.of(context).showSnackBar(userCreatedSnackBar);
                users.add({
                  'firstName': firstnameController.text,
                  'lastName': lastnameController.text,
                  'email': emailController.text,
                  'userRole': 'customer',
                  'registrationTime': DateTime.now().microsecondsSinceEpoch,
                });
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Login()));
              },
              style: TextButton.styleFrom(
                textStyle: const TextStyle(color: Colors.white),
                // primary: Colors.lightBlue,
              ),
              child: const Text('Sign up!'),
            ),
            const SizedBox(
              height: 20.0,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
                child: const Text.rich(
                    TextSpan(text: 'Already have an account? ', children: [
                  TextSpan(
                      text: 'Login', style: TextStyle(color: Colors.lightBlue)),
                ]))),
          ]),
        ),
      ),
    );
  }
}
