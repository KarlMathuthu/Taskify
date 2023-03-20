// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:taskify/theme/theme_colors.dart';

class MessageDesign extends StatelessWidget {
  const MessageDesign({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            // height: 20,
            padding: EdgeInsets.all(5),
            constraints: BoxConstraints(
              minHeight: 40,
              maxWidth: size.width / 1.3,
            ),
            decoration: BoxDecoration(
                color: ThemeColors().blue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                )),
            child: Text(
              'hhhhhhhh',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
