import 'package:flutter/material.dart';
import 'package:menuhub/domain/menu_package/dish_tag.dart';

class DishTypeIcons extends StatelessWidget {
  final List<DishTag> dishTags;

  const DishTypeIcons({
    super.key,
    required this.dishTags,
  });

  IconData _iconForTag(DishTag tag) {
    switch (tag) {
      case DishTag.meat:
        return Icons.restaurant_rounded;
      case DishTag.fish:
        return Icons.set_meal_rounded;
      case DishTag.glutenFree:
        return Icons.no_food_rounded;
      case DishTag.lactoseFree:
        return Icons.local_drink_rounded;
      case DishTag.vegetarian:
        return Icons.spa_rounded;
      case DishTag.vegan:
        return Icons.eco_rounded;
    }
  }

  String _tooltipForTag(DishTag tag) {
    switch (tag) {
      case DishTag.meat:
        return 'Carne';
      case DishTag.fish:
        return 'Pesce';
      case DishTag.glutenFree:
        return 'Senza glutine';
      case DishTag.lactoseFree:
        return 'Senza lattosio';
      case DishTag.vegetarian:
        return 'Vegetariano';
      case DishTag.vegan:
        return 'Vegano';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (dishTags.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(
      spacing: 6,
      children: dishTags.map((tag) {
        return Tooltip(
          message: _tooltipForTag(tag),
          child: Icon(
            _iconForTag(tag),
            size: 18,
            color: const Color(0xFF7A6E63),
          ),
        );
      }).toList(),
    );
  }
}