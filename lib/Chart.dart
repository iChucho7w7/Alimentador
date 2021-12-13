import 'package:fl_animated_linechart/fl_animated_linechart.dart';
import 'package:fl_animated_linechart/chart/area_line_chart.dart';
import 'package:alimentador/DB/db_ConectaDB.dart';
import 'package:alimentador/Models/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:alimentador/b_General.dart';
import 'package:alimentador/loader_widget.dart';

class ChartWidget extends StatefulWidget {
  //const ChartWidget({required Key key}) : super(key: key);

  @override
  _ChartWidgetState createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  bool show_chart = false;
  bool show_chart2 = false;
  LineChart chart = LineChart.fromDateTimeMaps([], [], []);

  Future<Map<DateTime, double>> create_line_temp() async {
    List<Data_Chart> data_chart = await Create_DB.select_day_charts();
    if (data_chart.length >= 2) {
      show_chart2 = true;
    }
    print("Datos de gráfica: " + data_chart.length.toString());
    final Map<DateTime, double> data_temp = {};
    for (int i = 0; i < data_chart.length; i++) {
      if (data_chart[i].tipo_dato == 1) {
        DateTime fecha_hoy = DateTime.parse(data_chart[i].fecha);
        print(i.toString() + ": " + fecha_hoy.toString());
        data_temp[fecha_hoy] = data_chart[i].valor.toDouble();
      }
    }

    return data_temp;
  }

  Future espera_init() async {
    Map<DateTime, double> line1 = await create_line_temp();
    setState(() {
      chart = LineChart.fromDateTimeMaps([
        line1,
      ], [
        Colors.orange,
      ], [
        'gramos',
      ], tapTextFontWeight: FontWeight.w400);
      show_chart = true;
    });
  }

  initState() {
    espera_init();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(
            height: 20,
          ),
          show_chart == true && show_chart2 == true
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AnimatedLineChart(
                      chart,
                      key: UniqueKey(),
                    ), //Unique key to force animations
                  ),
                )
              : Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(bottom: 0),
                        child: Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Center(
                            child: LoaderWidget(),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(bottom: 120),
                        child: Text(
                          "Esperando datos...",
                          style: TextStyle(
                            color: Color(0xFF880E4F),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
