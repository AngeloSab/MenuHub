import 'package:flutter/material.dart';

import '../../shared/hotel_colors.dart';
import '../../shared/hotel_radius.dart';

class ErrorBanner extends StatelessWidget {
  final String message;

  const ErrorBanner({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: HotelColors.warning.withOpacity(0.1),
        borderRadius: BorderRadius.circular(HotelRadius.input),
        border: Border.all(
          color: HotelColors.warning.withOpacity(0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: HotelColors.warning,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}