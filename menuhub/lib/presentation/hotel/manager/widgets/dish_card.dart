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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: HotelColors.primary.withOpacity(0.04),
        borderRadius: BorderRadius.circular(HotelRadius.button),
        border: Border.all(
          color: HotelColors.primary.withOpacity(0.12),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Piatto',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
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
          TextFormField(
            initialValue: dish.name,
            decoration: InputDecoration(
              labelText: 'Nome piatto',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: onDescriptionChanged,
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: DishTag.values.map((tag) {
                final isSelected = dish.dishTags.contains(tag);

                return FilterChip(
                  selected: isSelected,
                  label: Text(_dishTagLabel(tag)),
                  onSelected: (_) => onToggleTag(tag),
                );
              }).toList(),
            ),
          ),
        ],
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