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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(HotelRadius.card),
        boxShadow: const [
          BoxShadow(
            color: HotelColors.glowPurple,
            blurRadius: 26,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(HotelRadius.card),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              HotelColors.cardBackground,
              HotelColors.surfacePurple,
            ],
          ),
          border: Border.all(
            color: HotelColors.accent.withOpacity(0.12),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: HotelColors.accent.withOpacity(0.10),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.layers_outlined,
                size: 32,
                color: HotelColors.accent,
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'Nessuna portata aggiunta',
              style: TextStyle(
                color: HotelColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Inizia aggiungendo una portata. Potrai poi inserire i piatti e completare il menu in modo ordinato.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: HotelColors.textSecondary,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: HotelColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(HotelRadius.button),
                ),
              ),
              onPressed: onAddCourse,
              icon: const Icon(Icons.add),
              label: const Text('Aggiungi portata'),
            ),
          ],
        ),
      ),
    );
  }
}