import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadsListScreen extends StatelessWidget {
  const UploadsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        centerTitle: true,
        title: Text(
          "Servers",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 125, 177, 127),
      ),
      body: Container(
        color: Colors.white, // Scaffold background color
        padding: const EdgeInsets.all(16.0), // Padding around the container
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Uploads').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // If there's no data, show a message
            if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No Uploads found.'));
            }

            // Build the list of uploads
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0), // Padding between list items
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.lightGreen[100], // Light green background color for ListTile
                      borderRadius: BorderRadius.circular(8.0), // Optional: Rounded corners
                    ),
                    child: ListTile(
                      title: Center(child: Text(data['fileName'])),
                      subtitle: Column(
                        children: [
                          Text('Server: ${data['Server']}'),
                          Text('Start Date: ${data['startDate']}'),
                          Text('End Date: ${data['endDate']}'),
                          Text('Cost: ₹ ${data['uploadCost']}'),
                        ],
                      ),
                       
                      // trailing: Text('Cost: \$${data['uploadCost']}'),
                      // You can add more fields here as needed
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
