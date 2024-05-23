import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:syta_client/provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:syta_client/screens/completed_inspections.dart';
import 'package:syta_client/screens/welcome_screen.dart';

class CarData extends StatelessWidget {
  const CarData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(ap.userModel.uid).get(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (userSnapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${userSnapshot.error}')));
        }
        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
          return Scaffold(body: Center(child: Text('No user data found')));
        }

        return FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('cars').where('actualUserId', isEqualTo: ap.userModel.uid).get(),
          builder: (context, carSnapshot) {
            if (carSnapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            if (carSnapshot.hasError) {
              return Scaffold(body: Center(child: Text('Error: ${carSnapshot.error}')));
            }

            final List<Map<String, dynamic>> carsData = carSnapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              data['id'] = doc.id;
              return data;
            }).toList();

            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Vehículos Personales",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
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
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var carData in carsData) ...[
                      Row(
                        children: [
                          Text(
                            'Auto:',
                            style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CompletedInspections(
                                    carName: carData['name'].toString(),
                                    userId: ap.userModel.uid.toString(),
                                    carIdHistorial: carData['id'],
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              carData['name'],
                              style: const TextStyle(fontSize: 18.0),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'Placas:',
                        style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      Text(carData['plates'], style: const TextStyle(fontSize: 18.0)),
                      const SizedBox(height: 10.0),
                      Text(
                        'Año:',
                        style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      Text(carData['model'], style: const TextStyle(fontSize: 18.0)),
                      const SizedBox(height: 20.0),
                    ],
                    
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
