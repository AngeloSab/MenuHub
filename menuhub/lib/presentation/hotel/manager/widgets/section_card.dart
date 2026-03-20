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
    final resolvedIconColor = iconColor ?? HotelColors.secondary;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(HotelRadius.card),
        boxShadow: const [
          BoxShadow(
            color: HotelColors.glowBlue,
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(HotelRadius.card),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              HotelColors.cardBackground,
              HotelColors.surfaceBlue,
            ],
          ),
          border: Border.all(
            color: HotelColors.borderSoft,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: resolvedIconColor.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(HotelRadius.button),
                    ),
                    child: Icon(
                      icon,
                      color: resolvedIconColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: HotelColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      ),
    );
  }
}