import 'dart:ffi';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:intl/intl.dart';
import 'package:alimentador/Chart.dart';
import 'package:alimentador/DB/db_ConectaDB.dart';
import 'package:alimentador/Models/models.dart';
import 'menu_desplegable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'CircleProgress.dart';
import 'main.dart';
import 'package:flutter/cupertino.dart';

var uwu_lat = '';
var uwu_long = '';
var uwu_pantalla;
var _global_size;
var sector = 1;
double _temperatura = 0;
double _luz = 0;
double _tanque = 0;
double _regado = 0;
double _humedad = 0;
String dropdownValue = '🌱 Sector 1 🌱';
bool especie_sector = false;
double _peso = 0.0;
int _move_action = 0;

class P_General extends StatefulWidget {
  static const String ROUTE = "/general";
  @override
  _P_GeneralState createState() => _P_GeneralState();
}

class _P_GeneralState extends State<P_General> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: P_General_(),
    );
  }
}

class P_General_ extends StatefulWidget {
  @override
  _P_General_State createState() => _P_General_State();
}

class _P_General_State extends State<P_General_>
    with SingleTickerProviderStateMixin {
  void handleDeleteTap() async {
    final result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: AlertDialog(
          title: Text('CONFIRMACIÓN'),
          content: Text(
              '¿ELIMINAR HISTÓRICO? \nLOS DATOS QUE SE HAYAN GUARDADO SE PERDERÁN'),
          actions: <Widget>[
            OutlineButton(
              child: Text('SI'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
            OutlineButton(
              child: Text('NO'),
              onPressed: () => Navigator.of(context).pop(false),
            )
          ],
        ),
      ),
    );
    if (result) {
      Create_DB.borrar_charts();
    }
  }

  void mostrar_graficos() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            40.0,
          ),
        ),
      ),
      builder: (_) {
        return ChartWidget();
      },
    );
  }

  List<Alarmas> _lista = [];
  var initializationSettingsAndroid;
  var initializationSettingsIOS;
  var initializationSettings;

  bool isLoading = false;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();

    BackButtonInterceptor.add(myInterceptor);
    //_showNotification();
  }

  Future onSelectNotification(String payload) async {
    debugPrint('Notification payload: $payload');
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(body),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('Ok'),
                  onPressed: () async {
                    Navigator.of(context, rootNavigator: true).pop();
                    await Fluttertoast.showToast(
                      msg: "2",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                    );
                  },
                )
              ],
            ));
  }

  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    print("BACK BUTTON!"); // Do some stuff.
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    _global_size = size;
    uwu_pantalla = size;
    /*24 is for notification bar on Android*/
    //final themeProvider = Provider.of<ThemeProvider>(context);
    //final double itemHeight = (size.height - kToolbarHeight - 24) / 3.5;
    //final double itemWidth = size.width / 2;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF880E4F),
        title: Text("Take Control"),
      ),
      drawer: DrawerMenu(),
      body: Container(
        //color: Colors.blueGrey[400],
        padding: EdgeInsets.only(top: 10),
        // Asignación de distancia entre el tope y el contrainer
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              // Títuo y dos imágenes
              child: Row(
                children: <Widget>[
                  Image.asset(
                    'assets/Logo_IPN.png',
                    width: 65,
                  ),
                  Text("INICIO",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontFamily: 'Formato_General')),
                  Image.asset(
                    'assets/esime.png',
                    width: 80,
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // Es la separación entre los elementos de la fila
                crossAxisAlignment: CrossAxisAlignment.center,
                //Dentro de la fila - la centra en y
                mainAxisSize: MainAxisSize.max,
                // Dentro de la columna, hace uso de toda pa pantalla
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 40),
            ),
            Temp_Animation(),
            Container(
                padding: EdgeInsets.only(top: 7),
                child: Row(
                  children: <Widget>[
                    FloatingActionButton(
                        heroTag: "-1",
                        backgroundColor: Color(0xFF880E4F),
                        child: Icon(Icons.delete_sweep_outlined),
                        onPressed: () {
                          handleDeleteTap();
                        }),
                    FloatingActionButton(
                        heroTag: "0",
                        backgroundColor: Color(0xFF880E4F),
                        child: Icon(Icons.refresh),
                        onPressed: () {
                          setState(() {});
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => P_General()));
                        }),
                    FloatingActionButton(
                        heroTag: "00",
                        backgroundColor: Color(0xFF880E4F),
                        child: Icon(Icons.pets_outlined),
                        onPressed: () {
                          Fluttertoast.showToast(
                            msg: "Aliemntando",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                          );
                          final databaseReference =
                              FirebaseDatabase.instance.reference();
                          final Map<String, dynamic> data =
                              Map<String, dynamic>();
                          data['Move_Action'] = 1;
                          databaseReference.child('SECTOR2').update(data);
                        }),
                    FloatingActionButton(
                        heroTag: "1",
                        backgroundColor: Color(0xFF880E4F),
                        child: Icon(Icons.stacked_line_chart),
                        onPressed: () {
                          mostrar_graficos();
                        }),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  // Es la separación entre los elementos de la fila
                  crossAxisAlignment: CrossAxisAlignment.end,
                  //Dentro de la fila - la centra en y
                  mainAxisSize: MainAxisSize.max,
                  // Dentro de la columna, hace uso de toda pa pantalla
                )),
          ],
        ),
      ),
    );
  }
}

