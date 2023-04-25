import 'package:flutter/material.dart';

import '../../../texte_interface/login_text.dart';

// ignore: must_be_immutable
class DeleteDialog extends StatelessWidget {
  DeleteDialog(Function deconnectedFunction, Widget showText) {
    this.deconnectedFunction = deconnectedFunction;
    this.showText = showText;
  }
  late Function deconnectedFunction;
  late Widget showText;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Se déconnecter'),
          content: const Text('Voulez-vous vraiment vous déconnecter ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, textAnnuler),
              child: Text(textAnnuler),
            ),
            TextButton(
              onPressed: deconnectedFunction(),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
      child: showText,
    );
  }
}

