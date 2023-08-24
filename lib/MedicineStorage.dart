import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'MedicineDetailsPage.dart';

class MedicineStorage extends StatefulWidget {
  @override
  _MedicineStoragePageState createState() => _MedicineStoragePageState();
}

class _MedicineStoragePageState extends State<MedicineStorage> {
  late TextEditingController _searchController;
  late Stream<QuerySnapshot> _medicinesStream;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _medicinesStream =
        FirebaseFirestore.instance.collection('Medicine').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF398378),
        title: Text('Medicine List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search for medicines',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _medicinesStream = FirebaseFirestore.instance
                      .collection('Medicine')
                      .where('name', isGreaterThanOrEqualTo: value)
                      .where('name',
                          isLessThan: value +
                              'z') // Adjust this to improve search results
                      .snapshots();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _medicinesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error loading medicines.'));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No medicines found.'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var medicineData = snapshot.data!.docs[index].data()
                          as Map<String, dynamic>;
                      var medicineReference = medicineData['name'];

                      return ListTile(
                        title: Text(medicineReference),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MedicineDetailsPage(
                                  medicineReference: medicineReference),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
