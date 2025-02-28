import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class Onboard3 extends StatelessWidget {
  const Onboard3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 150,
            ),
            Lottie.network(
              "https://lottie.host/e2d99892-a04a-4ac5-bd1a-4719cf712c5a/9c8PLKNXi7.json",
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Pay according to ussage",
                style: GoogleFonts.sanchez(
                    fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            //   child: Text(
            //     "Every Drop of Blood Makes You A Donor",
            //     style: GoogleFonts.montserrat(
            //         fontSize: 12, fontWeight: FontWeight.w500),
            //   ),
            // ),
            const SizedBox(
              height: 150,
            ),
          ],
        ),
      )),
    );
  }
}
