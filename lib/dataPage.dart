import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'ListViewBox.dart';
import 'SearchSection.dart';

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
      body: Column(
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
                      DocumentSnapshot sliderImage = snapshot.data!.docs[index];
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
        ],
      ),
    );
  }
}
