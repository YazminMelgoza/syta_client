import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syta_client/provider/auth_provider.dart';
import 'package:syta_client/screens/pending_inspections.dart';
import 'package:syta_client/screens/welcome_screen.dart';
import 'package:syta_client/screens/inspection_screen.dart';
import 'package:syta_client/screens/locations_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  String carName = "";
  String userName = "";
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("SYTA Mantenimiento", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
        actions: [
          IconButton(
            onPressed: () {
              ap.userSignOut().then(
                    (value) => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WelcomeScreen(),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
          ),
        ],
      ),
      body: Column(

        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: const Text(
                  'Revisiones en Progreso',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(height: 10,),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _firebaseFirestore.collection('inspections')
                .where("userId", isEqualTo: ap.uid)
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
                          return CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtienen los datos.
                        }
                        if (snapshot.hasError) {
                          return Text('Error al obtener los datos: ${snapshot.error}');
                        }
                        if (!snapshot.hasData) {
                          return Text('No hay datos disponibles');
                        }

                        String carName = snapshot.data![0];
                        String userName = snapshot.data![1];


                        return 
                        GestureDetector(
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
                        child: Center(
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                    Icons.car_repair_rounded,
                                    size: 32,
                                    color: Colors.blue,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(inspectionData['title'],
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),),
                                      Text(carName, style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
                                      Text(userName, style: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold,),),
                                      Text("Fecha estimada: $date", style: const TextStyle(fontSize: 12),textAlign: TextAlign.left,),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
    );
  }
}