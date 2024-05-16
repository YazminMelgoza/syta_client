import 'package:flutter/material.dart';
import 'package:syta_client/provider/auth_provider.dart';
import 'package:syta_client/screens/home_screen.dart';
import 'package:syta_client/screens/inspection_detail_screen.dart';
import 'package:syta_client/screens/inspection_Adddetail_screen.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:syta_client/screens/main_screen.dart';

class InspectionScreen extends StatefulWidget {
  final String inspectionId;
  const InspectionScreen({super.key,required this.inspectionId});


  @override
  State<InspectionScreen> createState() => _InspectionScreenState();
}

class _InspectionScreenState extends State<InspectionScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  bool isChecked = false;
  void actualizarEstatus( String id, String status, String dateF)
  {
    _firebaseFirestore.collection("inspectionDetails").doc(id).update({"status": status, "endDate": dateF});
  }
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text("SYTA  ${ap.userModel.name}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MainScreen(),
                  ), (route) => false);
            },
            icon: const Icon(Icons.home, color: Colors.white),
          ),
        ],
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Text("Inspeccion:  " + widget.inspectionId),
          SizedBox(width: 10),
          Container(
            margin:EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Lista de Actualizaciones",textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 20, // Tamaño del título
                    fontWeight: FontWeight.bold, // Negrita para un aspecto de título

                  ),
                ),

              ],
            ),
          ),

          SizedBox(width: 10),
          StreamBuilder<QuerySnapshot>(
            stream: _firebaseFirestore.collection('inspectionDetails').where("inspectionId", isEqualTo: widget.inspectionId).snapshots(),
            builder: (context, snapshot)
            {
              if (snapshot.connectionState == ConnectionState.waiting)
              {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError)
              {
                return Text('Error al obtener los datos: ${snapshot.error}');
              }
              if (!snapshot.hasData)
              {
                return Text('No hay documentos disponibles');
              }
              List<QueryDocumentSnapshot> users = snapshot.data!.docs;
              return Expanded(
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> userData = users[index].data() as Map<String, dynamic>;
                    String documentId = users[index].id;
                    String userStatus = userData['status'];
                    String endDate = "";
                    int milliseconsDate = int.parse(userData['startDate']);
                    DateTime startNormalDate = DateTime.fromMillisecondsSinceEpoch(milliseconsDate);
                    String startDate = startNormalDate.toString();
                    //Date in millisecons
                    if(userData['status']=="FINALIZADO"){
                      int fechaEnMilisegundos = int.parse(userData['endDate']); // Por ejemplo, 1617948600000 representa el 09 de abril de 2021
                      DateTime fechaNormal = DateTime.fromMillisecondsSinceEpoch(fechaEnMilisegundos);
                      endDate = fechaNormal.toString();
                    }


                    return Center(
                      child: Container(
                        //width: 200,
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (userStatus=="FINALIZADO") ? Colors.blue[50] : Colors.orangeAccent, // Color de fondo del Container
                          borderRadius: BorderRadius.circular(10), // Radio de borde del Container
                        ),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                              },
                              icon: (userStatus=="FINALIZADO") ? Icon(Icons.check_circle) : Icon(Icons.check_circle_outline),
                              iconSize: 32,
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                                onTap: () {
                                  if (!context.mounted) return;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InspectionDetailScreen(
                                          inspectionDetailId: documentId,
                                          description: userData['description'],
                                          endDate: endDate,
                                          startDate: startDate,
                                          status: userData['status']
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  child: Column(
                                    children: [
                                      Text(userData['description'],
                                        style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,),),
                                      Text(endDate, style: TextStyle(fontSize: 12),textAlign: TextAlign.left,),
                                    ],
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),

          SizedBox(height: 20),
        ],
      )),
    );
  }
}

