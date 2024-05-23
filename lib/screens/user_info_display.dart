import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syta_client/provider/auth_provider.dart' as firebase_auth_providers;
import 'package:syta_client/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

import 'completed_inspections.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<firebase_auth_providers.AuthProvider>(context, listen: false);

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
      body: Center(
        child: Column(
          children: [  // Added children property
            Row(
              children: [  // Added children property
                Padding(  // Add padding for left margin
                  padding: EdgeInsets.only(left: 32.0, top: 10),  // Adjust padding as needed
                  child: Row(
                    children: [
                      Text(
                        ap.userModel.name,
                        style: TextStyle(
                          fontSize: 25.0,  // Increase font size
                          fontWeight: FontWeight.bold,  // Make text bold
                        ),
                      ),
                      SizedBox(width: 100),
                      CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                        backgroundImage: NetworkImage(ap.userModel.profilePicture),
                        radius: 30,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(left: 32.0, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Nombre",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize:15,
                      fontWeight:  FontWeight.normal,


                    ),),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.indigo,
                      ),
                      child:
                        Padding(padding: EdgeInsets.only(left: 10, top: 5),
                        child:Text(ap.userModel.name,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize:15,
                            fontWeight:  FontWeight.normal,
                          ),
                        ),
                        )
                    )
                  ],
                ),)
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(left: 32.0, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Correo",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize:15,
                          fontWeight:  FontWeight.normal,


                        ),),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.indigo,
                          ),
                          child:
                          Padding(padding: EdgeInsets.only(left: 10, top: 5),
                            child:Text(ap.userModel.email,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:15,
                                fontWeight:  FontWeight.normal,
                              ),
                            ),
                          )
                      )
                    ],
                  ),)
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(left: 32.0, top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Telefono",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize:15,
                          fontWeight:  FontWeight.normal,


                        ),),
                      Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.indigo,
                          ),
                          child:
                          Padding(padding: EdgeInsets.only(left: 10,top: 5),
                            child:Text(ap.userModel.phoneNumber,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize:15,
                                fontWeight:  FontWeight.normal,
                              ),
                            ),
                          )
                      )
                    ],
                  ),)
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(left: 32.0, top: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Vehiculos personales",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize:20,
                          fontWeight: FontWeight.w500,
                        ),),
                    ],
                  ),)
              ],
            ),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('cars').where('actualUserId', isEqualTo: ap.userModel.uid).snapshots(),
                        builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtienen los datos.
                            }
                            if (snapshot.hasError) {
                            return Text('Error al obtener los datos: ${snapshot.error}');
                            }
                            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                            return Text('No hay datos disponibles'); // Muestra un mensaje si no hay datos disponibles.
                            }
                            return ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (BuildContext context, int index)
                                {
                                  DocumentSnapshot car = snapshot.data!.docs[index];
                                  print(car['name']);
                                  return Row(
                                    children: [
                                      Expanded(
                                        flex: 4, // 40% del ancho total
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 0, right: 20, left: 30),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Auto: " + car['name'],
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Text(
                                                "Modelo: " + car['model'],
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Text(
                                                "Placas: " + car['plates'],
                                                textAlign: TextAlign.start,
                                                style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3, // 30% del ancho total
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 10, right: 30, left: 0, bottom: 10),
                                          child: Container(

                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.indigo,
                                            ),
                                            child: IconButton(
                                              icon: const Icon(
                                                Icons.car_repair_rounded,
                                                size: 80,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => CompletedInspections(
                                                      carName: car['name'].toString(),
                                                      userId: ap.userModel.uid.toString(),
                                                      carIdHistorial: car.id,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );

                                },
                            );
                        }
                        )
            )
          ],

      /*mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            backgroundImage: NetworkImage(ap.userModel.profilePicture),
            radius: 50,
          ),
          const SizedBox(height: 20),
          Text(ap.userModel.name),
          Text(ap.userModel.phoneNumber),
          Text(ap.userModel.email),
        ],
      */)),
    );
  }
}
