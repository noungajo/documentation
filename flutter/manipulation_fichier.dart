import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Storage {
  //====  utiliser l'approche des fichiers pour déterminer si le user s'est déjà connecté ou pas ===============
// find the correct local apath
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

//create a reference to the file location : to acheive file
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/user_data.txt');
  }

// write data to the file
  Future<File> writeUserInfos(String userData) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(userData);
  }

//read data from the file
  Future<String> readUserInfos() async {
    try {
      final file = await _localFile;

      // Read the file
      final contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return "echec";
    }
  }

/*
 check if file exist
*/
  Future<bool> existFile() async {
    File file = await _localFile;
    final test = await file.exists();
    return test;
  }
}
