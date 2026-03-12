import 'package:flutter/material.dart';

import '../../shared/hotel_colors.dart';
import '../../shared/hotel_radius.dart';

class EmptyCoursesCard extends StatelessWidget {
  final VoidCallback onAddCourse;

  const EmptyCoursesCard({
    super.key,
    required this.onAddCourse,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: HotelColors.background,
        borderRadius: BorderRadius.circular(HotelRadius.card),
        border: Border.all(
          color: HotelColors.accent.withOpacity(0.15),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.layers_outlined,
            size: 46,
            color: HotelColors.accent.withOpacity(0.8),
          ),
          const SizedBox(height: 10),
          const Text(
            'Nessun corso aggiunto',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Aggiungi almeno una portata per costruire il menu.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 14),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: HotelColors.accent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(HotelRadius.button),
              ),
            ),
            onPressed: onAddCourse,
            icon: const Icon(Icons.add),
            label: const Text('Aggiungi corso'),
          ),
        ],
      ),
    );
  }
}