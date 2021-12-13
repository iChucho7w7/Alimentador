import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:alimentador/Models/models.dart';
import 'package:collection/iterable_zip.dart';

class Create_DB {
  //Función ascincrona que permite abrir la base de datos y donde se define su estructura principal?
  static Future<Database> _openDB() async {
    return openDatabase(join(await getDatabasesPath(), 'take_control2.db'),
        version: 1, onCreate: (Database db, int version) {
      //Catalogos
      db.execute(
          "create table Catalogo_Alarmas(id_catalogo_alarma smallint identity(1,1) primary key,tipo_alarma nvarchar(20) not null);");
      db.execute(
          "create table Catalogo_Tipo_Especie(id_tipo_especie smallint identity(1,1) primary key,tipo_especie nvarchar(20) not null);");
      db.execute(
          "Create table Catalogo_Referencias(id_catalogo_referencia smallint identity(1,1) primary key,tipo_referencia nvarchar(20) not null);");
      db.execute(
          "create table Catalogo_Sectores(id_sector smallint identity(1,1) primary key,tipo_sector nvarchar(20) not null);");
      db.execute(
          "create table catalogo_preguntas(id_pregunta smallint identity(1,1) primary key,desc_pergunta nvarchar(50) not null);");
      db.execute(
          "create table Catalogo_Datos(id_dato smallint identity(1,1) primary key,tipo_dato nvarchar(20) not null);");
      //Tablas
      db.execute(
          "create table Tabla_Especies(identificador_especie nvarchar(10) primary key,nombre_especie nvarchar(30) not null,tipo_especie smallint not null,temperatura_max float not null,temperatura_min float not null,temperatura_requerida float not null,humedad_requerida float not null,frecuencia_dias_regado smallint not null,frecuencia_hrs_regado smallint not null,frecuencia_min_regado smallint not null,litros_x_regado float not null,descripcion_especie nvarchar(500),sector smallint,foto_especie LONGBLOB not null,constraint fk_tipo_especie foreign key (tipo_especie) references Catalogo_Tipo_Especie (id_tipo_especie),constraint fk_tio_sector foreign key (sector) references Catalogo_sectores (id_sector));");
      db.execute(
          "create table Tabla_Programacion_Alarrmas(id_alarma nvarchar(30) primary key,id_especie_alarma nvarchar(10) not null,nombre_especie_alarma nvarchar(30) not null, tipo_alarma smallint not null,tipo_referencia smallint not null,valor_alarma float not null, descripcion_alarma nvarchar(100) not null, constraint fk_id_especie_alarma foreign key (id_especie_alarma) references Tabla_Especies(identificador_especie),constraint fk_tipo_alarma foreign key (tipo_alarma) references Catalogo_Alarmas(id_catalogo_alarma),constraint fk_tipo_referencia foreign key (tipo_referencia) references Catalogo_Referencias(id_catalogo_referencia));");
      db.execute(
          "create table Tabla_accedder (id_acceso smallint identity(1,1) primary key,tip_pregunta smallint not null,ans_pregunta nvarchar(20) not null,my_pass nvarchar(5),constraint fk_tipo_pregunta foreign key (tip_pregunta) references catalogo_preguntas (id_pregunta));");
      db.execute(
          "create table Tabla_Datos_Grafica(fecha_dg TEXT not null,id_sector_dg smallint not null,tipo_dato_dg smallint not null,valor_dg float not null,constraint fk_id_sector foreign key (id_sector_dg) references Catalogo_Sectores(id_sector),constraint fk_tipo_dato foreign key (tipo_dato_dg) references Catalogo_Datos(id_dato));");
      //Vlores de catalogos
      db.execute("insert into Catalogo_Alarmas values (1,'Nivel de agua');");
      db.execute("insert into Catalogo_Alarmas values (2,'Temperatura');");
      db.execute("insert into Catalogo_Alarmas values (3,'Humedad del aire');");
      db.execute(
          "insert into Catalogo_Alarmas values (4,'Humedad del suelo');");
      db.execute("insert into Catalogo_Alarmas values (5,'Luz Solar');");

      db.execute("insert into Catalogo_Tipo_Especie values (1,'Sol');");
      db.execute("insert into Catalogo_Tipo_Especie values (2,'Sombra');");
      db.execute("insert into Catalogo_Tipo_Especie values (3,'Semisombra');");

      db.execute("insert into Catalogo_Referencias values(1,'Igual a');");
      db.execute("insert into Catalogo_Referencias values(2,'Mayor a');");
      db.execute("insert into Catalogo_Referencias values(3,'Menor a');");
      db.execute(
          "insert into Catalogo_Referencias values(4,'Mayor igual que');");
      db.execute(
          "insert into Catalogo_Referencias values(5,'Menor igual que');");

      db.execute("insert into Catalogo_Sectores values (0,'NS');");
      db.execute("insert into Catalogo_Sectores values (1,'Sector 1');");
      db.execute("insert into Catalogo_Sectores values (2,'Sector 2');");
      db.execute("insert into Catalogo_Sectores values (3,'Sector 3');");
      db.execute("insert into Catalogo_Sectores values (4,'Sector 4');");
      db.execute("insert into Catalogo_Sectores values (5,'Sector 5');");
      db.execute("insert into Catalogo_Sectores values (6,'Sector 6');");
      db.execute("insert into Catalogo_Sectores values (7,'Sector 7');");
      db.execute("insert into Catalogo_Sectores values (8,'Sector 8');");
      db.execute("insert into Catalogo_Sectores values (9,'Sector 9');");
      db.execute("insert into Catalogo_Sectores values (10,'Sector 10');");

      db.execute(
          "insert into catalogo_preguntas values (1,'¿DEPORTE FAVORITO?');");
      db.execute(
          "insert into catalogo_preguntas values (2,'¿MASCOTA FAVORITA?');");
      db.execute(
          "insert into catalogo_preguntas values (3,'¿ARTISTA FAVORITO?');");

      db.execute("insert into Catalogo_Datos values(1,'Temperatura');");
      db.execute("insert into Catalogo_Datos values(2,'Luz');");
      db.execute("insert into Catalogo_Datos values(3,'Tanque');");
      db.execute("insert into Catalogo_Datos values(4,'Regado');");
      db.execute("insert into Catalogo_Datos values(5,'Humedad');");
      db.execute("insert into Catalogo_Datos values(6,'General');");
    });
  }

