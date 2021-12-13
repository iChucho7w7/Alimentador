// Calses que definirán el modelo por elcual se rige la transacción de datos

import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:alimentador/b_General.dart';

class Especies {
  String identificador;
  String nombre;
  double temp_max;
  double temp_req;
  double temp_min;
  double hum_req;
  int freq_reg_dias;
  int freq_reg_hrs;
  int freq_reg_min;
  double litros_regado;
  String caracteristicas;
  int tipo_especie;
  int tipo_sector;
  Uint8List foto_especie;
  Especies({
    this.identificador = "",
    this.nombre = "",
    this.temp_max = 0,
    this.temp_req = 0,
    this.temp_min = 0,
    this.hum_req = 0,
    this.freq_reg_dias = 0,
    this.freq_reg_hrs = 0,
    this.freq_reg_min = 0,
    this.litros_regado = 0,
    this.caracteristicas = "",
    this.tipo_especie = 0,
    this.tipo_sector = 0,
    required this.foto_especie,
  });

  Map<String, dynamic> toMap() {
    return {
      'identificador_especie': identificador,
      'nombre_especie': nombre,
      'temperatura_max': temp_max,
      'temperatura_requerida': temp_req,
      'temperatura_min': temp_min,
      'humedad_requerida': hum_req,
      'frecuencia_dias_regado': freq_reg_dias,
      'frecuencia_hrs_regado': freq_reg_hrs,
      'frecuencia_min_regado': freq_reg_min,
      'litros_x_regado': litros_regado,
      'descripcion_especie': caracteristicas,
      'tipo_especie': tipo_especie,
      'sector': tipo_sector,
      'foto_especie': foto_especie
    };
  }
}

class Alarmas {
  String identificador_alarma;
  String identificador_especie;
  String nombre_especie;
  int tipo_alarma;
  int tipo_ref;
  double valor_alarma;
  String descripcion_alarma;

  Alarmas(
      {this.identificador_alarma = '',
      this.identificador_especie = '',
      this.nombre_especie = '',
      this.tipo_alarma = 0,
      this.tipo_ref = 0,
      this.valor_alarma = 0,
      this.descripcion_alarma = ''});
  Map<String, dynamic> toMap() {
    return {
      'id_alarma': identificador_alarma,
      'id_especie_alarma': identificador_especie,
      'nombre_especie_alarma': nombre_especie,
      'tipo_alarma': tipo_alarma,
      'tipo_referencia': tipo_ref,
      'valor_alarma': valor_alarma,
      'descripcion_alarma': descripcion_alarma
    };
  }
}

class Acceso {
  int tipo_pregunta;
  String ans_pregunta;
  String pass;

  Acceso({
    this.tipo_pregunta = 0,
    this.ans_pregunta = "",
    this.pass = "",
  });

  Map<String, dynamic> toMap() {
    return {
      'tip_pregunta': tipo_pregunta,
      'ans_pregunta': ans_pregunta,
      'my_pass': pass,
    };
  }
}

class Data_Chart {
  String fecha;
  int identificador_sector = 0;
  int tipo_dato = 0;
  double valor = 0.0;
  Data_Chart(
      {required this.fecha,
      this.identificador_sector = 0,
      this.tipo_dato = 0,
      this.valor = 0.0});

  Map<String, dynamic> toMap() {
    return {
      'fecha_dg': fecha,
      'id_sector_dg': identificador_sector,
      'tipo_dato_dg': tipo_dato,
      'valor_dg': valor
    };
  }
}
