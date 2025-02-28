import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:test/cloud.dart';
import 'package:test/help.dart';
import 'package:test/uploadlist.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});
  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Center(
              child: Text(
            "Cloudzy",
            style: GoogleFonts.poppins(
                color: Colors.black, fontWeight: FontWeight.bold),
          )),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const Icon(
              Icons.person,
              size: 100,
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text(
                "Home",
                style: GoogleFonts.poppins(color: Colors.black),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Homepage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.upload),
              title: const Text("Upload"),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const FileUploadScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.cloud),
              title: Text(
                "Servers",
                style: GoogleFonts.poppins(color: Colors.black),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const UploadsListScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: Text(
                "Help",
                style: GoogleFonts.poppins(color: Colors.black),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HelpPage()));
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                leading: const Icon(Icons.logout),
                title: Text(
                  "Sign Out",
                  style: GoogleFonts.poppins(color: Colors.black),
                ),
                onTap: signUserOut,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.all(2),
                child: SizedBox(
                  height: 220,
                  width: double.infinity,
                  child: AnotherCarousel(
                      indicatorBgPadding: 2,
                      dotSize: 2,
                      dotSpacing: 20,
                      showIndicator: true,
                      autoplay: true,
                      autoplayDuration: const Duration(seconds: 5),
                      images: const [
                        NetworkImage('https://static.vecteezy.com/system/resources/previews/001/871/070/original/illustration-of-landing-page-of-cloud-server-system-and-hosting-to-organize-simplify-and-store-work-online-design-for-website-web-banner-mobile-apps-poster-brochure-template-ads-free-vector.jpg'),
                        NetworkImage("https://img.freepik.com/free-vector/cloud-computing-banner-design-concept_1017-15147.jpg?size=338&ext=jpg&ga=GA1.1.44546679.1716854400&semt=ais_user"),
                        NetworkImage("https://5.imimg.com/data5/SELLER/Default/2022/5/LY/VA/YF/1821987/cloud-hosting-services-500x500.png")
                      ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Features",
                  style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      FeatureCard(
                        icon: Icons.upload,
                        label: "Upload",
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const FileUploadScreen())));
                        },
                      ),
                      FeatureCard(
                        icon: Icons.cloud,
                        label: "Servers",
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const UploadsListScreen())));
                        },
                      ),
                      FeatureCard(
                        icon: Icons.help,
                        label: "Help",
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const HelpPage())));
                        },
                      ),
                    ],
                  ),
                ),
              ),
              
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Text(
                    "'Get Your Cloud Server at affordable Prices'",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const FeatureCard({super.key, required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 125, 177, 127)),
              child: Icon(
                icon,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              label,
              style: GoogleFonts.poppins(
                  color: Colors.black, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}




