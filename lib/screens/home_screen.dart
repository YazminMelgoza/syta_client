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
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
             ElevatedButton(
                onPressed: () {
                  if (!context.mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PendingInspections(
                        userId: ap.userModel.uid, // Pasa el userId
                      ),
                    ),
                  );
                },
                child: const Text('Inspecciones pendientes'),
              ),
              ElevatedButton(
                onPressed: ()
                {
                  if (!context.mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LocationsScreen(

                      ),
                    ),
                  );
                },
                child: const Text('Ver Sucursales'),
              ),
            ],
          )),
    );
  }
}