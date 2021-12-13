class FakeChartSeries {
  Map<DateTime, double> create_charge_line() {
    Map<DateTime, double> aux_charge_line = {};
    aux_charge_line[DateTime.now().subtract(Duration(minutes: 40))] = 0.0;
    aux_charge_line[DateTime.now().subtract(Duration(minutes: 0))] = 0.0;
    return aux_charge_line;
  }
}
