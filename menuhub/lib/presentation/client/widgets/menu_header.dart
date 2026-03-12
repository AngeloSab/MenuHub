import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:menuhub/domain/menu_package/menu.dart';

class MenuHeader extends StatelessWidget {
  final Menu menu;

  const MenuHeader({
    super.key,
    required this.menu,
  });

  String _capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(menu.date);
    final mealTypeLabel = _capitalize(menu.mealType.toString());

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Column(
        children: [
          const Text(
            'Menu del giorno',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2E2E2E),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            '$mealTypeLabel • $formattedDate',
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF6B6B6B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}