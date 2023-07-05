import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../apply_responsive.dart';
import '../device_width.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: ResponsiveApplication.giveTheNiceWidthSizeBoxForthisScreen(
          deviceWidth / 2),
      // Utils.getDeviceType() == 'phone'
      //     ? deviceWidth / 2
      //     : deviceWidth / 2.5,
      height: ResponsiveApplication.giveTheNiceHeigthSizeBoxForthisScreen(56),
      //Utils.getDeviceType() == 'phone' ? 56.0 : 72.0,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4756DF),
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              Utils.getDeviceType() == 'phone' ? 15.0 : 20.0,
            ),
          ),
        ),
        onPressed: () {},
        child: Text(
          'Get Started',
          style: GoogleFonts.roboto(
              fontSize:
                  ResponsiveApplication.giveTheNiceSimpleTextSizeForthisScreen(
                      18)
              //Utils.getDeviceType() == 'phone' ? 18.0 : 24.0,
              ),
        ),
      ),
    );
  }
}
