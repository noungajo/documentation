import 'package:flutter/material.dart';

import '../apply_responsive.dart';
import '../device_width.dart';

class IllustrationWidget extends StatelessWidget {
  const IllustrationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Center(
      child: Image(
          image: const AssetImage(
            'assets/bureau.jpeg',
          ),
          width: ResponsiveApplication.giveTheNiceScreenImageForthisScreen(
              deviceWidth)
          //  Utils.getDeviceType() == 'phone' ? deviceWidth : deviceWidth / 1.2,
          ),
    );
  }
}
