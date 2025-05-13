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
import 'package:carousel_slider/carousel_slider.dart' as carousel;



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

    return Scaffold(
      appBar: CustomAppBar(titulo: "Bienvenido"),
      body: Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                child: Row(
                  children: const [
                    Text(
                      "Revisiones ",
                      style: TextStyle(
                        color: Color(0xFF1A1A77),
                        fontWeight: FontWeight.w600,
                        fontSize: 28,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      " Activas",
                      style: TextStyle(
                        color: Color(0xFFFF6A00),
                        fontWeight: FontWeight.w800,
                        fontSize: 28,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),

                  ],
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _firebaseFirestore
                    .collection('inspections')
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
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No hay inspecciones activas.'),
                    );
                  }

                  List<QueryDocumentSnapshot> inspections = snapshot.data!.docs;

                  return Container(
                    height: 450,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: carousel.CarouselSlider(
                      options: carousel.CarouselOptions(
                        height: 450,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                        viewportFraction: 0.9,
                      ),
                      items: inspections.map((doc) {
                        Map<String, dynamic> inspectionData =
                        doc.data() as Map<String, dynamic>;
                        String inspectionId = doc.id;
                        String carId = inspectionData['carId'];
                        String userId = inspectionData['userId'];
                        String estimatedDate = inspectionData['estimatedDate'];
                        String title = inspectionData['title'];

                        int millisecondsDate = int.parse(estimatedDate);
                        DateTime date =
                        DateTime.fromMillisecondsSinceEpoch(millisecondsDate);
                        String formattedDate =
                            "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

                        return FutureBuilder(
                          future: Future.wait([
                            _firebaseFirestore.collection('cars').doc(carId).get(),
                            _firebaseFirestore.collection('users').doc(userId).get(),
                          ]),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
                            }
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            String carName = snapshot.data![0].get('name');
                            String userName = snapshot.data![1].get('name');

                            return InspectionCard(
                              inspectionId: inspectionId,
                              title: title,
                              userName: userName,
                              carName: carName,
                              formattedDate: formattedDate,
                              onTap: () {
                                if (!context.mounted) return;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => InspectionScreen(inspectionId: inspectionId),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                child: 
                Text("Puedes presionar sobre alguna de las revisiones para conocer más detalles."),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class InspectionCard extends StatelessWidget {
  final String inspectionId;
  final String title;
  final String userName;
  final String carName;
  final String formattedDate;
  final VoidCallback onTap;

  const InspectionCard({
    Key? key,
    required this.inspectionId,
    required this.title,
    required this.userName,
    required this.carName,
    required this.formattedDate,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.all(15),
        height: 400, // Altura fija
        decoration: BoxDecoration(
          color: Color(0xFFFFFCF6),
          borderRadius: BorderRadius.circular(10),
          border: Border(
            bottom: BorderSide(
              color: const Color(0xFF333333).withOpacity(0.25),
              width: 2,
            ),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.person, "Usuario: $userName"),
                    const SizedBox(height: 5),
                    _buildInfoRow(Icons.directions_car, "Vehículo: $carName"),
                    const SizedBox(height: 5),
                    _buildInfoRow(Icons.calendar_today, "Fecha Estimada: $formattedDate"),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/img/herramientas.png',
                          height: 70,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 10,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFFF6A00),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            ),
          ],
        ),
      ),

    );
  }

  // Widget para las filas de información con iconos pequeños
  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Color(0xFF121230),  // Color del ícono pequeño
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}





