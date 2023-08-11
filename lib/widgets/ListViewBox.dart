import 'package:flutter/material.dart';

class ListViewBox extends StatelessWidget {
  ListViewBox({
    Key? key,
  }) : super(key: key);

  final List<String> imageUrls = [
    'https://firebasestorage.googleapis.com/v0/b/skin-apps.appspot.com/o/Searchbox_picture%2FWartsMolluscum.jpg?alt=media&token=5db97f27-60c4-4dc1-a52a-e7f94a0a661b',
    'https://firebasestorage.googleapis.com/v0/b/skin-apps.appspot.com/o/Searchbox_picture%2FEczema.jpg?alt=media&token=fdbbbb51-0b4e-4341-afbb-902fbb06fd1f',
    'https://firebasestorage.googleapis.com/v0/b/skin-apps.appspot.com/o/Searchbox_picture%2Fchickenpox.jpg?alt=media&token=e19f98bc-fe72-433e-81c2-9c91c4820198',
    'https://firebasestorage.googleapis.com/v0/b/skin-apps.appspot.com/o/Searchbox_picture%2FTinea_Ringworm.jpg?alt=media&token=ab505d98-94d1-4f39-91d5-dff78bf11014',
    'https://firebasestorage.googleapis.com/v0/b/skin-apps.appspot.com/o/Searchbox_picture%2FSeborrheic_Keratoses.jpg?alt=media&token=4789866c-f0e1-4663-aaa4-06503991af22',
    'https://firebasestorage.googleapis.com/v0/b/skin-apps.appspot.com/o/Searchbox_picture%2FEczema.jpg?alt=media&token=fdbbbb51-0b4e-4341-afbb-902fbb06fd1f',
    'https://firebasestorage.googleapis.com/v0/b/skin-apps.appspot.com/o/Searchbox_picture%2FEczema.jpg?alt=media&token=fdbbbb51-0b4e-4341-afbb-902fbb06fd1f',
    'https://firebasestorage.googleapis.com/v0/b/skin-apps.appspot.com/o/Searchbox_picture%2FEczema.jpg?alt=media&token=fdbbbb51-0b4e-4341-afbb-902fbb06fd1f',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(6.0),
                child: Container(
                  width: 224,
                  height: 224,
                  child: Image.network(
                    imageUrls[index],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                width: 60,
                height: 60,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(),
                  color: Colors.transparent,
                ),
                child: Padding(
                  padding: EdgeInsets.all(6.0),
                  child: DecoratedBox(
                    child: Center(
                      child: Icon(Icons.east_rounded, color: Colors.white),
                    ),
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Color(0xFF398378),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
