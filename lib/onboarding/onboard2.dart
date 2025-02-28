import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class Onboard2 extends StatelessWidget {
  const Onboard2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Lottie.network(
                "https://lottie.host/bb792682-1e9c-4218-b493-2e0bd00ff05d/6NSFB4Ycq0.json"),
            const SizedBox(
              height: 20,
            ),
            Text(
              "Custom Cloud Servers",
              style: GoogleFonts.sanchez(
                  fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      )),
    );
  }
}
