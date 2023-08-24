import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'widgets/ListViewBox.dart';
import 'widgets/SearchSection.dart';

class dataPage extends StatefulWidget {
  const dataPage({super.key});

  @override
  State<dataPage> createState() => _dataPageState();
}

class _dataPageState extends State<dataPage> {
  late Stream<QuerySnapshot> imageStream;
  int currentSlideIndex = 0;
  CarouselController carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    var firebase = FirebaseFirestore.instance;
    imageStream = firebase.collection("Carousel").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF398378),
        title: Text('HomePage'),
      ),
      body: SingleChildScrollView(
        // Wrap the entire content with SingleChildScrollView
        child: Column(
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: StreamBuilder<QuerySnapshot>(
                stream: imageStream,
                builder: (_, snapshot) {
                  if (snapshot.hasData && snapshot.data!.docs.length > 1) {
                    return CarouselSlider.builder(
                      carouselController: carouselController,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (_, index, ___) {
                        DocumentSnapshot sliderImage =
                            snapshot.data!.docs[index];
                        return Image.network(
                          sliderImage['img'],
                          fit: BoxFit.contain,
                        );
                      },
                      options: CarouselOptions(
                        autoPlay: true,
                        enlargeCenterPage: true,
                        onPageChanged: (index, _) {
                          setState(() {
                            currentSlideIndex = index;
                          });
                        },
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            const SearchSection(),
            SizedBox(
              height: 20,
            ),
            ListViewBox(),
            // Team Introduction Section
            Container(
              padding: EdgeInsets.all(20),
              color: Colors.grey[200],
              child: Column(
                children: [
                  Text(
                    'Modeling',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Team image and description
                  Image.network(
                    'https://firebasestorage.googleapis.com/v0/b/skin-apps.appspot.com/o/gundam%20calibarn.jpg?alt=media&token=5995079f-6920-4794-a696-bb4a3fab99c7',
                    height: 200, // Adjust the height as needed
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'EfficientNetV2B3asdsadasdadasdadasdasdasdasdasdasdadasd',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
