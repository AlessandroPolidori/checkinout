import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:checkinout/Utils/alarmManager.dart';
import 'package:checkinout/Utils/alarmTile.dart';
import 'package:checkinout/Utils/fileManager.dart';
import 'package:flutter/material.dart';


class CustomizedNotification extends StatefulWidget {

  CustomizedNotification({Key? key, required this.list }) : super(key: key);

  List<AlarmTile> list;

  @override
  _CustomizedNotificationState createState() => _CustomizedNotificationState();
}


class _CustomizedNotificationState extends State<CustomizedNotification> {
  TextEditingController text1Ctrl = TextEditingController();
  TextEditingController text2Ctrl = TextEditingController();
  TextEditingController text3Ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    text1Ctrl.dispose();
    text2Ctrl.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,

        appBar: AppBar(
            backgroundColor: Colors.black87,
            toolbarHeight: 45,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),

                onPressed: () => Navigator.of(context).pop(),
              ),
            ]
          ),

        body: Container(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(

                  children: <Widget>[
                    Flexible(
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        maxLines: 3,
                        controller: text1Ctrl,
                      ),
                    ),
                    FlatButton(
                      color: Colors.grey,
                      child: Text("Save"),
                      onPressed: () {

                        FileManager.save(text1Ctrl.text.split("\n")[0]).then((result) {
                          if (result)
                            print("File salvato");
                          else
                            print("Errore salvataggio file");
                        });

                        widget.list.add(AlarmTile(text1Ctrl.text.split("/")[0],
                            text1Ctrl.text.split("/")[1],text1Ctrl.text.split("/")[2]));

                      },
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        maxLines: 3,
                        controller: text2Ctrl,
                        readOnly: true,
                      ),
                    ),
                    FlatButton(
                      color: Colors.grey,
                      child: Text("Load"),
                      onPressed: () {

                        FileManager.load().then((data) {
                          text2Ctrl.text = data;
                          print("File caricato");
                          print(data);
                        });

                      },
                    ),
                  ],
                ),

              ],
            ),
          ),

      ),
    );
  }
}
