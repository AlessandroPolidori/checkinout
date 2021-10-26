import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:checkinout/Utils/alarmTile.dart';

import 'fileManager.dart';

class fetchedObject{
  String streamerName;
  String gameId;
  AlarmTile alarm;
  String thumbnail_url;


  fetchedObject(this.streamerName, this.gameId,this.thumbnail_url, this.alarm );

}

class httpMngr {


  static fetchedObject fromJson(Map<String,dynamic> decoded, alarm){


     if (decoded["data"].length == 0){
       //decoded["data"].length == 0  if the streamer is not live
       return new fetchedObject("", "", "",AlarmTile("","",""));

     }else{
       return new fetchedObject(decoded["data"][0]["user_login"], decoded["data"][0]["game_name"],decoded["data"][0]["thumbnail_url"], alarm);
     }

  }

  static Future<List<fetchedObject>> fetchAll() async{

    List<fetchedObject> fetchedList = [];
    fetchedObject f;
    //remember: every line in file should be of type streamerName/gameName/startingFrom(hour)

    String fileLines = await FileManager.load();
    List<String> alarmsList = [];

    alarmsList = fileLines.split("\n");
    for(String s in alarmsList){
      bool exists = false;
      if(s != ""){

        f = await fetchNameAndGame(s);
        for (fetchedObject f in fetchedList){

          if (f.streamerName == s.split("/")[0] || f.streamerName == s.split("/")[0].toLowerCase()){
            exists = true;
          }
        }
        if(!exists){fetchedList.add(f);}

      }
    }

    return fetchedList;
  }

  static Future<fetchedObject> fetchNameAndGame(String s) async {

    // remember, s should be formatted like this: streamerName/gameName/startingFrom
    // eventually, gameName and startingFrom could be "any"

    List<String> l = s.split("/");
    String streamerName = l[0];
    String gameName = l[1];
    String startingFrom = l[2];

    final response = await http.get(
      Uri.parse(
          'https://api.twitch.tv/helix/streams?user_login='+streamerName),
      // Send authorization headers to the backend.
      headers: {
        'Client-ID': 'nws0u69w2naslzzyca3f1xqu0dzhks',
        'Authorization': 'Bearer ' + 'ppwraeushy6ec31d4diffwpr75yd9j',
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print('200 OK!!!!!!!!!');

      var decoded = jsonDecode(response.body);
      //print(decoded);
      //fetchedObject test = fromJson(decoded);

      return fromJson(decoded, AlarmTile(streamerName,gameName,startingFrom));


    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      print('NO RESPONSE :(((((');
      throw Exception('Failed to load');
    }
  }

  static searchStreamer(String text) async {

    if (text == "") {
      return [];
    }

    var response = await http.get(
      Uri.parse(
          'https://api.twitch.tv/helix/search/channels?query='+text),
      // Send authorization headers to the backend.
      headers: {
        'Client-ID': 'nws0u69w2naslzzyca3f1xqu0dzhks',
        'Authorization': 'Bearer ' + 'ppwraeushy6ec31d4diffwpr75yd9j',
      },
    );
    final responseJson = json.decode(response.body);


    if (responseJson['data'] != null) {
      return responseJson['data'].toList();
    }

    return [];
  }

  static searchGame(String text) async {

    if (text == "") {
      return [];
    }

    var response = await http.get(
      Uri.parse(
          'https://api.twitch.tv/helix/search/categories?query='+text),
      // Send authorization headers to the backend.
      headers: {
        'Client-ID': 'nws0u69w2naslzzyca3f1xqu0dzhks',
        'Authorization': 'Bearer ' + 'ppwraeushy6ec31d4diffwpr75yd9j',
      },
    );
    final responseJson = json.decode(response.body);


    if (responseJson['data'] != null) {
      return responseJson['data'].toList();
    }

    return [];
  }

}
