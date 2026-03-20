import 'package:flutter/material.dart';

import '../../../../domain/menu_package/dish_tag.dart';
import '../../shared/hotel_colors.dart';
import '../../shared/hotel_radius.dart';
import '../models/edit_dish_model.dart';

class DishCard extends StatelessWidget {
  final EditDishModel dish;
  final VoidCallback onRemove;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onDescriptionChanged;
  final ValueChanged<DishTag> onToggleTag;

  const DishCard({
    super.key,
    required this.dish,
    required this.onRemove,
    required this.onNameChanged,
    required this.onDescriptionChanged,
    required this.onToggleTag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.72),
        borderRadius: BorderRadius.circular(HotelRadius.button),
        border: Border.all(
          color: HotelColors.borderSoft,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: HotelColors.primary.withOpacity(0.10),
                    borderRadius:
                    BorderRadius.circular(HotelRadius.button),
                  ),
                  child: const Icon(
                    Icons.restaurant_outlined,
                    size: 20,
                    color: HotelColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Piatto',
                    style: TextStyle(
                      color: HotelColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Rimuovi piatto',
                  onPressed: onRemove,
                  icon: const Icon(
                    Icons.delete_outline,
                    color: HotelColors.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextFormField(
              initialValue: dish.name,
              decoration: InputDecoration(
                labelText: 'Nome piatto',
                labelStyle: const TextStyle(
                  color: HotelColors.textSecondary,
                ),
                filled: true,
                fillColor: HotelColors.cardBackground,
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
                    color: HotelColors.primary,
                    width: 1.4,
                  ),
                ),
              ),
              onChanged: onNameChanged,
            ),
            const SizedBox(height: 12),
            TextFormField(
              initialValue: dish.description,
              minLines: 2,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Descrizione',
                labelStyle: const TextStyle(
                  color: HotelColors.textSecondary,
                ),
                filled: true,
                fillColor: HotelColors.cardBackground,
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
                    color: HotelColors.primary,
                    width: 1.4,
                  ),
                ),
              ),
              onChanged: onDescriptionChanged,
            ),
            const SizedBox(height: 14),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: DishTag.values.map((tag) {
                  final isSelected = dish.dishTags.contains(tag);

                  return FilterChip(
                    selected: isSelected,
                    showCheckmark: false,
                    backgroundColor: HotelColors.cardBackground,
                    selectedColor: HotelColors.accent.withOpacity(0.12),
                    side: BorderSide(
                      color: isSelected
                          ? HotelColors.accent.withOpacity(0.22)
                          : HotelColors.borderSoft,
                    ),
                    label: Text(
                      _dishTagLabel(tag),
                      style: TextStyle(
                        color: isSelected
                            ? HotelColors.accent
                            : HotelColors.textSecondary,
                        fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                    onSelected: (_) => onToggleTag(tag),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _dishTagLabel(DishTag value) {
    switch (value.name) {
      case 'vegetarian':
        return 'Vegetariano';
      case 'vegan':
        return 'Vegano';
      case 'glutenFree':
        return 'Senza glutine';
      case 'spicy':
        return 'Piccante';
      case 'lactoseFree':
        return 'Senza lattosio';
      default:
        return value.name;
    }
  }
}