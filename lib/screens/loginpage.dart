import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uberdummy/screens/mainpage.dart';
import 'package:uberdummy/screens/registrationpage.dart';
import 'package:uberdummy/widgets/button.dart';
import 'package:uberdummy/widgets/progressdialog.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  static const id = 'login';
  final FirebaseAuth auth = FirebaseAuth.instance;

  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void showSnackBar(String title, context) {
      final snackbar = SnackBar(
          content: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15.0),
      ));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }

    Future<void> signIn() async {
      showDialog(
        context: context,
        builder: (BuildContext context) => const ProgressDialog(
          status: 'Logging you In',
        ),
      );

      try {
        final user = await auth.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        Navigator.pop(context);
        if (user != null) {
          DatabaseReference userRef = FirebaseDatabase()
              .reference()
              .child('users/${auth.currentUser!.uid}');

          Navigator.pushNamedAndRemoveUntil(
              context, HomePage.id, (route) => false);
        }
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context);
        showSnackBar(e.code, context);
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "images/logo.png",
                height: 150,
                width: 150,
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                    labelText: "Email", enabledBorder: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                    labelText: 'Password', enabledBorder: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 20.0,
              ),
              defaultButton(
                title: 'Login',
                onpressed: () {
                  if (!emailController.text.contains('@')) {
                    showSnackBar('Please enter a valid email', context);
                  }
                  signIn();
                },
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, RegistrationPage.id, (route) => false);
                  },
                  child: const Text("Don't have Account. Register here."))
            ],
          ),
        ),
      )),
    );
  }
}
