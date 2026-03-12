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
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: HotelColors.background,
        borderRadius: BorderRadius.circular(HotelRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: iconColor ?? HotelColors.secondary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}