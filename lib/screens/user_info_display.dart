import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syta_client/provider/auth_provider.dart' as firebase_auth_providers;
import 'package:syta_client/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

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
                  padding: const EdgeInsets.only(left: 32.0, top: 35.2),  // Adjust padding as needed
                  child: Text(
                    ap.userModel.name,
                    style: const TextStyle(
                      fontSize: 25.0,  // Increase font size
                      fontWeight: FontWeight.bold,  // Make text bold
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: EdgeInsets.only(left: 32.0, top: 32),
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
                      Row(
                        children: [
                          Padding(padding: EdgeInsets.only(top:10),
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.width * 0.3,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.indigo,
                              ),
                              child:
                              Padding(padding: EdgeInsets.only(left: 10),
                                child:
                                Image(
                                    image: AssetImage('assets/preview-928x522.jpg'),  // Specify image asset
                                    fit: BoxFit.cover,
                          )
                              )
                          )
                          ),
                          const Padding(padding: EdgeInsets.only(top:0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(padding: EdgeInsets.only( left: 15),
                                child: Text("Auto: Nissan versa",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize:15,
                                    fontWeight: FontWeight.w400,
                                  ),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 15),
                                child: Text("Modelo: Versa Ultimate",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize:15,
                                    fontWeight: FontWeight.w400,
                                  ),),
                              ),
                              Padding(padding: EdgeInsets.only(left: 15),
                                child: Text("Año: 2016",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize:15,
                                    fontWeight: FontWeight.w400,
                                  ),),
                              ),
                            ],
                          ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          const Padding(padding: EdgeInsets.only(top:0, right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(padding: EdgeInsets.only( left: 15),
                                  child: Text("Auto: Volkswagen Vento",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize:15,
                                      fontWeight: FontWeight.w400,
                                    ),),
                                ),
                                Padding(padding: EdgeInsets.only(left: 15),
                                  child: Text("Modelo: Vento Ultra Auto",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize:15,
                                      fontWeight: FontWeight.w400,
                                    ),),
                                ),
                                Padding(padding: EdgeInsets.only(left: 15),
                                  child: Text("Año: 2020home_screen.dart",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      fontSize:15,
                                      fontWeight: FontWeight.w400,
                                    ),),
                                ),
                              ],
                            ),
                          ),Padding(padding: EdgeInsets.only(top:10),
                              child: Container(
                                  width: MediaQuery.of(context).size.width * 0.3,
                                  height: MediaQuery.of(context).size.width * 0.3,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.indigo,
                                  ),
                                  child:
                                  Padding(padding: EdgeInsets.only(left: 10),
                                      child:
                                      Image(
                                        image: AssetImage('assets/preview-928x522.jpg'),  // Specify image asset
                                        fit: BoxFit.cover,
                                      )
                                  )
                              )
                          ),
                        ],
                      )
                    ],
                  ),)
              ],
            ),
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
