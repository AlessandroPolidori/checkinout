import 'package:checkinout/Screens/SearchGame.dart';
import 'package:checkinout/Utils/alarmTile.dart';
import 'package:checkinout/Utils/fileManager.dart';
import 'package:checkinout/Utils/httpManager.dart';
import 'package:flutter/material.dart';

//test commit

class SearchStreamer extends StatefulWidget {
  SearchStreamer({Key? key, required this.alarmsList}) : super(key: key);

  List<AlarmTile> alarmsList;
  @override
  _SearchStreamerState createState() => _SearchStreamerState();
}

class _SearchStreamerState extends State<SearchStreamer> {

  List _streamers = [];

  TextEditingController text1Ctrl = TextEditingController()..text = 'Search a streamer...';

  void _updateStreamers(String search) {
    httpMngr.searchStreamer(search).then((streamers) => setState(() {
          _streamers = streamers;
        }));
  }
  void _selectStreamer(String name){

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SearchGame(alarmsList: widget.alarmsList, streamerName : name)))
        .then((value) {
      Navigator.pop(context);
    });

  }

  @override
  void dispose() {
    text1Ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        body: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: TextField(
                    onChanged: _updateStreamers,
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(0, 15, 0, -20)),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    maxLines: 3,
                    controller: text1Ctrl,
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    text1Ctrl.clear();
                  },
                  child: const Text(
                    'CLEAR',
                    style: TextStyle(color: Colors.purple),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _streamers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () {
                        _selectStreamer(_streamers[index]['display_name']);
                        } ,
                      contentPadding: const EdgeInsets.all(10.0),
                      title: Text(_streamers[index]['display_name'],
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white)),
                      trailing: Image.network(
                        _streamers[index]['thumbnail_url'],
                        fit: BoxFit.cover,
                        height: 100.0,
                        width: 100.0,
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
