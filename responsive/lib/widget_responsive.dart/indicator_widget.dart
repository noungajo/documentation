import 'package:flutter/material.dart';

import '../apply_responsive.dart';
import '../device_width.dart';

class IndicatorWidget extends StatelessWidget {
  const IndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.paid,
            color: const Color(0xFF4756DF),
            size: ResponsiveApplication.giveTheNiceIconeSizeForthisScreen(24)
            // Utils.getDeviceType() == 'phone' ? 24.0 : 32.0,
            ),
        Icon(Icons.paid,
            color: const Color(0xFFB9BFF3),
            size: ResponsiveApplication.giveTheNiceIconeSizeForthisScreen(24)
            //Utils.getDeviceType() == 'phone' ? 24.0 : 32.0,
            ),
        Icon(Icons.paid,
            color: const Color(0xFFB9BFF3),
            size: ResponsiveApplication.giveTheNiceIconeSizeForthisScreen(24)
            //Utils.getDeviceType() == 'phone' ? 24.0 : 32.0,
            ),
      ],
    );
  }
}
