import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/controller/home_controller.dart';
import 'package:get/get.dart';

class NotificationPage extends StatelessWidget {
  final String payload;
  final controller = Get.find<HomeController>();
  NotificationPage({this.payload});

  @override
  Widget build(BuildContext context) {
    controller.updateNotifAlarm(payload);
    // controller.getChartDataDB();
    return Scaffold(
        appBar: AppBar(
          title: Text("Notification Page"),
          centerTitle: true,
        ),
        body: Obx(() => Container(
              margin: EdgeInsets.all(20),
              padding: EdgeInsets.all(10),
              width: double.infinity,
              child: controller.chartList.length == 0
                  ? Container(child: Center(child: Text('Data is Empty')))
                  : LineChart(
                      LineChartData(
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                                spots: controller.chartList, isCurved: true)
                          ]),
                    ),
            )));
  }
}
