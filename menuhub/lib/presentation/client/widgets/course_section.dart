import 'package:flutter/material.dart';
import 'package:menuhub/domain/menu_package/course.dart';

import 'course_header.dart';
import 'dish_row.dart';

class CourseSection extends StatelessWidget {
  final Course course;
  final int orderedCount;
  final int Function(String dishId) quantityOf;
  final String Function(String dishId) variationOf;
  final bool Function(String dishId) isVariationVisible;
  final void Function(String dishId) onIncrement;
  final void Function(String dishId) onDecrement;
  final void Function(String dishId) onToggleVariation;
  final void Function(String dishId, String value) onVariationChanged;

  const CourseSection({
    super.key,
    required this.course,
    required this.orderedCount,
    required this.quantityOf,
    required this.variationOf,
    required this.isVariationVisible,
    required this.onIncrement,
    required this.onDecrement,
    required this.onToggleVariation,
    required this.onVariationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          CourseHeader(
            title: course.type,
            orderedCount: orderedCount,
          ),
          const SizedBox(height: 14),
          ...course.dishes.map(
                (dish) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: DishRow(
                dish: dish,
                quantity: quantityOf(dish.id),
                variation: variationOf(dish.id),
                isVariationVisible: isVariationVisible(dish.id),
                onIncrement: () => onIncrement(dish.id),
                onDecrement: () => onDecrement(dish.id),
                onToggleVariation: () => onToggleVariation(dish.id),
                onVariationChanged: (value) =>
                    onVariationChanged(dish.id, value),
              ),
            ),
          ),
        ],
      ),
    );
  }
}