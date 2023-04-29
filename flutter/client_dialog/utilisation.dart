import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import 'client_dialog/satisfaction_client_dialog.dart';
import 'client_dialog/satisfaction_commentaire.dart';
import 'controllers/paniercontroller.dart';
import 'screens/store_style.dart';

class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  PanierController panierController = Get.find<PanierController>();
  TextEditingController quantityController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String hintTextQuantity = "1";
  @override
  void initState() {
    hintTextQuantity = panierController.quantite.value.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(),
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      left: size.width * 0.3,
                      right: size.width * 0.3,
                      top: size.height * 0.02,
                      bottom: size.height * 0.01),
                  child: Row(
                    children: [
                      Text("quantite", style: itemStyle),
                      SizedBox(
                        width: size.width * 0.03,
                      ),
                      //bouton pour manager de la quantité de produit
                      cartCounter(),
                    ],
                  ),
                ),
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
                TextButton(
                  onPressed: () async {
                    dynamic star = {};
                    int stars = await showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (_) => SatisfactionClient());
                    if (stars > 0 && stars < 3) {
                      star["mauvais"] = await showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (_) => SatisfactionCommentaire());
                      star["etoiles"] = stars;
                    } else {
                      star["etoiles"] = stars;
                      print("stop here");
                    }
                    print(star);
                  },
                  child: Text("Appui ici", style: itemStyle),
                )
              ],
            )));
  }

  Widget cartCounter() {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.width * 0.11,
      width: size.width * 0.15,
      child: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        key: _formKey,
        child: TextFormField(
          cursorColor: Colors.transparent,
          // onChanged: (value) {
          //   panierController.change.value = !panierController.change.value;
          // },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(top: size.width * 0.01),
            hintText: hintTextQuantity,
            hintStyle: TextStyle(
                fontFamily: 'Lato',
                fontWeight: FontWeight.w300,
                fontSize: 20,
                color: Colors.black),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.grey)),
            border: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.grey)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.grey)),
          ),
          controller: quantityController,
          style: TextStyle(
              fontFamily: 'Lato',
              fontWeight: FontWeight.w300,
              fontSize: 20,
              color: Colors.black),
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly //un seul chiffre
          ],
        ),
      ),
    );
  }
}
