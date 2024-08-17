import 'package:flutter/material.dart';
import 'package:navigation/models/meal.dart';
import 'package:transparent_image/transparent_image.dart';

class MealDetailsScreen extends StatelessWidget {
  const MealDetailsScreen({super.key, required this.meal});

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
      ),
      body: Center(
        child: FadeInImage(
          height: 250,
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: MemoryImage(kTransparentImage),
          image: NetworkImage(meal.imageUrl),
        ),
      ),
    );
  }
}
