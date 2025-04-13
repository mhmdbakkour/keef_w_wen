import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  const RatingWidget({super.key, required this.rating});

  final double? rating;

  @override
  Widget build(BuildContext context) {
    final Color ratingColor = Theme.of(context).colorScheme.primary;
    return Row(children: generateRating(rating ?? 0, ratingColor));
  }

  List<Icon> generateRating(double rating, Color ratingColor) {
    List<Icon> iconList = [];
    double value = rating.clamp(0, 5);

    for (int i = 0; i < 5; i++) {
      if (value >= 1) {
        iconList.add(Icon(Icons.star, color: ratingColor));
      } else if (value > 0) {
        iconList.add(Icon(Icons.star_half, color: ratingColor));
      } else {
        iconList.add(Icon(Icons.star_border, color: ratingColor));
      }
      value--;
    }

    return iconList;
  }
}
