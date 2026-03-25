import 'package:flutter/material.dart';

import '../../shared/hotel_colors.dart';
import '../../shared/hotel_radius.dart';

class EmptyCoursesCard extends StatelessWidget {
  final VoidCallback onAddCourse;

  const EmptyCoursesCard({super.key, required this.onAddCourse});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: HotelColors.cardBackground,
        borderRadius: BorderRadius.circular(HotelRadius.card),
        border: Border.all(color: HotelColors.borderSoft),
      ),
      child: Column(
        children: [
          const Icon(Icons.layers_outlined,
              size: 40, color: HotelColors.textSecondary),
          const SizedBox(height: 12),
          const Text(
            'Nessuna portata',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            'Aggiungi la prima portata',
            style: TextStyle(color: HotelColors.textSecondary),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onAddCourse,
            child: const Text('Aggiungi'),
          ),
        ],
      ),
    );
  }
}