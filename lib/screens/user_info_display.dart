import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syta_client/provider/auth_provider.dart' as firebase_auth_providers;
import 'package:syta_client/screens/user_cars.dart';
import 'package:syta_client/screens/user_information_screen.dart';
import 'package:syta_client/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

import '../widgets/customButton.dart';
import '../widgets/header.dart';
import 'completed_inspections.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final user = _firebaseAuth.currentUser;

    final ap = Provider.of<firebase_auth_providers.AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: CustomAppBar(titulo: "Mi Perfil"),
      body: Container(
          color: const Color(0xFFF5F5F5),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    padding: const EdgeInsets.only(top: 30, bottom: 30, left: 10, right: 10),
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

                        user?.photoURL   != null
                            ? CircleAvatar(
                          backgroundImage: NetworkImage(user!.photoURL!),
                          radius: 50,
                        )
                            : Icon(
                          Icons.account_circle,
                          size: 100,
                          color: Color(0xFF121230),
                        ),
                        Row(
                          children: [
                            SizedBox(width:24),
                            Expanded(
                              child: Container(
                                alignment: Alignment.center,
                                child: (user!.displayName! != "") ?
                                Text(user.displayName!,
                                    style: TextStyle(
                                    color: Color(0xFF121230),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )
                                ) :
                                Text("Agrega tu nombre",
                                    style: TextStyle(
                                      color: Color(0xFF121230),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    )
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                size: 24,
                                color: Color(0xFF121230),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => UserInfromationScreen()),
                                );
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.phone,
                              size: 13, // Tamaño del icono
                              color: Color(0xFF121230), // Color del icono
                            ),
                            Text("Telefono: " + user.phoneNumber!,
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        CustomRowButton(
                          iconData: Icons.directions_car,
                          text: "Ver mis autos",
                          backgroundColor: Color(0xFF1A1A77),
                          textColor: Color(0xFFF5F5F5),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CarData(uid: user.uid),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
              child: CustomRowButton(
                iconData: Icons.logout,
                text: "Salir",
                backgroundColor: Color(0xFFD33D30),
                textColor: Color(0xFFF5F5F5),
                onTap: () {
                  ap.userSignOut().then(
                        (value) => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                    ),
                  );

                },
              ),
            ),

          ],

        )
      ),
    );
  }
}
