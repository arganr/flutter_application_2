import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_application_2/main.dart';
import 'package:flutter_application_2/model/alarm_model.dart';
import 'package:flutter_application_2/service/alarm_helper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var timeAjust = ''.obs;
  var timeClock = DateTime.now().obs;
  var timeString = ''.obs;
  var timeList = <AlarmModel>[].obs;
  var chartList = <FlSpot>[].obs;

  AlarmHelper almHelper = AlarmHelper();

  @override
  void onInit() {
    setTime(timeClock.value);
    almHelper.initializeDatabase();
    // updateInactiveAlarm();
    super.onInit();
  }

  void setTime(DateTime val) {
    var intHour = val.hour;
    var intMinute = val.minute;
    timeString.value = addLeadZero(intHour) + ':' + addLeadZero(intMinute);
    update();
  }

  void updateTimeByMinutes(double val) {
    var dtClock = timeClock.value;
    timeClock.value = dtClock.add(Duration(minutes: val.round()));
    setTime(timeClock.value);
    update();
  }

  void updateTimeByHour(double val) {
    var dtClock = timeClock.value;
    timeClock.value = dtClock.add(Duration(hours: val.round()));
    setTime(timeClock.value);
    update();
  }

  scheduleAlarm(int id, DateTime scDate) async {
    // var scheduleDateTime = DateTime.now().add(Duration(seconds: 5));
    var dtNow = DateTime.now();
    var scheduleDateTime = new DateTime(
        dtNow.year, dtNow.month, dtNow.day, scDate.hour, scDate.minute, 0, 0);

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'alarm_notif_new', 'alarm_notif_new',
        channelDescription: 'Channel for Alarm notification',
        icon: 'innocent',
        playSound: true,
        importance: Importance.max,
        priority: Priority.high,
        sound: RawResourceAndroidNotificationSound('old_telephone'));

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: 'old_telephone.mp3',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(id, 'Alarm',
        'this is your alarm', scheduleDateTime, platformChannelSpecifics,
        payload: id.toString(), androidAllowWhileIdle: true);
  }

  insertDB() async {
    // var randomID = new Random();
    // var getMaxID = await almHelper.maxId();
    var dtNow = DateTime.now();
    var scheduleDateTime = new DateTime(dtNow.year, dtNow.month, dtNow.day,
        timeClock.value.hour, timeClock.value.minute, 0, 0);

    var almModel = new AlarmModel();
    almModel.id = await almHelper.maxId();
    almModel.dateSet = scheduleDateTime;
    almModel.secondDiff = 0;
    almModel.isActive = 1;

    await almHelper.newAlarm(almModel);
    await scheduleAlarm(almModel.id, scheduleDateTime);
    await getViewDataDB();
    update();
  }

  getViewDataDB() async {
    try {
      timeList.value = await almHelper.getAlarm();
      update();
    } catch (err) {}
  }

  void clearAlarm() async {
    try {
      await almHelper.deleteAllAlarm();
      await flutterLocalNotificationsPlugin.cancelAll();
      getViewDataDB();
      update();
    } catch (err) {}
  }

  String addLeadZero(int num) {
    String retNum = num.toString();
    if (num < 10) {
      retNum = "0" + num.toString();
    }
    return retNum;
  }

  void updateInactiveAlarm() async {
    almHelper.updateInactiveAlarm();
    update();
  }

  void getChartDataDB() async {
    try {
      // List<AlarmModel> dtAlarm = new List<AlarmModel>();
      var dtAlarm = <AlarmModel>[];
      dtAlarm = await almHelper.getAlarmDone();
      chartList.clear();
      for (var i = 0; i < dtAlarm.length; i++) {
        var x = double.parse(dtAlarm[i].id.toString());
        var y = double.parse(dtAlarm[i].secondDiff.toString());
        chartList.add(FlSpot(x, y));
      }
      update();
    } catch (err) {
      print(err.toString());
    }
  }

  void updateNotifAlarm(String id) async {
    try {
      var almModel = await almHelper.getAlarmById(int.parse(id));
      almModel.dateUp = DateTime.now();
      // var scDiff = Random();
      // almModel.secondDiff = scDiff.nextInt(10);

      var scDiff = getSeccondDiffDate(almModel.dateSet);
      almModel.secondDiff = scDiff;
      almModel.isActive = 0;

      almHelper.updateAlarm(almModel);

      getViewDataDB();
      getChartDataDB();
      update();
    } catch (err) {
      print(err.toString());
    }
  }

  int getSeccondDiffDate(DateTime dtval) {
    final dtNow = DateTime.now();
    final seccDiff = dtNow.difference(dtval).inSeconds;

    return seccDiff;
  }
}