class Temp_Animation extends StatefulWidget {
  @override
  _Temp_AnimationState createState() => _Temp_AnimationState();
}

class _Temp_AnimationState extends State<Temp_Animation>
    with TickerProviderStateMixin {
  final double itemHeight = (_global_size.height - kToolbarHeight - 24) / 3.5;
  final double itemWidth = _global_size.width / 2;
  bool isLoading = false;
  final databaseReference = FirebaseDatabase.instance.reference();
  double calif_final = 0.0;
  double r_luz = 0.0;
  double r_temp_req = 0.0;
  double r_humedad_aire = 0.0;
  late AnimationController progressController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 1000));
  late Animation<double> tempAnimation =
      Tween<double>(begin: 0, end: 0.toDouble()).animate(progressController)
        ..addListener(() {
          setState(() {});
        });
  late Animation<double> luzAnimation =
      Tween<double>(begin: 0, end: 0.toDouble()).animate(progressController)
        ..addListener(() {
          setState(() {});
        });
  late Animation<double> tanqueAnimation =
      Tween<double>(begin: 0, end: 0.toDouble()).animate(progressController)
        ..addListener(() {
          setState(() {});
        });
  late Animation<double> regadoAnimation =
      Tween<double>(begin: 0, end: 0.toDouble()).animate(progressController)
        ..addListener(() {
          setState(() {});
        });
  late Animation<double> humedadAnimation =
      Tween<double>(begin: 0, end: 0.toDouble()).animate(progressController)
        ..addListener(() {
          setState(() {});
        });
  late Animation<double> generalAnimation =
      Tween<double>(begin: 0, end: 0.toDouble()).animate(progressController)
        ..addListener(() {
          setState(() {});
        });
  String _tipo_con = "";
  @override
  void initState() {
    super.initState();
    tipoconectividad();
    var sector_firebase = 'SECTOR2';
    databaseReference
        .child(sector_firebase)
        .once()
        .then((DataSnapshot snapshot) {
      //Sensores
      _peso = snapshot.value['Peso'];
      _move_action = snapshot.value['Move_Action'];
      _temperatura = _peso.toDouble();
      _actualizandoChart();
      isLoading = true;
      progressController = AnimationController(
          vsync: this, duration: Duration(milliseconds: 1000)); //5s
      tempAnimation = Tween<double>(begin: 0, end: _peso.toDouble())
          .animate(progressController)
            ..addListener(() {
              setState(() {});
            });
      progressController.forward();
      _DashboardInit();
    });
  }

  _actualizandoChart() {
    String string_fecha = DateTime.now().toString();
    print(string_fecha);

    Create_DB.inserta_nuevo_chart(Data_Chart(
        fecha: string_fecha,
        identificador_sector: sector,
        tipo_dato: 1,
        valor: _temperatura));
    Create_DB.select_day_charts();
  }

  tipoconectividad() async {
    ConnectivityResult uwu = await (Connectivity().checkConnectivity());
    setState(() {
      if (uwu == ConnectivityResult.wifi) {
        _tipo_con = "Wifi";
      }
      if (uwu == ConnectivityResult.mobile) {
        _tipo_con = "Datos moviles";
      }
      if (uwu == ConnectivityResult.none) {
        _tipo_con = "No conectado";
      }
    });
  }

  Widget build(BuildContext context) {
    return _DashboardInit();
  }

  _DashboardInit() {
    if (_tipo_con == "No conectado") {
      return Container(
          height: _global_size.height - 310,
          child: GridView.count(
              childAspectRatio: (1),
              //controller: new ScrollController(keepScrollOffset: false),
              crossAxisCount: 1,
              padding: EdgeInsets.all(80),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Container(
                    color: Color(0xFF880E4F),
                    child: CustomPaint(
                      foregroundPainter: TempProgress(tempAnimation.value),
                      child: Container(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Alimento',
                                  style: TextStyle(
                                      color: Colors.yellow,
                                      fontSize: 25,
                                      fontFamily: 'Formato_General')),
                              Text(
                                'Datos',
                                style: TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'No disponibles',
                                style: TextStyle(
                                    color: Colors.yellow,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ]));
    } else {
      return Container(
          height: _global_size.height - 310,
          child: GridView.count(
              childAspectRatio: (1),
              //controller: new ScrollController(keepScrollOffset: false),
              crossAxisCount: 1,
              padding: EdgeInsets.all(80),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Container(
                    color: Color(0xFF880E4F),
                    child: CustomPaint(
                      foregroundPainter: TempProgress(tempAnimation.value),
                      child: Container(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Alimento',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontFamily: 'Formato_General')),
                              Text(
                                '${tempAnimation.value.toStringAsFixed(2)}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'GRAMOS',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ]));
    }
  }
}
