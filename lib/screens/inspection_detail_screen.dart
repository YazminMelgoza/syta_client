import 'package:flutter/material.dart';
import 'package:syta_client/provider/auth_provider.dart';
import 'package:syta_client/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:syta_client/screens/main_screen.dart';

class InspectionDetailScreen extends StatefulWidget {
  final String inspectionDetailId;
  final String description;
  final String endDate;
  final String startDate;
  final String status;

  InspectionDetailScreen(
      {
        super.key,
        required this.inspectionDetailId,
        required this.description,
        required this.endDate,
        required this.startDate,
        required this.status,
      });

  @override
  State<InspectionDetailScreen> createState() => _InspectionDetailScreenState();
}

class _InspectionDetailScreenState extends State<InspectionDetailScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  bool _isChecked = false;
  TextEditingController _controller = TextEditingController();
  @override
  void initState()
  {
    super.initState();

    addTextToFields();
  }

  void addTextToFields()
  {
    setState(() {
      _controller.text = widget.description;
      if(widget.status=="FINALIZADO")
      {
        _isChecked = true;
      }
    });
  }

  void updateDetail(id,description,status,date)
  {
    _firebaseFirestore.collection("inspectionDetails").doc(id).update({"status": status, "description": description,"endDate": date});
  }
  void deleteDoc(id)
  {
    _firebaseFirestore.collection("inspectionDetails").doc(id).delete().then(
          (doc) => Navigator.pop(context),
      onError: (e) => print("Error updating document $e"),
    );

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
          child: Container(
            margin:EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                SizedBox(width: 10),
                Container(
                  //margin:EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Detalle de Actualización",textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ],
                  ),
                ),
                SizedBox(height: 10),

                Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    widget.description,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    maxLines: null,
                  ),
                ),

                SizedBox(height: 10,),
              ],
            ),
          )
      ),
    );
  }
}

