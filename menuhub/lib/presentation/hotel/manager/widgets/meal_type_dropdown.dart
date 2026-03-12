import 'package:flutter/material.dart';

import '../../../../domain/menu_package/meal_type.dart';
import '../../shared/hotel_colors.dart';
import '../../shared/hotel_radius.dart';

class MealTypeDropdown extends StatelessWidget {
  final MealType? value;
  final ValueChanged<MealType?> onChanged;

  const MealTypeDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<MealType>(
      value: value,
      decoration: InputDecoration(
        labelText: 'Tipo pasto',
        prefixIcon: const Icon(Icons.restaurant_outlined),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(HotelRadius.input),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(HotelRadius.input),
          borderSide: BorderSide(
            color: HotelColors.secondary.withOpacity(0.2),
          ),
        ),
      ),
      items: MealType.values.map((mealType) {
        return DropdownMenuItem(
          value: mealType,
          child: Text(_mealTypeLabel(mealType)),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  String _mealTypeLabel(MealType value) {
    switch (value.name) {
      case 'breakfast':
        return 'Colazione';
      case 'lunch':
        return 'Pranzo';
      case 'dinner':
        return 'Cena';
      default:
        return value.name;
    }
  }
}