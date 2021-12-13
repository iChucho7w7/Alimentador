import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:alimentador/DB/db_ConectaDB.dart';
import 'package:alimentador/Models/models.dart';
import 'b_General.dart';
import 'package:fluttertoast/fluttertoast.dart';

class P_Inicio extends StatefulWidget {
  static const String ROUTE = "/inicio";

  @override
  _P_InicioState createState() => _P_InicioState();
}

class _P_InicioState extends State<P_Inicio> {
  @override
  //Texto Principal
  Widget build(BuildContext context) {
    //final themeProvider = Provider.of<ThemeProvider>(context);
    Fluttertoast.showToast(
      msg: "BIENVENIDO",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
    return Scaffold(
      backgroundColor: Color(0xFF880E4F),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              RichText(
                text: TextSpan(
                    text: "Alimentador Inteligente",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontFamily: 'Formato_General')),
              ),
              Image.asset(
                'assets/patas.png',
                width: 300,
              ),
              FloatingActionButton(
                  heroTag: "-1",
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.login,
                    color: Color(0xFF880E4F),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => P_General()));
                  }),
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
          ),
        ),
      ),
    );
  }
}
