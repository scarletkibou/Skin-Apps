import 'package:flutter/material.dart';

class SearchSection extends StatelessWidget {
  const SearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              cursorColor: Colors.blueAccent,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                prefixIcon:
                    Icon(Icons.search, size: 24, color: Color(0xFF398378)),
                hintText: 'Search Skin disease',
                hintStyle:
                    TextStyle(color: const Color.fromARGB(255, 104, 103, 103)),
                fillColor: Colors.white,
                filled: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Color(0xFF398378),
              borderRadius: BorderRadius.circular(12),
            ),
            height: 50,
            width: 50,
            child: Icon(Icons.east_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
