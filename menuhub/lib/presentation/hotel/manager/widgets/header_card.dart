import 'package:flutter/material.dart';

import '../../shared/hotel_colors.dart';
import '../../shared/hotel_radius.dart';

class HeaderCard extends StatelessWidget {
  final bool isEditMode;
  final bool isOpen;

  const HeaderCard({
    super.key,
    required this.isEditMode,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    final stateColor =
    isOpen ? HotelColors.success : HotelColors.warning;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(HotelRadius.card),
        gradient: const LinearGradient(
          colors: [
            HotelColors.primary,
            HotelColors.secondary,
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius:
              BorderRadius.circular(HotelRadius.button),
            ),
            child: const Icon(
              Icons.restaurant_menu,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditMode ? 'Modifica menu' : 'Nuovo menu',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Configura e gestisci il menu',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius:
              BorderRadius.circular(HotelRadius.chip),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: stateColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  isOpen ? 'APERTO' : 'CHIUSO',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}