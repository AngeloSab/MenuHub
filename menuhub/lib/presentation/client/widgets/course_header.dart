import 'package:flutter/material.dart';

class CourseHeader extends StatelessWidget {
  final String title;
  final int orderedCount;

  const CourseHeader({
    super.key,
    required this.title,
    required this.orderedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E2E2E),
              letterSpacing: 0.4,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFE9DED0),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '$orderedCount',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4A4036),
            ),
          ),
        ),
      ],
    );
  }
}