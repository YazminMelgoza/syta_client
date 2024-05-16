import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:syta_client/screens/inspection_screen.dart';

class CompletedInspections extends StatelessWidget {
  final String carName;
  final String userId;

  const CompletedInspections({
    required this.carName,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          "Revisiones Finalizadas",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('cars')
            .where('actualUserId', isEqualTo: userId)
            .where('name', isEqualTo: carName)
            .get(),
        builder: (context, carSnapshot) {
          if (carSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (carSnapshot.hasError) {
            return Center(child: Text('Error: ${carSnapshot.error}'));
          }
          if (!carSnapshot.hasData || carSnapshot.data!.docs.isEmpty) {
            return Center(child: Text('No se encontró el auto: $carName'));
          }

          final carData = carSnapshot.data!.docs.first.data() as Map<String, dynamic>;
          final carId = carData['id'];

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('inspections')
                .where('carId', isEqualTo: carId)
                .where('status', isEqualTo: 'FINALIZADO')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(child: Text('No hay revisiones finalizadas para $carName'));
              }
              List<QueryDocumentSnapshot> inspections = snapshot.data!.docs;

              return ListView.builder(
                itemCount: inspections.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> inspectionData = inspections[index].data() as Map<String, dynamic>;
                  String description = inspectionData['description'];
                  String title = inspectionData['title'];
                  String documentId = inspections[index].id;
                  String endDate = inspectionData['endDate'];
                  String startDate = inspectionData['startDate'];
                  String status = inspectionData['status'];
                  String carId = inspectionData['carId'];



                  return Center(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check,
                            size: 32,
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              if (!context.mounted) return;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  InspectionScreen(
                                    inspectionId: documentId,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(title, style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),),
                                  Text(description, style: TextStyle(fontSize: 12),textAlign: TextAlign.left,),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
