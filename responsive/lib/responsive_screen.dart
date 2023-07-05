import 'package:flutter/material.dart';
import 'package:responsive/widget_responsive.dart/button_widget.dart';
import 'package:responsive/widget_responsive.dart/caption_widget.dart';
import 'package:responsive/widget_responsive.dart/illustration_widget.dart';
import 'package:responsive/widget_responsive.dart/indicator_widget.dart';
import 'package:responsive/widget_responsive.dart/title_widget.dart';

import 'device_width.dart';

class ResponsiveScreen extends StatefulWidget {
  const ResponsiveScreen({super.key});

  @override
  State<ResponsiveScreen> createState() => _ResponsiveScreenState();
}

class _ResponsiveScreenState extends State<ResponsiveScreen> {
  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size);
    print(Utils.getDeviceType());
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 24.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Here is where the widget will build
                const TitleWidget(),
                Column(
                  children: const [
                    IllustrationWidget(),
                    CaptionWidget(),
                    SizedBox(
                      height: 16.0,
                    ),
                    IndicatorWidget(),
                  ],
                ),

                const ButtonWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
