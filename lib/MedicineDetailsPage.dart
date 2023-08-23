import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicineDetailsPage extends StatelessWidget {
  final String medicineReference;

  MedicineDetailsPage({required this.medicineReference});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(medicineReference),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        // Fetch medicine details based on the reference
        future: FirebaseFirestore.instance
            .collection('Medicine')
            .where('name', isEqualTo: medicineReference)
            .get()
            .then((querySnapshot) => querySnapshot.docs.first),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading medicine details.'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No medicine details found.'));
          } else {
            var medicineData = snapshot.data!.data() as Map<String, dynamic>;
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    medicineData['image'],
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 16),
                  RichText(
                    text: TextSpan(
                      style: DefaultTextStyle.of(context).style.copyWith(
                            fontSize: 18, // Adjust the font size as desired
                          ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Name: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue, // Change color as desired
                          ),
                        ),
                        TextSpan(text: '${medicineData['name']}\n'),
                        TextSpan(
                          text: '\n', // Add space between spans
                        ),
                        TextSpan(
                          text: 'Property: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green, // Change color as desired
                          ),
                        ),
                        TextSpan(text: '${medicineData['property']}\n'),
                        TextSpan(
                          text: '\n', // Add space between spans
                        ),
                        TextSpan(
                          text: 'Usage: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange, // Change color as desired
                          ),
                        ),
                        TextSpan(text: '${medicineData['usage']}\n'),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
