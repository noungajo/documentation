import 'package:flutter/material.dart';

import '../apply_responsive.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Image(
          image: const AssetImage('assets/illus.png'),
          width: ResponsiveApplication.giveTheNiceSizeForthisScreen(
              deviceWidth / 2)
          // Utils.getDeviceType() == 'phone'
          //     ? deviceWidth / 2
          //     : deviceWidth / 3,
          ),
    );
  }
}
