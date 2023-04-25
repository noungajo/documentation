import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

import '../../../texte_interface/text.dart';

class SendEmail extends StatefulWidget {
  SendEmail(
      {required this.body, required this.subject, required this.recipients});
  String body;
  String subject;
  String recipients;

  @override
  State<SendEmail> createState() => _SendEmailState();
}

class _SendEmailState extends State<SendEmail> {
  String platformResponse = "";

  Future<void> send(String body, String subject, String recipient) async {
    final Email email = Email(
      body: body,
      subject: subject,
      recipients: [widget.recipients],
      isHTML: true,
    );
    print("***************send**************");

    try {
      await FlutterEmailSender.send(email);
      print("**************sended***************");
      platformResponse = 'success';
    } catch (error) {
      print(error);
      platformResponse = error.toString();
    }
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return nextButton(size.width * 0.5, size.height * 0.08, context);
  }

  Widget nextButton(double width, double height, BuildContext context) {
    return Container(
      width: width,
      height: height,
      //color: Colors.black,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFfe643d),
            Color(0xffC41028),
          ],
          //  tileMode: TileMode.mirror,
        ),
        borderRadius: BorderRadius.circular(width * 0.08),
      ),
      child: ElevatedButton(
        onPressed: () async {
         await send(widget.body, widget.subject, widget.recipients);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(platformResponse),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          //shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(width * 0.08),
          ),
          elevation: 0,
        ),
        child: Center(
          child: Text(
            envoyer,
            style: submitStyle,
          ),
        ),
      ),
    );
  }
}

TextStyle submitStyle = const TextStyle(
    fontFamily: 'Lato',
    fontWeight: FontWeight.w700,
    fontSize: 29.41,
    color: Colors.white);

