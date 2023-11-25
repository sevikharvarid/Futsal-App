import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../component/input_text_field.dart';
import '../home/home_page_admin.dart';
import '../home/home_page_user.dart';
import '../register/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailInput = TextEditingController();
  TextEditingController passwordInput = TextEditingController();
  bool isNotShow = true;
  bool isRemember = false;

  // Future<void> signInUser(
  signInUser(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;

        // Check if UID exists in admin collection
        DatabaseReference adminRef = FirebaseDatabase.instance.ref('admin');
        DatabaseReference usersRef = FirebaseDatabase.instance.ref('users');
        DataSnapshot snapshot = await adminRef.child(uid).get();
        DataSnapshot snapshotUser = await usersRef.child(uid).get();
        Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;
        Map<dynamic, dynamic>? dataUser =
            snapshotUser.value as Map<dynamic, dynamic>?;
        if (data != null) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePageAdmin(
                        userName: data["username"],
                        email: data["email"],
                      )));
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePageUser(
                userName: dataUser!["username"],
                email: dataUser["email"],
              ),
            ),
          );
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign In Success!'),
          duration: Duration(seconds: 2),
        ),
      );
      emailInput.clear();
      passwordInput.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sign in failed!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            color: Colors.white,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.only(
              top: 64,
              bottom: 24,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    "assets/images/logo_app.png",
                    width: 300,
                    height: 300,
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 24,
                    ),
                    padding: const EdgeInsets.all(15),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0, 2),
                            spreadRadius: 1,
                            blurRadius: 2,
                          ),
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InputTextField(
                          labelTitle: "",
                          controller: emailInput,
                          hint: "Masukkan email",
                        ),
                        const SizedBox(height: 8),
                        InputTextField(
                          labelTitle: "",
                          controller: passwordInput,
                          hint: "Masukkan Password",
                          isVisible: isNotShow,
                          isPassword: true,
                          onPressedSuffixIcon: () {
                            setState(() {
                              isNotShow = !isNotShow;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await signInUser(
                          emailInput.text, passwordInput.text, context);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 24,
                      ),
                      padding: const EdgeInsets.all(15),
                      decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0, 2),
                              spreadRadius: 1,
                              blurRadius: 3,
                            ),
                          ]),
                      child: const Center(
                        child: Text(
                          "Sign In",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  // Container(
                  //     width: MediaQuery.of(context).size.width,
                  //     margin: const EdgeInsets.all(16),
                  //     child: Row(
                  //       children: [
                  //         Row(
                  //           children: [
                  //             Checkbox(
                  //                 value: isRemember,
                  //                 onChanged: (v) {
                  //                   setState(() {
                  //                     isRemember = v!;
                  //                   });
                  //                 }),
                  //             const Text("Remember password")
                  //           ],
                  //         )
                  //       ],
                  //     )),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.all(16),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) =>
                                      const RegisterPage())));
                        },
                        child: const Text(
                          "Belum punya akun, Sign Up",
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
