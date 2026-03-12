import 'package:flutter/material.dart';

import '../../../../domain/menu_package/course_type.dart';
import '../../../../domain/menu_package/dish_tag.dart';
import '../../shared/hotel_colors.dart';
import '../../shared/hotel_radius.dart';
import '../models/edit_course_model.dart';
import 'dish_card.dart';

class CourseCard extends StatelessWidget {
  final EditCourseModel course;
  final VoidCallback onRemoveCourse;
  final ValueChanged<CourseType?> onCourseTypeChanged;
  final VoidCallback onAddDish;
  final void Function(String dishId) onRemoveDish;
  final void Function(String dishId, String value) onDishNameChanged;
  final void Function(String dishId, String value) onDishDescriptionChanged;
  final void Function(String dishId, DishTag tag) onToggleTag;

  const CourseCard({
    super.key,
    required this.course,
    required this.onRemoveCourse,
    required this.onCourseTypeChanged,
    required this.onAddDish,
    required this.onRemoveDish,
    required this.onDishNameChanged,
    required this.onDishDescriptionChanged,
    required this.onToggleTag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: HotelColors.background,
        borderRadius: BorderRadius.circular(HotelRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.dining_outlined,
                color: HotelColors.secondary,
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Corso',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: HotelColors.secondary,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Rimuovi corso',
                onPressed: onRemoveCourse,
                icon: const Icon(
                  Icons.delete_outline,
                  color: HotelColors.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<CourseType>(
            value: course.type,
            decoration: InputDecoration(
              labelText: 'Tipo corso',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(HotelRadius.input),
              ),
            ),
            items: CourseType.values.map((courseType) {
              return DropdownMenuItem(
                value: courseType,
                child: Text(_courseTypeLabel(courseType)),
              );
            }).toList(),
            onChanged: onCourseTypeChanged,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Piatti',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: onAddDish,
                icon: const Icon(Icons.add, color: HotelColors.accent),
                label: const Text(
                  'Aggiungi piatto',
                  style: TextStyle(color: HotelColors.accent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (course.dishes.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: HotelColors.secondary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(HotelRadius.input),
              ),
              child: const Text(
                'Nessun piatto aggiunto.',
                style: TextStyle(color: Colors.black54),
              ),
            )
          else
            Column(
              children: course.dishes.map((dish) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: DishCard(
                    dish: dish,
                    onRemove: () => onRemoveDish(dish.id),
                    onNameChanged: (value) =>
                        onDishNameChanged(dish.id, value),
                    onDescriptionChanged: (value) =>
                        onDishDescriptionChanged(dish.id, value),
                    onToggleTag: (tag) => onToggleTag(dish.id, tag),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  String _courseTypeLabel(CourseType value) {
    switch (value.name) {
      case 'starter':
        return 'Antipasto';
      case 'first':
        return 'Primo';
      case 'second':
        return 'Secondo';
      case 'side':
        return 'Contorno';
      case 'dessert':
        return 'Dolce';
      case 'drink':
        return 'Bevanda';
      default:
        return value.name;
    }
  }
}