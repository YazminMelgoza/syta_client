import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syta_client/provider/auth_provider.dart';
import 'package:syta_client/screens/home_screen.dart';
import 'package:syta_client/screens/inspection_detail_screen.dart';
import 'package:syta_client/screens/inspection_Adddetail_screen.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/header.dart';

class LocationsScreen extends StatefulWidget {

  const LocationsScreen({super.key});


  @override
  State<LocationsScreen> createState() => _LocationsScreen();
}

class _LocationsScreen extends State<LocationsScreen> {
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
      appBar: CustomAppBar(titulo: "Sucursales"),
      body: Container(
          color: const Color(0xFFF5F5F5),
          child: Column(
          children: [
          StreamBuilder<QuerySnapshot>(
            stream: _firebaseFirestore.collection('locations').snapshots(),
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
              List<QueryDocumentSnapshot> locations = snapshot.data!.docs;
              return Expanded(
                child: ListView.builder(
                  itemCount: locations.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> locationData = locations[index].data() as Map<String, dynamic>;

                    String documentId        = locations[index].id;
                    String locationName      = locationData['name'];
                    String locationAvaliable = locationData['availability'];
                    String locationAddress   = locationData['address'];
                    String locationPhone     = locationData['phoneNumber'];
                    double screenWidth       = MediaQuery.of(context).size.width;

                    return Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                        padding: const EdgeInsets.only(top: 15, bottom: 20, left: 10, right: 10),
                        decoration: BoxDecoration(
                          color: Color(0xFFFFFCF6),
                          borderRadius: BorderRadius.circular(10),
                          border: Border(
                            bottom: BorderSide(
                              color: const Color(0xFF333333).withOpacity(0.25), // Color con 25% de opacidad
                              width: 2, // Ajusta el grosor del borde según necesidad
                            ),
                          ),
                        ),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                          Text(
                                            locationName,
                                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.left,
                                          ),
                                          Text(
                                            locationPhone,
                                            style: TextStyle(fontSize: 16),
                                            textAlign: TextAlign.left,
                                          ),
                                      Text(
                                        locationAddress,
                                        softWrap: true,
                                        style: TextStyle(fontSize: 16),
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                )
                            ),
                            Container(
                              width: 100,
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    'assets/storeSVG.svg', // Ruta del archivo SVG en tu carpeta de assets
                                    width: 32, // Ajusta el tamaño del SVG
                                    height: 32, // Ajusta el tamaño del SVG
                                    color: locationAvaliable == "high"
                                        ? Color(0xFFD33D30) // Rojo
                                        : locationAvaliable == "medium"
                                        ? Color(0xFFFFA11D) // Naranja
                                        : Color(0xFF62BA5E), // Verde
                                  ),
                                  Text(
                                    locationAvaliable == "high"
                                        ? "No Disponible"
                                        : locationAvaliable == "medium"
                                        ? "Poco Disponible"
                                        : "Disponible",
                                    overflow: TextOverflow.visible,
                                    maxLines: 2,
                                    softWrap: true,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: locationAvaliable == "high"
                                          ? Color(0xFFD33D30) // Rojo
                                          : locationAvaliable == "medium"
                                          ? Color(0xFFFFA11D) // Naranja
                                          : Color(0xFF62BA5E), // Verde
                                    ),
                                  ),
                                ],
                              ),
                            )
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

