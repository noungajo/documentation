import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:path_provider/path_provider.dart' as p;
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'education/education_style.dart';
import 'new_client/apiclient.dart';
import 'package:pick_or_save/pick_or_save.dart';

// ignore: must_be_immutable
class DownloadStore extends StatefulWidget {
  DownloadStore(this.urlPdf, this.fileName, {Key? key}) : super(key: key);

  String urlPdf = "";
  String fileName = "";
  @override
  State<DownloadStore> createState() => _DownloadStoreState();
}

class _DownloadStoreState extends State<DownloadStore> {
  Dio dio = Dio();
  /*
fonction pour récupérer l'emplacement où sera sauvegarder le fichier télécharger
  */
  Future<List<Directory>?> _getExternalStorage() {
    //pour la musique on met juste dans musique

    var chemin = p.getExternalStorageDirectories();
    return chemin;
  }

  /*
  fonction pour telecharger et sauvegarder le fichier pdf
  urlPath: le lien du fichier à télécharger
  */
  Future _downloadAndStoreFile(
      BuildContext context, String urlPath, String fileName) async {
    ProgressDialog pr = ProgressDialog(context: context);

    try {
      //=====Show dialog ======
      pr.show(
        max: 100,
        msg: "msgTelechargement".tr,
        msgFontWeight: FontWeight.normal,
        progressBgColor: Colors.transparent,
        cancel: Cancel(
          cancelClicked: () {
            /// ex: cancel the download
          },
        ),
      );

      final dirList = await _getExternalStorage();
      // var dir = await p.getTemporaryDirectory();
      final path = dirList![0].path; // où sera sauvegardé l'item
      final file = File('$path/$fileName');
      await dio.download(
        urlPath,
        file.path,
        onReceiveProgress: (count, total) {
          setState(() {
            // ===== update dialog ==============
            int val = ((count / total) * 100).toInt();
            pr.update(value: val);
          });
        },
      );
      await PickOrSave().fileSaver(
          params: FileSaverParams(
        saveFiles: [
          SaveFileInfo(filePath: '$path/$fileName', fileName: fileName)
        ],
      ));
      //==== hide dialog=======
      pr.close();
      // print(file.path);
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final _url = "${ClientNewService.url}${widget.urlPdf}";
        _downloadAndStoreFile(context, _url, widget.fileName);
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.width * 0.1,
        child: Row(
          children: [
            Icon(
              Icons.downloading_rounded,
              color: const Color(0xffe8122a),
              size: MediaQuery.of(context).size.width * 0.06,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.01,
            ),
            Text(
              "text_telecharger".tr,
              style: itemdatestyle,
            )
          ],
        ),
      ),
    );
  }
}
