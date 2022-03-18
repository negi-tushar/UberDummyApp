import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uberdummy/screens/loginpage.dart';
import 'package:uberdummy/screens/mainpage.dart';
import 'package:uberdummy/widgets/button.dart';
import 'package:uberdummy/widgets/progressdialog.dart';

class RegistrationPage extends StatelessWidget {
  static const id = 'register';
  // late BuildContext context;
  //final GlobalKey<ScaffoldState> scaffoldkey = GlobalKey();
  void showSnackBar(String title, context) {
    final snackbar = SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  var emailController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void showSnackBar(String title, context) {
      final snackbar = SnackBar(
        content: Text(
          title,
          textAlign: TextAlign.center,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }

    void registeruser() async {
      showDialog(
        context: context,
        builder: (BuildContext context) => const ProgressDialog(
          status: 'Creating Account',
        ),
      );
      try {
        final user = await auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        Navigator.pop(context);
        if (user.user != null) {
          DatabaseReference newUserRef = FirebaseDatabase.instance
              .reference()
              .child('users/${auth.currentUser!.uid}');
          print('helloooooooooooooo');
          //Map data to database
          Map userMap = {
            'fullName': nameController.text,
            'email': emailController.text,
            'phone': phoneController.text,
          };
          newUserRef.set(userMap);
          Navigator.pop(context);
          Navigator.pushNamedAndRemoveUntil(
              context, HomePage.id, (route) => false);
        }
      } on FirebaseAuthException catch (e) {
        showSnackBar(e.code, context);
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20.0),
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
                  controller: nameController,
                  decoration: const InputDecoration(
                      labelText: "Name", enabledBorder: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      labelText: "Phone No",
                      enabledBorder: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      labelText: "Email", enabledBorder: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: const InputDecoration(
                      labelText: 'Password',
                      enabledBorder: OutlineInputBorder()),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                defaultButton(
                    title: 'Register',
                    onpressed: () async {
//checking connectivity issue
                      var connectivityresult =
                          await (Connectivity().checkConnectivity());
                      if (connectivityresult != ConnectivityResult.mobile &&
                          connectivityresult != ConnectivityResult.wifi) {
                        showSnackBar('Please connect to Internet', context);
                      }

                      if (nameController.text.length < 3) {
                        showSnackBar('Please enter Full Name', context);
                      }
                      if (phoneController.text.length < 10) {
                        showSnackBar(
                            'Please enter valid Phone number', context);
                      }
                      if (!emailController.text.contains('@')) {
                        showSnackBar(
                            'Please enter valid Email-address', context);
                      }
                      if (passwordController.text.length < 3) {
                        showSnackBar(
                            'Password length should be greater then 3 characters',
                            context);
                      }
                      registeruser();
                    }),
                const SizedBox(
                  height: 10.0,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginPage.id, (route) => false);
                    },
                    child: const Text("Already have Account. Login."))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
