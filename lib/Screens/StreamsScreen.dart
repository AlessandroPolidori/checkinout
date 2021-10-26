import 'dart:ui';

import 'package:checkinout/Utils/streamTile.dart';
import 'package:checkinout/Utils/fileManager.dart';
import 'package:checkinout/Utils/httpManager.dart';
import 'package:flutter/material.dart';

class StreamsScreen extends StatefulWidget {
  StreamsScreen({Key? key}) : super(key: key);



  @override
  _StreamsScreenState createState() => _StreamsScreenState();
}

class _StreamsScreenState extends State<StreamsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_){
      initList();
    });

  }

  void initList() async{
    //fai http req con gli elementi di items
    List<fetchedObject> fetchedList = await httpMngr.fetchAll();
    if(fetchedList.length > 0){
      for(fetchedObject f in fetchedList){
          //if streamer is not live, fetched object has all empty attributes
          if (f.streamerName != "") {
            show.add(StreamTile(f.streamerName, f.gameId , f.thumbnail_url,""));
          }
      }
    }

    setState(() {

    });
  }

  List<StreamTile> show = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,

      appBar: AppBar(
        toolbarHeight: 45,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: show.length,
              itemBuilder: (context, index) {
                final item = show[index];

                  return Container(
                    height: 130,
                    margin: EdgeInsets.all(14),
                    child: Stack(
                      children: [

                        Positioned.fill(

                            child:ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(item.thumbnail_url.split("{")[0]+"640x360.jpg",
                              fit: BoxFit.cover,
                              ),
                            ),
                          ),

                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height:130,
                            decoration: BoxDecoration(

                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                  Colors.black.withOpacity(0.3),
                                  Colors.transparent
                                ]),
                          ),
                        ),
                      ),
                      Container(
                        child: Text(
                          item.streamerName + " playing: " + item.game,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                            shadows: [
                              Shadow(
                                blurRadius: 18.0,
                                color: Colors.black87,
                                offset: Offset(1.0, 1.0),
                              ),
                            ],
                          ),
                        ),
                        alignment: Alignment.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
