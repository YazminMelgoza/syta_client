import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syta_client/provider/auth_provider.dart';
import 'package:syta_client/screens/pending_inspections.dart';
import 'package:syta_client/screens/welcome_screen.dart';
import 'package:syta_client/screens/inspection_screen.dart';
import 'package:syta_client/screens/locations_screen.dart';
import 'package:provider/provider.dart';

import '../widgets/header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String carName = "";
  String userName = "";
  @override
  Widget build(BuildContext context) {
    final user = _firebaseAuth.currentUser;
    //final ap = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: CustomAppBar(titulo: "Revisiones"),
      body: Container(
        color: const Color(0xFFF5F5F5),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _firebaseFirestore.collection('inspections')
                  .where("userId", isEqualTo: user!.uid)
                  .where("status", isEqualTo: "EN PROGRESO")
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Error al obtener los datos: ${snapshot.error}');
                }
                if (!snapshot.hasData) {
                  return const Text('No hay documentos disponibles');
                }

                List<QueryDocumentSnapshot> inspections = snapshot.data!.docs;

                return Expanded(
                  child: ListView.builder(
                    itemCount: inspections.length,
                    itemBuilder: (context, index)
                    {
                      Map<String, dynamic> inspectionData = inspections[index].data() as Map<String, dynamic>;
                      //Datos de la inspección
                      String inspectionId    = inspections[index].id;
                      String carId           = inspectionData['carId'];
                      String description     = inspectionData['description'];
                      String endDate         = inspectionData['endDate'];
                      String estimatedDate   = inspectionData['estimatedDate'];
                      String locationId      = inspectionData['locationId'];
                      String startDate       = inspectionData['startDate'];
                      String status          = inspectionData['status'];
                      String title           = inspectionData['title'];
                      String userId          = inspectionData['userId'];

                      int milliseconsDate = int.parse(estimatedDate);
                      DateTime startNormalDate = DateTime.fromMillisecondsSinceEpoch(milliseconsDate);
                      String date = "${startNormalDate.year}-${startNormalDate.month.toString().padLeft(2, '0')}-${startNormalDate.day.toString().padLeft(2, '0')}";

                      String userName = userId;
                      String carName =  carId;

                      Future<String> getCarName(String carId) async {
                        DocumentSnapshot carSnapshot = await _firebaseFirestore.collection('cars').doc(carId).get();
                        return carSnapshot.get('name');
                      }
                      Future<String> getUserName(String userId) async {
                        DocumentSnapshot userSnapshot = await _firebaseFirestore.collection('users').doc(userId).get();
                        return userSnapshot.get('name');
                      }

                      return FutureBuilder(
                        future: Future.wait([
                          getCarName(carId),
                          getUserName(userId),
                        ]),
                        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Text("");
                          }
                          if (snapshot.hasError) {
                            return Text('Error al obtener los datos: ${snapshot.error}');
                          }
                          if (!snapshot.hasData) {
                            return Text('No hay dato disponibles');
                          }

                          String carName = snapshot.data![0];
                          String userName = snapshot.data![1];


                          return GestureDetector(
                            onTap: () {
                              if (!context.mounted) return;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>  InspectionScreen(
                                    inspectionId: inspections[index].id,

                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                              padding: const EdgeInsets.only(top: 5, bottom: 10, left: 10, right: 10),
                              decoration: BoxDecoration(
                                color: Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(0),
                                border: Border(
                                  bottom: BorderSide(
                                    color: const Color(0xFF333333).withOpacity(0.25),
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(inspectionData['title'],
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xFF121230),
                                              ),
                                            ),
                                            Text(userName, overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 16,),),
                                            Text("Auto: ${carName}", overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 16,),),
                                            Text("Fecha Estimada: ${date}", overflow: TextOverflow.ellipsis,
                                              style: TextStyle(fontSize: 16),textAlign: TextAlign.left,),
                                          ],
                                        ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    children: [
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(Icons.car_repair_rounded),
                                        iconSize: 32,
                                      ),
                                      Text("En Curso", overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 14,),),
                                    ],
                                  ),

                                ],
                              ),
                            ),

                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}