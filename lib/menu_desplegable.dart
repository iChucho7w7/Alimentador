import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:alimentador/a_Inicio.dart';
import 'package:alimentador/b_General.dart';
import 'main.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _buildDrawerHeader(),
          _buildDrawerItem(
              icon: Icons.home,
              text: 'TAKE CONTROL',
              onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => P_Inicio()))
                  }),
          _buildDrawerItem(
              icon: Icons.graphic_eq_rounded,
              text: 'INICIO',
              onTap: () => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => P_General()))
                  }),
          Divider(),
          _buildDrawerItem(
              icon: Icons.exit_to_app_rounded,
              text: 'SALIR',
              onTap: () => {Navigator.pop(context), exit(0)}),
          Divider(),
          ListTile(
            title: Text('Versión de aplicación 1.2.0'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            color: Color(0xFF880E4F),
            image: DecorationImage(
                fit: BoxFit.fill, image: AssetImage('assets/ipnesime2.png'))),
        child: Stack(children: <Widget>[]));
  }

  Widget _buildDrawerItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
