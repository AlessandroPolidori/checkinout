import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import 'package:checkinout/Screens/StreamsScreen.dart';
import 'package:checkinout/Utils/alarmTile.dart';
import 'package:checkinout/Utils/alarmManager.dart';
import 'package:checkinout/Utils/fileManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:checkinout/Screens/SearchStreamer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

final ButtonStyle buttonStyle = ElevatedButton.styleFrom(
  textStyle: const TextStyle(fontSize: 20),
  primary: Colors.purpleAccent.shade400,
  padding: EdgeInsets.all(16),
);

class _HomeState extends State<Home> {


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      initList();
    });
  }

  List<AlarmTile> items = [];

  void initList() async {

    items = await FileManager.getList();
    setState(() {});
  }

  void _onItemTapped(int index) {

    if(index == 0){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SearchStreamer(alarmsList: items)))
          .then((value) {
        setState(() {});
      });
    }else if(index == 2){
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => StreamsScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        backgroundColor: Colors.black87,

        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black87,
          currentIndex: 1,
          selectedItemColor: Colors.purpleAccent,
          unselectedItemColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.alarm_add_rounded),
              label: "add_alarm",

            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.alarm_outlined),
              label: "alarms",

            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.live_tv_rounded),
              label: "streams",

            ),
          ],
        ),

        

        body: Padding(
          padding: EdgeInsets.only(top:20.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Container(

                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: Colors.grey.shade700)),
                      ),

                      child: Dismissible(
                        // Each Dismissible must contain a Key. Keys allow Flutter to
                        // uniquely identify widgets.
                        key: Key(item.streamerName + item.game),
                        // Provide a function that tells the app
                        // what to do after an item has been swiped away.
                        onDismissed: (direction) {
                          FileManager.delete(item.streamerName, item.game);
                          // Remove the item from the data source.
                          setState(() {
                            items.removeAt(index);
                          });

                          // Then show a snackbar.
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('alarm dismissed')));
                        },
                        // Show a red background as the item is swiped away.
                        background: Container(
                          color: Colors.red,
                          margin: EdgeInsets.fromLTRB(0, 1.5, 0, 1.3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      left: BorderSide(width: 2.0, color: Colors.white),
                                    ),
                                  ),
                                  child: Text(
                                    "  Dismiss",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,

                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),

                          child: ListTile(

                            tileColor: Colors.black87,
                            title: Text(
                              item.streamerName + " playing: " + item.game,
                              style: TextStyle(
                                color: Colors.orangeAccent.shade400,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,

                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom:10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                  children: [
                    ElevatedButton(
                      style: buttonStyle,
                      onPressed: () async {

                        WidgetsFlutterBinding.ensureInitialized();
                        await AndroidAlarmManager.initialize();
                        alarmMngr.setAlarm(0);

                      },
                      child: Text(
                        "Set Alarms",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    ElevatedButton(
                      style: buttonStyle,
                      onPressed: () async {
                        if (alarmMngr.getAlarmSet()) {
                          alarmMngr.resetAlarm(0);
                          print('alarm reset');
                        } else {}
                      },
                      child: Text(
                        "Reset Alarms",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
