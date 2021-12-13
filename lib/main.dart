//@dart=2.9
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:alimentador/b_General.dart';
import 'a_Inicio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static const String p_general = P_General.ROUTE;
  static const String p_inicio = P_Inicio.ROUTE;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: P_Inicio.ROUTE,
      routes: {
        p_general: (context) => P_General(),
        p_inicio: (context) => P_Inicio(),
      },
      //p_inicio: P_Inicio(),
    );
  }
}
