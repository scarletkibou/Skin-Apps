import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ImageDialog extends StatelessWidget {
  ImageDialog({Key? key}) : super(key: key);

  // Replace the asset image paths with your own images
  final List<String> imagePaths = [
    'assets/case1.jpg',
    'assets/case2.jpg',
    'assets/case3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 400,
        height: 450,
        child: Column(
          children: [
            Expanded(
              child: CarouselSlider.builder(
                itemCount: imagePaths.length,
                itemBuilder: (context, index, _) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: ExactAssetImage(imagePaths[index]),
                        fit: BoxFit.fill,
                      ),
                    ),
                  );
                },
                options: CarouselOptions(
                  height: 400,
                  enableInfiniteScroll: false,
                  autoPlay: false,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
