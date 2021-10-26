import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';

import 'alarmTile.dart';

abstract class FileManager {

  static Future<String> get _localPath async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get _localFile async {
    final path = await _localPath;
    return File(join(path, "data.txt"));
  }

  //TODO: check if data exists already
  static Future<bool> save(String data) async {
    File file = await _localFile;
    file.writeAsString('${data}\n', mode: FileMode.append);
    return true;
  }

  static Future<bool> clear() async {
    File file = await _localFile;
    file.writeAsString("");
    return true;
  }

  static Future<String> load() async {
    File file = await _localFile;
    return file.readAsString();
  }

  //delete a string from file
  static Future<bool> delete(String streamerName, String game) async{
    File file = await _localFile;
    String fileString = await file.readAsString();
    List<String> list;

    list = fileString.split("\n");
    //TODO: adding startingFrom, now is always "any"
    list.remove(streamerName +"/"+ game +"/any");

    await clear();

    for (String s in list){
        await save(s);
    }
    //ritorna stringa risultante
    return true;
  }

  static Future<List<AlarmTile>> getList() async{
    //costruisci lista con stringhe del file e restituiscila
    File file = await _localFile;
    String fileString = await file.readAsString();
    List<String> list;
    List<AlarmTile> returnList = [];
    List<String> line;
    list = fileString.split("\n");


    for (String s in list){
      if (s != ""){
        line = s.split("/");
        returnList.add(AlarmTile(line[0],line[1],line[2]));
      }
    }
    return returnList;

    }


}