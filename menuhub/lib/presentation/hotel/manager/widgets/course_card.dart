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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(HotelRadius.card),
        boxShadow: const [
          BoxShadow(
            color: HotelColors.glowBlue,
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(HotelRadius.card),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              HotelColors.cardBackground,
              HotelColors.surfaceBlue,
            ],
          ),
          border: Border.all(
            color: HotelColors.borderSoft,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: HotelColors.secondary.withOpacity(0.10),
                      borderRadius:
                      BorderRadius.circular(HotelRadius.button),
                    ),
                    child: const Icon(
                      Icons.dining_outlined,
                      color: HotelColors.secondary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Portata',
                          style: TextStyle(
                            color: HotelColors.textPrimary,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          course.type == null
                              ? 'Seleziona il tipo di portata'
                              : _courseTypeLabel(course.type!),
                          style: const TextStyle(
                            color: HotelColors.textSecondary,
                            fontSize: 13,
                          ),
                        ),
                      ],
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
              const SizedBox(height: 14),
              DropdownButtonFormField<CourseType>(
                value: course.type,
                decoration: InputDecoration(
                  labelText: 'Tipo portata',
                  labelStyle: const TextStyle(
                    color: HotelColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.72),
                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(HotelRadius.button),
                    borderSide: const BorderSide(
                      color: HotelColors.borderSoft,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(HotelRadius.button),
                    borderSide: const BorderSide(
                      color: HotelColors.borderSoft,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(HotelRadius.button),
                    borderSide: const BorderSide(
                      color: HotelColors.secondary,
                      width: 1.4,
                    ),
                  ),
                ),
                items: CourseType.values.map((courseType) {
                  return DropdownMenuItem<CourseType>(
                    value: courseType,
                    child: Text(_courseTypeLabel(courseType)),
                  );
                }).toList(),
                onChanged: onCourseTypeChanged,
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Piatti',
                      style: TextStyle(
                        color: HotelColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: HotelColors.primary.withOpacity(0.08),
                      borderRadius:
                      BorderRadius.circular(HotelRadius.chip),
                    ),
                    child: Text(
                      '${course.dishes.length}',
                      style: const TextStyle(
                        color: HotelColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton.icon(
                    onPressed: onAddDish,
                    style: TextButton.styleFrom(
                      foregroundColor: HotelColors.accent,
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text(
                      'Aggiungi piatto',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (course.dishes.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.60),
                    borderRadius:
                    BorderRadius.circular(HotelRadius.button),
                    border: Border.all(
                      color: HotelColors.borderSoft,
                    ),
                  ),
                  child: const Text(
                    'Nessun piatto aggiunto. Inserisci il primo piatto di questa portata.',
                    style: TextStyle(
                      color: HotelColors.textSecondary,
                      height: 1.35,
                    ),
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
        ),
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