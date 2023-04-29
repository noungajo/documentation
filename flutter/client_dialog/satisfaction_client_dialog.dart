import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SatisfactionClient extends StatefulWidget {
  @override
  State<SatisfactionClient> createState() => _SatisfactionClientState();
}

class _SatisfactionClientState extends State<SatisfactionClient> {
  int _stars = 0;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text('titre_satisfaction'.tr),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildStar(1),
          _buildStar(2),
          _buildStar(3),
          _buildStar(4),
          _buildStar(5),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: Text('ignorer'.tr),
          onPressed: () {
            Navigator.of(context).pop(_stars);
          },
        ),
        // TextButton(
        //   child: Text('OK'),
        //   onPressed: () {
        //     Navigator.of(context).pop(_stars);
        //   },
        // )
      ],
    );
  }

  Widget _buildStar(int starCount) {
    return InkWell(
      child: Icon(
        Icons.star,
        color: _stars >= starCount ? Colors.amber : Colors.grey,
      ),
      onTap: () {
        setState(() {
          _stars = starCount;
          Navigator.of(context).pop(_stars);
        });
      },
    );
  }
}
