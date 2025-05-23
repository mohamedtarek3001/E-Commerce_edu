import 'package:animated_rating_stars/animated_rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.rate,
  });

  final String imageUrl;
  final String name;
  final double price;
  final double rate;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 215,
      width: 215 * 0.813,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: const Color(0x26000000)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(7), topRight: Radius.circular(7)),
                child: Image.network(
                  imageUrl,
                  height: 215 * 0.533,
                  width: 215 * 0.813,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 0,
                child: IconButton(
                  style: IconButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: EdgeInsets.zero
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border,size: 25,),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            name??'Product Name',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xff576A69), fontSize: 15),
          ),
          const SizedBox(
            height: 5,
          ),
          Center(
            child: AnimatedRatingStars(
              initialRating: rate,
              minRating: 0.0,
              maxRating: 5.0,
              filledColor: Colors.amber,
              emptyColor: Colors.grey,
              filledIcon: Icons.star,
              halfFilledIcon: Icons.star_half,
              emptyIcon: Icons.star_border,
              onChanged: (double rating) {
                // Handle the rating change here
                print('Rating: $rating');
              },
              displayRatingValue: true,
              interactiveTooltips: true,
              customFilledIcon: Icons.star,
              customHalfFilledIcon: Icons.star_half,
              customEmptyIcon: Icons.star_border,
              starSize: 10.0,
              readOnly: true,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$price \$',
                style: const TextStyle(
                  color: Color(0xff526262),
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                  padding: EdgeInsets.zero,
                  style: IconButton.styleFrom(
                    minimumSize: const Size(30, 30),
                    maximumSize: const Size(30, 30),
                    backgroundColor: const Color(0xff22C7B6),
                  ),
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    'assets/appIcons/cartIcon.svg',
                    height: 25,
                  ))
            ],
          ),
        ],
      ),
    );
  }
}