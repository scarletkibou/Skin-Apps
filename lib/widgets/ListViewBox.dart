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
          return Container(
            width: 200,
            margin: EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              children: <Widget>[
                Container(
                  width: 200,
                  height: 100,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imageUrls[index]),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF398378),
                      ),
                      child: Center(
                        child: Icon(Icons.east_rounded, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Your Text Here',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
