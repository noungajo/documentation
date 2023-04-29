import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/store_style.dart';

class SatisfactionCommentaire extends StatefulWidget {
  @override
  State<SatisfactionCommentaire> createState() => _SatisfactionClientState();
}

class _SatisfactionClientState extends State<SatisfactionCommentaire> {
  RxBool activeSend = false.obs;
  bool isAddingItem = false,
      isCartAccess = false,
      isSetupBillingAdress = false,
      isSetupShippingAdress = false,
      isFindingItem = false;
  TextEditingController commentaireController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text('titre_commentaire'.tr),
      ),
      content: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.48,
          child: Column(
            children: [
              //ajout au panier
              Row(
                children: [
                  Checkbox(
                      value: isAddingItem,
                      onChanged: (checked) {
                        setState(() {
                          isAddingItem = checked!;

                          activeSend.value = isAddingItem ||
                              isCartAccess ||
                              isSetupBillingAdress ||
                              isSetupShippingAdress ||
                              isFindingItem;
                        });
                      }),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.57,
                      child: Text("add_item".tr)),
                ],
              ),
              //accessibilité du panier
              Row(
                children: [
                  Checkbox(
                      value: isCartAccess,
                      onChanged: (checked) {
                        setState(() {
                          isCartAccess = checked!;
                          activeSend.value = isAddingItem ||
                              isCartAccess ||
                              isSetupBillingAdress ||
                              isSetupShippingAdress ||
                              isFindingItem;
                        });
                      }),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.57,
                      child: Text("cart_access".tr)),
                ],
              ),
              //adresse de facturation

              Row(
                children: [
                  Checkbox(
                      value: isSetupBillingAdress,
                      onChanged: (checked) {
                        setState(() {
                          isSetupBillingAdress = checked!;
                          activeSend.value = isAddingItem ||
                              isCartAccess ||
                              isSetupBillingAdress ||
                              isSetupShippingAdress ||
                              isFindingItem;
                        });
                      }),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.57,
                      child: Text("facturation_issue".tr)),
                ],
              ),
              //adresse de livraison

              Row(
                children: [
                  Checkbox(
                      value: isSetupShippingAdress,
                      onChanged: (checked) {
                        setState(() {
                          isSetupShippingAdress = checked!;
                          activeSend.value = isAddingItem ||
                              isCartAccess ||
                              isSetupBillingAdress ||
                              isSetupShippingAdress ||
                              isFindingItem;
                        });
                      }),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.57,
                      child: Text("livraison_issue".tr)),
                ],
              ),
              // retrouver un article
              Row(
                children: [
                  Checkbox(
                      value: isFindingItem,
                      onChanged: (checked) {
                        setState(() {
                          isFindingItem = checked!;
                          activeSend.value = isAddingItem ||
                              isCartAccess ||
                              isSetupBillingAdress ||
                              isSetupShippingAdress ||
                              isFindingItem;
                        });
                      }),
                  SizedBox(
                      width: MediaQuery.of(context).size.width * 0.57,
                      child: Text("find_item_issue".tr)),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              //commentaire
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("autre".tr + " :"),
                  SizedBox(
                    width: 4,
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * 0.56,
                      child: Form(
                          child: TextFormField(
                              onChanged: (value) {
                                activeSend.value = isAddingItem ||
                                    isCartAccess ||
                                    isSetupBillingAdress ||
                                    isSetupShippingAdress ||
                                    isFindingItem ||
                                    value.isNotEmpty;
                              },
                              controller: commentaireController,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                label: labelText("entre_text".tr),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xffC41028), width: 1),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xffC41028), width: 1),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xffC41028), width: 1),
                                ),
                                disabledBorder: InputBorder.none,
                              ),
                              maxLength: 250))),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('fermer'.tr),
          onPressed: () {
            Navigator.of(context).pop(null);
          },
        ),
        TextButton(
          child: Obx(() => activeSend.value
              ? Text('envoyer'.tr)
              : Text(
                  'envoyer'.tr,
                  style: TextStyle(color: Colors.grey),
                )),
          onPressed: () {
            if (activeSend.value) {
              var data = {};
              if (commentaireController.text.isNotEmpty) {
                data["commentaire"] = commentaireController.text;
              }
              if (isAddingItem) {
                data["add_item"] = "add_item".tr;
              }
              if (isCartAccess) {
                data["cart_access"] = "cart_access".tr;
              }
              if (isSetupBillingAdress) {
                data["setup_billing_adress"] = "facturation_issue".tr;
              }
              if (isSetupShippingAdress) {
                data["setup_shipping_adress"] = "livraison_issue".tr;
              }
              if (isFindingItem) {
                data["find_item"] = "find_item_issue".tr;
              }

              Navigator.of(context).pop(data);
            }
          },
        )
      ],
    );
  }
}
