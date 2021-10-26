import 'package:checkinout/Utils/httpManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings? androidInitializationSettings;

  InitializationSettings? initializationSettings;
  static BuildContext? context;

  String notificationBody = "";

  NotificationHelper() {
    initializedNotification();
  }

  initializedNotification() async {
    androidInitializationSettings = AndroidInitializationSettings('app_icon');

    initializationSettings =
        InitializationSettings(android: androidInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings!);
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payLoad) async {
    await showDialog(
        context: context!,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(body),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text('OKay'),
                  onPressed: () {
                    // do something here
                  },
                )
              ],
            ));
  }

  Future<void> showNotificationBtweenInterval() async {

    var now = DateTime.now();
    var currentTime =
        DateTime(now.year, now.month, now.day, now.hour, now.minute);

    print(currentTime);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel_Id',
      'Channel Name',
      'Channel Description',
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
      enableLights: true,
      ticker: 'test ticker',
      playSound: true,
    );

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    List<fetchedObject> fetchedList = await httpMngr.fetchAll();

    notificationBody = "";
    for (fetchedObject fetched in fetchedList){

        if(fetched.alarm.game == fetched.gameId || fetched.alarm.game == "any"){
          notificationBody = notificationBody + "streamer: "+fetched.streamerName+", game: "+fetched.gameId + "...";
        };
    }
    if(notificationBody != ""){
      await flutterLocalNotificationsPlugin.show(
          0, "A stream you are interested in is live!", notificationBody , notificationDetails);
    }


  }

}
