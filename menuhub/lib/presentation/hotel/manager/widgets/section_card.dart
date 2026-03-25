import 'package:flutter/material.dart';

import '../../shared/hotel_colors.dart';
import '../../shared/hotel_radius.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? iconColor;
  final Widget child;

  const SectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? HotelColors.primary;

    return Container(
      decoration: BoxDecoration(
        color: HotelColors.cardBackground,
        borderRadius: BorderRadius.circular(HotelRadius.card),
        border: Border.all(color: HotelColors.borderSoft),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(HotelRadius.button),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: HotelColors.textPrimary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            child,
          ],
        ),
      ),
    );
  }
}