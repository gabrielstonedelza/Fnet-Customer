import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class MyCarouselComponent extends StatelessWidget {
  const MyCarouselComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
        items: const [
          Text(
            "Access Bank",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFFF68121)),
          ),
          Text(
            "Fidelity Bank",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFFFA8528)),
          ),
          Text(
            "GT Bank",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFFDE4A0A)),
          ),
          Text(
            "Calbank",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFFFDD106)),
          ),
          Text(
            "Ecobank",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFF165B9D)),
          ),
        ],
        options: CarouselOptions(
          height: 40,
          aspectRatio: 16 / 9,
          viewportFraction: 0.3,
          initialPage: 0,
          enableInfiniteScroll: true,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: false,
          scrollDirection: Axis.horizontal,
        ));
  }
}
