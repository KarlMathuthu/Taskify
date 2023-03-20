import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:taskify/theme/theme_colors.dart';

class CarouselSliderWidget extends StatelessWidget {
  const CarouselSliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: 5,
      itemBuilder: ((context, index, realIndex) {
        return Padding(
          padding: EdgeInsets.only(right: 2, left: 2),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Container(
              color: ThemeColors().blue,
            ),
          ),
        );
      }),
      options: CarouselOptions(
        autoPlay: true,
        height: 160,
        enlargeCenterPage: true,
        autoPlayAnimationDuration: Duration(
          milliseconds: 1000,
        ),
      ),
    );
  }
}
