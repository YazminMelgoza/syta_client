import 'package:flutter/material.dart';
import 'package:syta_client/provider/auth_provider.dart';
import 'package:syta_client/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text("SYTA  ${ap.userModel.name}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),),
        actions: [
          IconButton(
            onPressed: () {
              ap.userSignOut().then(
                    (value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    ),
                  );
            },
            icon: const Icon(Icons.exit_to_app, color: Colors.white),
          ),
        ],
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          SizedBox(width: 10),
          Container(
            margin:EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Disponibilidad de Sucursales",textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 19, // Tamaño del título
                    fontWeight: FontWeight.bold, // Negrita para un aspecto de título
                  ),
                ),
                IconButton(onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Información de colores"),
                        content: Container(
                          height: 200,
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                                color: Colors.redAccent,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(bottom: 10),
                                
                                child:
                                Text(
                                  "Disponibilidad Baja",
                                  style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold,fontSize: 18,),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                color: Colors.yellowAccent,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(bottom: 10),
                                child:
                                Text(
                                  "Disponibilidad Media",
                                  style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold,fontSize: 18,),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                color: Colors.greenAccent,
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.only(bottom: 10),
                                child:
                                Text(
                                  "Disponibilidad Alta",
                                  style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold,fontSize: 18,),
                                ),
                              ),

                            ],
                          ),
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cerrar'),
                          ),
                        ],
                      );
                    },
                  );
                },
                    icon: Icon(Icons.info_outline),
                ),
              ],
            ),
          ),

          SizedBox(width: 10),
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
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        width: screenWidth - 40,
                        decoration: BoxDecoration(
                          color: (locationAvaliable=="high") ? Colors.redAccent : (locationAvaliable=="medium") ? Colors.yellowAccent : Colors.greenAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            (locationAvaliable=="high") ? Icon(Icons.lock) : (locationAvaliable=="medium") ? Icon(Icons.lock_clock_rounded) : Icon(Icons.lock_open_rounded),

                            SizedBox(width: 10),
                            GestureDetector(
                                child: Container(
                                  width: screenWidth * 0.8 -40,
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
                                            style: TextStyle(fontSize: 14),
                                            textAlign: TextAlign.left,
                                          ),
                                      Text(
                                        locationAddress,
                                        softWrap: true,
                                        style: TextStyle(fontSize: 12),
                                        textAlign: TextAlign.left,
                                      ),
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

