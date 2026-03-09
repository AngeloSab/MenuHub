import 'package:flutter/material.dart';
import 'package:menuhub/domain/menu_package/dish.dart';

import 'dish_type_icons.dart';
import 'quantity_stepper.dart';
import 'variation_row.dart';

class DishRow extends StatelessWidget {
  final Dish dish;
  final int quantity;
  final String variation;
  final bool isVariationVisible;

  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onToggleVariation;
  final ValueChanged<String> onVariationChanged;

  const DishRow({
    super.key,
    required this.dish,
    required this.quantity,
    required this.variation,
    required this.isVariationVisible,
    required this.onIncrement,
    required this.onDecrement,
    required this.onToggleVariation,
    required this.onVariationChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// AREA TESTO (nome + descrizione)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dish.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2E2E2E),
                    ),
                  ),

                  if (dish.description.trim().isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      dish.description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF7A726B),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 12),

            /// AREA STEPPER (sempre stessa posizione)
            SizedBox(
              width: 90,
              child: QuantityStepper(
                quantity: quantity,
                onIncrement: onIncrement,
                onDecrement: onDecrement,
              ),
            ),

            const SizedBox(width: 10),

            /// AREA ICONE (larghezza fissa → non sposta lo stepper)
            SizedBox(
              width: 80,
              child: Align(
                alignment: Alignment.centerRight,
                child: DishTypeIcons(
                  dishTags: dish.dishTags,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        /// VARIAZIONI
        Align(
          alignment: Alignment.centerLeft,
          child: VariationRow(
            isVisible: isVariationVisible,
            value: variation,
            onToggle: onToggleVariation,
            onChanged: onVariationChanged,
          ),
        ),
      ],
    );
  }
}