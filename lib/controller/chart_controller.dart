import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_2/service/alarm_helper.dart';
import 'package:get/get.dart';

class ChartController extends GetxController {
  // var id_notif = ''.obs;
  var chartList = <FlSpot>[].obs;

  AlarmHelper almHelper = AlarmHelper();

  @override
  void onInit() {
    almHelper.initializeDatabase();
    super.onInit();
  }
}
