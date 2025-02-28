import 'package:test/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test/Authentication/login_or_register_page.dart';


class AuthPage extends StatelessWidget {
  const AuthPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // if (snapshot.data?.email == "admin@gmail.com")
              //   return Homepage1();
              return Homepage();
            } else {
              return const LoginOrRegisterPage();
            }
          }),
    );
  }
}