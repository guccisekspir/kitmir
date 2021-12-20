import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kitmir/models/doge.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseApiClient {
  Future<List<Doge>> getfromDisk() async {
    final directory = await getApplicationDocumentsDirectory();
    List<Doge> diskDoge = [];

    var localPath = directory.path;
    final path = localPath;
    File file = File('$path/doges.txt');

    //await file.writeAsString(jsonEncode(list));

    //File file2 = File('$path/doges.txt');
    if (await file.exists()) {
      List diskString = jsonDecode(await file.readAsString());

      diskString.forEach((element) {
        diskDoge.add(Doge.fromMap(jsonDecode(element)));
      });
    }

    return diskDoge;
  }

  writeToDisk(List<Doge> list) async {
    final directory = await getApplicationDocumentsDirectory();
    List<Doge> diskDoge = [];

    var localPath = directory.path;
    final path = localPath;
    File file = File('$path/doges.txt');

    await file.writeAsString(jsonEncode(list));

    File file2 = File('$path/doges.txt');
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<List<Doge>> getDoges() async {
    List<Doge> dogeList = [];

    dogeList = await getfromDisk();

    if (dogeList.isNotEmpty) {
      log("Diskten okundu aga");
      return dogeList;
    } else {
      log("diskte yok aga");

      QuerySnapshot snapshot = await firestore.collection("doges").get();

      List<Map> anan = [];

      for (var element in snapshot.docs) {
        if (element.exists) {
          log("element exits");
          dogeList.add(Doge.fromMap(element.data() as Map<String, dynamic>));
          anan.add(element.data() as Map<String, dynamic>);
        }
      }

      Set<String> diseases = {};

      dogeList.forEach((element) {
        element.health!.major!.forEach((element2) {
          String newString = "";
          if (element2.isNotEmpty) {
            if (element2[0] == ' ') {
              newString = element2.substring(1);
            } else {
              newString = element2;
            }
          }
          diseases.add(newString.trim());
        });
      });

      log(diseases.toString());

      writeToDisk(dogeList);

      return dogeList;
    }
  }
}
