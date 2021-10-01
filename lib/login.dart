import 'package:assignment1/messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:assignment1/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(Login());
  // await Firebase.initializeApp();
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  // void initializeFlutterFire() async {
  //   // Wait for Firebase to initialize and set `_initialized` state to true
  //   await Firebase.initializeApp();
  // }

  // @override
  // void initState() {
  //   initializeFlutterFire();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;

    // FirebaseAuth auth = FirebaseAuth.instance;
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    const userNotFoundSnackBar = SnackBar(content: Text('User not found!'));
    const wrongPasswordSnackBar =
        SnackBar(content: Text('Incorrect Password!'));
    const userLoggedInSnackBar =
        SnackBar(content: Text('Successfully Logged in!'));

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(
              height: 20.0,
            ),
            Container(
              width: 370 * 0.55,
              height: 370 * 0.65,
              child: Image.asset(
                'assets/Karan_photo.jpg',
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Text(
              'Login',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Email',
                suffixIcon: const Icon(Icons.email),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              controller: emailController,
            ),
            const SizedBox(
              height: 20.0,
            ),
            TextFormField(
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
              height: 30.0,
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  UserCredential userCredential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: emailController.text,
                          password: passwordController.text);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(userLoggedInSnackBar);
                  // print(
                  //     '%%%%%%%%%%%%%%%%%%%%% user.email is %%%%%%%%%%%%%%%%%%%%%%%%%');
                  // print(userCredential.user!.email);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Messages()));
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(userNotFoundSnackBar);
                  } else if (e.code == 'wrong-password') {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(wrongPasswordSnackBar);
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                }
              },
              style: TextButton.styleFrom(
                textStyle: const TextStyle(color: Colors.white),
                // primary: Colors.lightBlue,
              ),
              child: const Text('Login'),
            ),
            ElevatedButton.icon(
                onPressed: () async {
                  try {
                    final GoogleSignInAccount? googleUser =
                        await GoogleSignIn().signIn();
                    final GoogleSignInAuthentication googleAuth =
                        await googleUser!.authentication;

                    final credential = GoogleAuthProvider.credential(
                      accessToken: googleAuth.accessToken,
                      idToken: googleAuth.idToken,
                    );
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Messages()));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(e.toString()),
                    ));
                  }
                },
                icon: Icon(Icons.g_mobiledata),
                label: Text('Google Sign-in')),
            const SizedBox(
              height: 20.0,
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUp()));
                },
                child: const Text.rich(
                    TextSpan(text: 'Don\'t have an account? ', children: [
                  TextSpan(
                      text: 'Sign Up',
                      style: TextStyle(color: Colors.lightBlue)),
                ]))),
          ]),
        ),
      ),
    );

    // return Scaffold(
    //     body: Center(
    //         child: Column(
    //   children: <Widget>[
    //     TextFormField(
    //       controller: emailController,
    //       decoration: InputDecoration(
    //         hintText: 'Email',
    //         suffixIcon: const Icon(Icons.email),
    //         border: OutlineInputBorder(
    //           borderRadius: BorderRadius.circular(20.0),
    //         ),
    //       ),
    //     ),
    //     TextFormField(
    //       controller: passwordController,
    //       decoration: InputDecoration(
    //         hintText: 'Password',
    //         suffixIcon: const Icon(Icons.email),
    //         border: OutlineInputBorder(
    //           borderRadius: BorderRadius.circular(20.0),
    //         ),
    //       ),
    //     ),
    //   ],
    // )));

    // return Scaffold(
    //     appBar: AppBar(
    //       title: const Text('Sample Code'),
    //     ),
    //     body: Center(
    //         child: Column(
    //       children: <Widget>[
    //         TextFormField(
    //           controller: emailController,
    //           decoration: InputDecoration(
    //             hintText: 'Email',
    //             suffixIcon: const Icon(Icons.email),
    //             border: OutlineInputBorder(
    //               borderRadius: BorderRadius.circular(20.0),
    //             ),
    //           ),
    //         ),
    //         TextFormField(
    //           controller: passwordController,
    //           decoration: InputDecoration(
    //             hintText: 'Password',
    //             suffixIcon: const Icon(Icons.email),
    //             border: OutlineInputBorder(
    //               borderRadius: BorderRadius.circular(20.0),
    //             ),
    //           ),
    //         ),
    //       ],
    //     )));
  }
}
