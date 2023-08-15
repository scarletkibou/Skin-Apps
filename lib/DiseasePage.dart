import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';

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
      body: Stack(
        children: [
          _buildPictureCarousel(),
          Align(
            alignment: Alignment.center,
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

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildDiseaseTopic(
                        title: 'Cause',
                        content: data['cause'],
                      ),
                      _buildDiseaseTopic(
                        title: 'Curement',
                        content: data['curement'],
                      ),
                      _buildDiseaseTopic(
                        title: 'Symptom',
                        content: data['symptom'],
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
      width: double.infinity, // Take up the full width of the carousel
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildDiseaseTopic({
    required String title,
    required String content,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 150, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFF398378),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
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
            child: Text(content),
          ),
        ],
      ),
    );
  }
}
