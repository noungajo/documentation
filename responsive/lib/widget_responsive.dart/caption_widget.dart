import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../apply_responsive.dart';

class CaptionWidget extends StatelessWidget {
  const CaptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Play Anywhere',
          style: GoogleFonts.inter(
            fontSize:
                ResponsiveApplication.giveTheNiceBoldTextSizeForthisScreen(
                    28), //Utils.getDeviceType() == 'phone' ? 28.0 : 46.0,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(
          height: 16.0,
        ),
        Text(
          'The video call feature can be\naccessed from anywhere in your\nhouse to help you.',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize:
                ResponsiveApplication.giveTheNiceSimpleTextSizeForthisScreen(
                    18), //Utils.getDeviceType() == 'phone' ? 18.0 : 28.0,
            fontWeight: FontWeight.w300,
            color: const Color(0xFFA6A6A6),
          ),
        ),
      ],
    );
  }
}