  // Insertar nueva especie
  static Future<int> inserta_nueva_especie(Especies especie) async {
    Database database = await _openDB();
    return database.insert('Tabla_Especies', especie.toMap());
  }

  //Borra especie
  static Future<int> borrar_especie(Especies especie) async {
    Database database = await _openDB();
    return database.delete('Tabla_Especies',
        where: 'identificador_especie = ?', whereArgs: [especie.identificador]);
  }

  //Actualiza Especie
  static Future<int> actualiza_especie(
      Especies especie, String id_original) async {
    Database database = await _openDB();
    return database.update('Tabla_Especies', especie.toMap(),
        where: 'identificador_especie = ?', whereArgs: [id_original]);
  }

  // select * from esecies
  static Future<List<Especies>> select_all_especies() async {
    Database database = await _openDB();
    final List<Map<String, dynamic>> especiesMap =
        await database.query("Tabla_Especies");
    for (var n in especiesMap) {
      print("Especies --> " +
          n['identificador_especie'] +
          ", " +
          n['nombre_especie'] +
          ", " +
          n['temperatura_max'].toString() +
          ", " +
          n['temperatura_requerida'].toString() +
          ", " +
          n['humedad_requerida'].toString() +
          ", " +
          n['temperatura_min'].toString() +
          ", " +
          n['frecuencia_dias_regado'].toString() +
          ", " +
          n['frecuencia_hrs_regado'].toString() +
          ", " +
          n['frecuencia_min_regado'].toString() +
          ", " +
          n['litros_x_regado'].toString() +
          ", " +
          n['descripcion_especie'] +
          ", " +
          n['tipo_especie'].toString() +
          ", " +
          n['sector'].toString() +
          ", " +
          n['foto_especie'].toString());
    }
    return List.generate(
        especiesMap.length,
        (i) => Especies(
            identificador: especiesMap[i]['identificador_especie'],
            nombre: especiesMap[i]['nombre_especie'],
            temp_max: especiesMap[i]['temperatura_max'],
            temp_req: especiesMap[i]['temperatura_requerida'],
            temp_min: especiesMap[i]['temperatura_min'],
            hum_req: especiesMap[i]['humedad_requerida'],
            freq_reg_dias: especiesMap[i]['frecuencia_dias_regado'],
            freq_reg_hrs: especiesMap[i]['frecuencia_hrs_regado'],
            freq_reg_min: especiesMap[i]['frecuencia_min_regado'],
            litros_regado: especiesMap[i]['litros_x_regado'],
            caracteristicas: especiesMap[i]['descripcion_especie'],
            tipo_especie: especiesMap[i]['tipo_especie'],
            tipo_sector: especiesMap[i]['sector'],
            foto_especie: especiesMap[i]['foto_especie']));
  }

