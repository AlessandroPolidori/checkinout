import 'package:checkinout/Utils/alarmTile.dart';
import 'package:checkinout/Utils/fileManager.dart';
import 'package:checkinout/Utils/httpManager.dart';
import 'package:flutter/material.dart';

//test commit

class SearchGame extends StatefulWidget {
  SearchGame({Key? key, required this.alarmsList, required this.streamerName}) : super(key: key);

  String streamerName;
  List<AlarmTile> alarmsList;
  @override
  _SearchGameState createState() => _SearchGameState();
}

class _SearchGameState extends State<SearchGame> {
  List _games = [];

  TextEditingController text1Ctrl = TextEditingController()..text = 'Search a game...';

  void _updateGames(String search) {
    httpMngr.searchGame(search).then((games) => setState(() {
      _games = games;
    }));
  }
  void _selectGame(String gameName){

    FileManager.save(widget.streamerName+"/"+gameName+"/any").then((result) {
      if (result)
        print("File salvato");
      else
        print("Errore salvataggio file");
    });

    widget.alarmsList.add(AlarmTile(widget.streamerName, gameName, "any"));
    Navigator.pop(context);

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
                    onChanged: _updateGames,
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
            Container(
              alignment: AlignmentDirectional.centerStart,


                  child: ElevatedButton(
                      child: Text(
                        "Any game",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                      onPressed: () {
                        _selectGame("any");
                      }),


            ),
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _games.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () {
                        _selectGame(_games[index]['name']);
                      } ,
                      contentPadding: const EdgeInsets.all(10.0),
                      title: Text(_games[index]['name'],
                          style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white)),
                      trailing: Image.network(
                        _games[index]['box_art_url'],
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
