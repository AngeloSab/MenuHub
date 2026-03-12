import 'package:flutter/material.dart';

import '../../../../domain/menu_package/menu.dart';
import '../../shared/hotel_colors.dart';
import '../../shared/hotel_radius.dart';
import 'status_chip.dart';

class MenuListItemCard extends StatelessWidget {
  final Menu menu;
  final VoidCallback onEdit;
  final VoidCallback onToggleOpen;

  const MenuListItemCard({
    super.key,
    required this.menu,
    required this.onEdit,
    required this.onToggleOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: HotelColors.background,
        borderRadius: BorderRadius.circular(HotelRadius.button),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: menu.isOpen
              ? HotelColors.success.withOpacity(0.35)
              : HotelColors.warning.withOpacity(0.35),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _mealTypeLabel(menu.mealType.name),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: HotelColors.secondary,
                    ),
                  ),
                ),
                StatusChip(
                  label: menu.isOpen ? 'Aperto' : 'Chiuso',
                  color: menu.isOpen
                      ? HotelColors.success
                      : HotelColors.warning,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Data: ${_formatDate(menu.date)}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              'Deadline: ${_formatDateTime(menu.deadline)}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Portate: ${menu.courses.length}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: HotelColors.secondary,
                      side: const BorderSide(
                        color: HotelColors.secondary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(HotelRadius.button),
                      ),
                    ),
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Modifica'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: menu.isOpen
                          ? HotelColors.warning
                          : HotelColors.success,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(HotelRadius.button),
                      ),
                    ),
                    onPressed: onToggleOpen,
                    icon: Icon(
                      menu.isOpen
                          ? Icons.lock_outline
                          : Icons.lock_open_outlined,
                    ),
                    label: Text(menu.isOpen ? 'Chiudi' : 'Apri'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _mealTypeLabel(String value) {
    switch (value) {
      case 'breakfast':
        return 'Colazione';
      case 'lunch':
        return 'Pranzo';
      case 'dinner':
        return 'Cena';
      default:
        return value;
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  String _formatDateTime(DateTime dateTime) {
    final date = _formatDate(dateTime);
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$date - $hour:$minute';
  }
}