  static Future<List<Especies>> select_busqueda_especies(String name) async {
    Database database = await _openDB();
    final List<Map<String, dynamic>> especiesMap = await database.query(
        "Tabla_Especies",
        where: 'nombre_especie = ?',
        whereArgs: [name]);
    for (var n in especiesMap) {
      print("Especies --> " +
          n['identificador_especie'] +
          ", " +
          n['nombre_especie'] +
          ", " +
          n['temperatura_max'].toString() +
          ", " +
          n['temperatura_requerida'].toString() +
          ", " +
          n['temperatura_min'].toString() +
          ", " +
          n['humedad_requerida'].toString() +
          ", " +
          n['frecuencia_dias_regado'].toString() +
          ", " +
          n['frecuencia_hrs_regado'].toString() +
          ", " +
          n['frecuencia_min_regado'].toString() +
          ", " +
          n['litros_x_regado'].toString() +
          ", " +
          n['descripcion_especie'] +
          ", " +
          n['tipo_especie'].toString() +
          ", " +
          n['sector'].toString() +
          ", " +
          n['foto_especie'].toString());
    }
    return List.generate(
        especiesMap.length,
        (i) => Especies(
            identificador: especiesMap[i]['identificador_especie'],
            nombre: especiesMap[i]['nombre_especie'],
            temp_max: especiesMap[i]['temperatura_max'],
            temp_req: especiesMap[i]['temperatura_requerida'],
            temp_min: especiesMap[i]['temperatura_min'],
            hum_req: especiesMap[i]['humedad_requerida'],
            freq_reg_dias: especiesMap[i]['frecuencia_dias_regado'],
            freq_reg_hrs: especiesMap[i]['frecuencia_hrs_regado'],
            freq_reg_min: especiesMap[i]['frecuencia_min_regado'],
            litros_regado: especiesMap[i]['litros_x_regado'],
            caracteristicas: especiesMap[i]['descripcion_especie'],
            tipo_especie: especiesMap[i]['tipo_especie'],
            tipo_sector: especiesMap[i]['sector'],
            foto_especie: especiesMap[i]['foto_especie']));
  }

  // Validaciones especies

