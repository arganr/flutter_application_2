import 'package:flutter/material.dart';
import 'package:flutter_application_2/controller/home_controller.dart';
import 'package:flutter_application_2/custom_widget/flutter_analog_clock.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    controller.getViewDataDB();
    return Scaffold(
        appBar: AppBar(
          title: Text("Alarm Clock"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.all(20),
              child: GestureDetector(
                onHorizontalDragStart: (details) {},
                onHorizontalDragUpdate: (details) {
                  controller.updateTimeByMinutes(details.delta.dx);
                  controller.update();
                },
                onVerticalDragStart: (details) {},
                onVerticalDragUpdate: (details) {
                  controller.updateTimeByHour(details.delta.dy);
                  controller.update();
                },
                child: Obx(() => FlutterAnalogClock(
                      dateTime: controller.timeClock.value,
                      isLive: false,
                      width: 200.0,
                      height: 200.0,
                      showSecondHand: false,
                      decoration: const BoxDecoration(),
                    )),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Obx(() => Text(controller.timeString.value.toString())),
            ),
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () async {
                  // controller.scheduleAlarm();
                  // controller.clearAlarm();
                  await controller.insertDB();
                  // await controller.getViewDataDB();
                },
                child: Text('Set Alarm'),
              ),
            ),
            Obx(() => Container(
                  height: 100,
                  padding: EdgeInsets.all(10),
                  child: controller.timeList == null
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.timeList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              child: Card(
                                color: Colors.blue,
                                margin: EdgeInsets.all(5),
                                elevation: 5,
                                child: Container(
                                  width: 100,
                                  child: Center(
                                      child: Text(
                                    controller.timeString.value,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )),
                                ),
                              ),
                            );
                          },
                        ),
                )),
            Container(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  controller.clearAlarm();
                },
                child: Text('Clear All Alarm'),
              ),
            ),
          ],
        ));
  }
}
