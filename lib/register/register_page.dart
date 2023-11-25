import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../component/input_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController username = TextEditingController();
  TextEditingController emailInput = TextEditingController();
  TextEditingController passwordInput = TextEditingController();
  TextEditingController confirmPasswordInput = TextEditingController();
  TextEditingController alamat = TextEditingController();
  bool isNotShow = true;
  bool isNotShow2 = true;
  // bool isAdmin = false;

  // Future<bool> registerUser(bool role, String username, String email,
  // Future<bool> registerUser(String username, String email, String password,
  registerUser(String username, String email, String password, String alamat,
      BuildContext context) async {
    try {
      // Create a new user with email and password.
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      // Get the uid of the newly created user.
      String uid = userCredential.user!.uid;
      // Push the data to the Realtime Database.
      // String roleType = role ? "admin" : "users";
      FirebaseDatabase database = FirebaseDatabase.instance;
      DatabaseReference userRef = database.ref("users").child(uid);
      await userRef.set({
        'username': username,
        'email': email,
        'password': password,
        'createdAt': DateTime.now().toString(),
        'alamat': alamat,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final toast = ScaffoldMessenger.of(context);
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 24,
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
                          controller: username,
                          hint: "Masukkan Username",
                        ),
                        const SizedBox(height: 5),
                        InputTextField(
                          labelTitle: "",
                          controller: emailInput,
                          hint: "Masukkan email",
                        ),
                        const SizedBox(height: 5),
                        InputTextField(
                          labelTitle: "",
                          controller: alamat,
                          hint: "Masukkan alamat",
                        ),
                        const SizedBox(height: 5),
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
                        const SizedBox(height: 5),
                        InputTextField(
                          labelTitle: "",
                          controller: confirmPasswordInput,
                          hint: "Masukkan Password Ulang",
                          isVisible: isNotShow2,
                          isPassword: true,
                          onPressedSuffixIcon: () {
                            setState(() {
                              isNotShow2 = !isNotShow2;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      // bool isSuccess = await registerUser(isAdmin, username.text,
                      bool isSuccess = await registerUser(
                          username.text,
                          emailInput.text,
                          passwordInput.text,
                          alamat.text,
                          context);
                      if (isSuccess) {
                        toast.showSnackBar(
                          const SnackBar(
                            content: Text('Registrasi berhasil !'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop();
                      } else {
                        toast.showSnackBar(
                          const SnackBar(
                            content: Text('Registrasi gagal !'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
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
                          "Sign Up",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.all(16),
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Sudah punya akun, Sign In",
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