  static Future<bool> valida_existencia_especie(Especies especie) async {
    //Con respecto a una id
    Database database = await _openDB();
    final List<Map<String, dynamic>> especiesMap = await database.query(
        'Tabla_Especies',
        where: 'identificador_especie = ?',
        whereArgs: [especie.identificador]);
    print(especiesMap.length);
    if (especiesMap.length == 0) {
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> valida_seleccion_sector(Especies especie) async {
    //con respecto a si existe el sector seleccionado
    //Agregando especie 1
    //Editando epecie 0
    Database database = await _openDB();
    final List<Map<String, dynamic>> especiesMap = await database.query(
        'Tabla_Especies',
        where: 'sector = ?',
        whereArgs: [especie.tipo_sector]);
    print(especiesMap.length);
    if (especiesMap.length == 0) {
      return false;
    } else {
      // valida que no hay pepe con el sector 0 porque es para todos
      if (especie.tipo_sector == 0) {
        return false;
      } else {
        return true;
      }
    }
  }

  //-------------------------------Alarmas-------------------------------------

  // select * from Alarmas
  static Future<List<Alarmas>> select_all_alarmas() async {
    Database database = await _openDB();
    final List<Map<String, dynamic>> alarmasMap =
        await database.query("Tabla_Programacion_Alarrmas");
    for (var n in alarmasMap) {
      print("Alarmas --> " +
          n['id_alarma'] +
          ", " +
          n['id_especie_alarma'] +
          ", " +
          n['nombre_especie_alarma'] +
          ", " +
          n['tipo_alarma'].toString() +
          ", " +
          n['tipo_referencia'].toString() +
          ", " +
          n['valor_alarma'].toString() +
          ", " +
          n['descripcion_alarma']);
    }
    return List.generate(
        alarmasMap.length,
        (i) => Alarmas(
            identificador_alarma: alarmasMap[i]['id_alarma'],
            identificador_especie: alarmasMap[i]['id_especie_alarma'],
            nombre_especie: alarmasMap[i]['nombre_especie_alarma'],
            tipo_alarma: alarmasMap[i]['tipo_alarma'],
            tipo_ref: alarmasMap[i]['tipo_referencia'],
            valor_alarma: alarmasMap[i]['valor_alarma'],
            descripcion_alarma: alarmasMap[i]['descripcion_alarma']));
  }

  // Insertar nueva alarma
  static Future<int> inserta_nueva_alarma(Alarmas alarma) async {
    Database database = await _openDB();
    return database.insert('Tabla_Programacion_Alarrmas', alarma.toMap());
  }

  //Borra alarma
  static Future<int> borrar_alarma(Alarmas alarma) async {
    Database database = await _openDB();
    return database.delete('Tabla_Programacion_Alarrmas',
        where: 'id_alarma = ?', whereArgs: [alarma.identificador_alarma]);
  }

  static Future<int> borrar_alarma_2(String id) async {
    Database database = await _openDB();
    return database.delete('Tabla_Programacion_Alarrmas',
        where: 'id_especie_alarma = ?', whereArgs: [id]);
  }

  //Actualiza alarma
  static Future<int> actualiza_alarma(Alarmas alarma, String id) async {
    Database database = await _openDB();
    return database.update('Tabla_Programacion_Alarrmas', alarma.toMap(),
        where: 'id_alarma = ?', whereArgs: [id]);
  }

  static Future actualiza_datos_alarma(
      String id, String new_id, String nom) async {
    Database database = await _openDB();
    nom = "'" + nom + "'";
    id = "'" + id + "'";
    new_id = "'" + new_id + "'";
    String comando =
        'update Tabla_Programacion_Alarrmas set id_especie_alarma=$new_id, nombre_especie_alarma=$nom where id_especie_alarma=$id';
    database.rawQuery(comando);
  }

  //Validaciones tablas de alarmas
  static Future<bool> valida_coincidencia_sector_id(
      String id, int sector) async {
    Database database = await _openDB();
    final List<Map<String, dynamic>> especiesMap = await database.query(
        'Tabla_Especies',
        where: 'identificador_especie = ? and sector = ?',
        whereArgs: [id, sector]);
    print(especiesMap.length);
    if (especiesMap.length == 0) {
      return false;
    } else {
      return true;
    }
  }

  //-------------------------------Acceso-------------------------------------
  static Future<bool> valida_existencia_pass() async {
    Database database = await _openDB();
    final List<Map<String, dynamic>> passMap =
        await database.query('Tabla_accedder');
    print("Datos de acceso: " + passMap.length.toString());
    if (passMap.length == 0) {
      //No se ha declarado una contraseña
      return false;
    } else {
      //Se ha declarado una contraseña
      return true;
    }
  }

  static Future crea_datos_acceso(
      int tipo_pregunta, String ans_pregunta, String pass) async {
    Database database = await _openDB();
    ans_pregunta = "'" + ans_pregunta + "'";
    pass = "'" + pass + "'";
    String comando =
        'insert into Tabla_accedder values (1,$tipo_pregunta, $ans_pregunta, $pass)';
    database.rawQuery(comando);
  }

  static Future edita_datos_acceso(
      int tipo_pregunta, String ans_pregunta, String pass) async {
    Database database = await _openDB();
    ans_pregunta = "'" + ans_pregunta + "'";
    pass = "'" + pass + "'";
    String comando =
        'update Tabla_accedder set tip_pregunta=$tipo_pregunta, ans_pregunta=$ans_pregunta, my_pass=$pass where id_acceso=1';
    database.rawQuery(comando);
  }

  static Future<List<Acceso>> select_all_accesos() async {
    Database database = await _openDB();
    final List<Map<String, dynamic>> accesosMap =
        await database.query("Tabla_accedder");
    for (var n in accesosMap) {
      print("Accesos --> " +
          n['id_acceso'].toString() +
          ", " +
          n['tip_pregunta'].toString() +
          ", " +
          n['ans_pregunta'] +
          ", " +
          n['my_pass']);
    }
    return List.generate(
        accesosMap.length,
        (i) => Acceso(
            tipo_pregunta: accesosMap[i]['tip_pregunta'],
            ans_pregunta: accesosMap[i]['ans_pregunta'],
            pass: accesosMap[i]['my_pass']));
  }

  //---------------------------------Gráfica--------------------------------
  // Insertar nueva especie
  static Future<int> inserta_nuevo_chart(Data_Chart dch) async {
    Database database = await _openDB();
    return database.insert('Tabla_Datos_Grafica', dch.toMap());
  }

  //Borra especie
  static Future<int> borrar_charts() async {
    Database database = await _openDB();
    return database.delete('Tabla_Datos_Grafica',
        where: 'tipo_dato_dg != ?', whereArgs: [7]);
  }

  // select * from esecies
  static Future<List<Data_Chart>> select_day_charts() async {
    Database database = await _openDB();
    final List<Map<String, dynamic>> chartsMap =
        await database.query("Tabla_Datos_Grafica");
    for (var n in chartsMap) {
      print("Charts --> " +
          n['fecha_dg'] +
          ", " +
          n['id_sector_dg'].toString() +
          ", " +
          n['tipo_dato_dg'].toString() +
          ", " +
          n['valor_dg'].toString());
    }
    return List.generate(
        chartsMap.length,
        (i) => Data_Chart(
            fecha: chartsMap[i]['fecha_dg'],
            identificador_sector: chartsMap[i]['id_sector_dg'],
            tipo_dato: chartsMap[i]['tipo_dato_dg'],
            valor: chartsMap[i]['valor_dg']));
  }
}
