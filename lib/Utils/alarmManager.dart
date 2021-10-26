import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:checkinout/Notification/notificationHelper.dart';

class alarmMngr{

  static bool _alarmSet=false;


  alarmMngr(){}

  static periodicCallback() {
    NotificationHelper().showNotificationBtweenInterval();
  }

  static setAlarm(int id) async {
    _alarmSet = true;
    print("entered in setAlarm()");
    await AndroidAlarmManager.periodic(Duration(seconds: 5), id, periodicCallback);
  }

  static resetAlarm(int id) async {
    _alarmSet = false;
    await AndroidAlarmManager.cancel(id);
  }

  static bool getAlarmSet(){return _alarmSet;}

}