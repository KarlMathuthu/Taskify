// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:taskify/theme/theme_colors.dart';

class WidgetHome extends StatefulWidget {
  final String title;
  final String description;
  final String createDate;
  final String progress_percentage;
  const WidgetHome({
    super.key,
    required this.title,
    required this.description,
    required this.createDate,
    required this.progress_percentage,
  });

  @override
  State<WidgetHome> createState() => _WidgetHomeState();
}

class _WidgetHomeState extends State<WidgetHome> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        height: 90,
        padding: EdgeInsets.all(10),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 1, color: ThemeColors().grey)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    widget.description,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(widget.createDate)
                ],
              ),
            ),
            CircularStepProgressIndicator(
              totalSteps: int.parse(widget.progress_percentage),
              currentStep: int.parse(widget.progress_percentage),
              stepSize: 2,
              selectedColor: ThemeColors().blue,
              unselectedColor: ThemeColors().grey,
              padding: 0,
              width: 50,
              height: 50,
              selectedStepSize: 2,
              roundedCap: (_, __) => true,
              child: Center(
                child: Text(
                  '${widget.progress_percentage}%',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
