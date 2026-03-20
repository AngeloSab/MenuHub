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
        labelStyle: const TextStyle(
          color: HotelColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: HotelColors.accent.withOpacity(0.10),
            borderRadius: BorderRadius.circular(HotelRadius.button),
          ),
          child: const Icon(
            Icons.restaurant_outlined,
            color: HotelColors.accent,
            size: 20,
          ),
        ),
        filled: true,
        fillColor: HotelColors.surfacePurple,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(HotelRadius.button),
          borderSide: const BorderSide(
            color: HotelColors.borderSoft,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(HotelRadius.button),
          borderSide: const BorderSide(
            color: HotelColors.borderSoft,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(HotelRadius.button),
          borderSide: const BorderSide(
            color: HotelColors.accent,
            width: 1.4,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),
      ),
      dropdownColor: HotelColors.cardBackground,
      icon: const Icon(
        Icons.keyboard_arrow_down_rounded,
        color: HotelColors.secondary,
      ),
      style: const TextStyle(
        color: HotelColors.textPrimary,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      items: MealType.values.map((mealType) {
        return DropdownMenuItem<MealType>(
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