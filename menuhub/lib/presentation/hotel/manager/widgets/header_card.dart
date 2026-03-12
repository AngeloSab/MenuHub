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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            HotelColors.primary,
            HotelColors.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(HotelRadius.card),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(HotelRadius.button),
            ),
            child: const Icon(
              Icons.restaurant_menu,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditMode ? 'Editor menu' : 'Creazione menu',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isEditMode
                      ? 'Modifica i dati e aggiorna il menu.'
                      : 'Compila i dati e crea un nuovo menu.',
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: (isOpen
                  ? HotelColors.success
                  : HotelColors.warning)
                  .withOpacity(0.18),
              borderRadius: BorderRadius.circular(HotelRadius.chip),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
              ),
            ),
            child: Text(
              isOpen ? 'APERTO' : 'CHIUSO',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}