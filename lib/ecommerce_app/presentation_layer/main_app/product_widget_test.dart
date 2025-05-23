import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/product_card_widget.dart';

class TestProductWidget extends StatelessWidget {
  const TestProductWidget({super.key});

  final imageUrl = 'https://img.freepik.com/free-vector/gradient-product-card-template_23-2149656335.jpg';

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          height: height,
          width: width,
          child: Center(
            child: ProductCard(imageUrl: imageUrl,rate: 0,price: 0,name: '',),
          ),
        ),
      ),
    );
  }
}


