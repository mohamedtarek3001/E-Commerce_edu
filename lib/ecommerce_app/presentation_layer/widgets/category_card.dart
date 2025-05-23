import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key, required this.index,required this.image,required this.label});

  final int index;
  final String image;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(color: Color((0xffDFEECF * (0.2 * (index + 1))).toInt()), borderRadius: BorderRadius.circular(7), border: Border.all(color: const Color(0xff576A69))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(image??
              'assets/appIcons/medicalService.svg',
            height: 80,
          ),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xff576A69),
            ),
          ),
        ],
      ),
    );
  }
}