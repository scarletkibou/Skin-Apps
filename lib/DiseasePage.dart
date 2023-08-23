import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'MedicineDetailsPage.dart';

class DiseasePage extends StatelessWidget {
  final String diseaseName;
  DiseasePage({
    required this.diseaseName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(diseaseName),
      ),
      body: Column(
        children: [
          _buildPictureCarousel(),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('SkinDisease')
                  .where('disease_name', isEqualTo: diseaseName)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                var documents = snapshot.data!.docs;
                if (documents.isEmpty) {
                  return Center(
                    child: Text('No data found for this disease.'),
                  );
                }

                var data = documents[0].data() as Map<String, dynamic>;
                List<String> medicineReferences =
                    List<String>.from(data['medicine_references']);

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildDiseaseTopic(
                        context: context,
                        title: 'Cause',
                        content: data['cause'],
                      ),
                      _buildDiseaseTopic(
                        context: context,
                        title: 'Curement',
                        content: data['curement'],
                      ),
                      _buildDiseaseTopic(
                        context: context,
                        title: 'Symptom',
                        content: data['symptom'],
                      ),
                      FutureBuilder<List<String>>(
                        // Fetch medicine data based on references
                        future: _fetchMedicineData(medicineReferences),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error loading medicine data.');
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Text(' ');
                          } else {
                            List<String> medicineData = snapshot.data!;
                            return _buildDiseaseTopic(
                              context: context,
                              title: 'Medicine References',
                              content: medicineData.join('\n'),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPictureCarousel() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 150,
        viewportFraction: 2.0,
        autoPlay: true,
      ),
      items: [
        _buildPicture(
          'https://firebasestorage.googleapis.com/v0/b/skin-apps.appspot.com/o/Searchbox_picture%2FEczema.jpg?alt=media&token=fdbbbb51-0b4e-4341-afbb-902fbb06fd1f',
        ),
        _buildPicture(
          'https://firebasestorage.googleapis.com/v0/b/skin-apps.appspot.com/o/Searchbox_picture%2FEczema.jpg?alt=media&token=fdbbbb51-0b4e-4341-afbb-902fbb06fd1f',
        ),
      ],
    );
  }

  Widget _buildPicture(String imageUrl) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }

  Future<List<String>> _fetchMedicineData(
      List<String> medicineReferences) async {
    List<String> medicineData = [];

    for (String reference in medicineReferences) {
      DocumentSnapshot medicineSnapshot = await FirebaseFirestore.instance
          .collection('Medicine')
          .doc(reference)
          .get();

      if (medicineSnapshot.exists) {
        var medicineDataMap = medicineSnapshot.data() as Map<String, dynamic>;
        String medicineName = medicineDataMap['name'];
        medicineData.add(medicineName);
      }
    }

    return medicineData;
  }

  Widget _buildDiseaseTopic({
    required String title,
    required String content,
    required BuildContext context,
  }) {
    if (title == 'Medicine References' && content.isEmpty) {
      return Container();
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFF398378),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: title == 'Medicine References'
                ? Wrap(
                    direction: Axis.horizontal,
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: content
                        .split('\n')
                        .map(
                          (item) => ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MedicineDetailsPage(
                                    medicineReference: item,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF398378),
                            ),
                            child: Text(item),
                          ),
                        )
                        .toList(),
                  )
                : Text(content),
          ),
        ],
      ),
    );
  }
}
