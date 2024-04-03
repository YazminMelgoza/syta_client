import 'package:flutter/material.dart';
import 'package:syta_client/widgets/custom_button.dart';
import 'package:syta_client/screens/register_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 0),
            // make scrollable content 
            child: SingleChildScrollView(
              child: Column(
              children: [
                Image.asset('assets/logo.png', height: 200.0),
                const SizedBox(height: 20.0),
                const Text(
                  'Comencemos a ver el estado de tu vehículo',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 10.0),
                const Text(
                  'Inicia sesión para continuar',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54
                  ),
                ),

                const SizedBox(height: 20.0),
                // custom button
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'Iniciar sesión',
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(pageBuilder: (context, animation1, animation2) => const RegisterScreen(),
                        transitionsBuilder: (context, animation1, animation2, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.ease;
                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                          var offsetAnimation = animation1.drive(tween);
                          return SlideTransition(
                            position: offsetAnimation,
                            child: child
                          );
                        }
                        )
                        );
                    }
                  )
                ),
              ]
            )
          )
          )
        ),
      )
    );
  }
}