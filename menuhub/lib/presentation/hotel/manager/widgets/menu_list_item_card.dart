import 'package:flutter/material.dart';

import '../../../../domain/menu_package/menu.dart';
import '../../shared/hotel_colors.dart';
import '../../shared/hotel_radius.dart';
import 'status_chip.dart';

class MenuListItemCard extends StatelessWidget {
  final Menu menu;
  final int ordersCount;
  final VoidCallback onEdit;
  final VoidCallback onToggleOpen;
  final VoidCallback onCountOrders;
  final VoidCallback? onDelete;
  final VoidCallback? onArchive;

  const MenuListItemCard({
    super.key,
    required this.menu,
    required this.ordersCount,
    required this.onEdit,
    required this.onToggleOpen,
    required this.onCountOrders,
    this.onDelete,
    this.onArchive,
  });

  @override
  Widget build(BuildContext context) {
    final stateColor =
    menu.isOpen ? HotelColors.success : HotelColors.warning;

    final softSurface =
    menu.isOpen ? HotelColors.surfaceGreen : HotelColors.surfaceOrange;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(HotelRadius.card),
        boxShadow: [
          BoxShadow(
            color: menu.isOpen
                ? HotelColors.glowGreen
                : HotelColors.glowOrange,
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(HotelRadius.card),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              HotelColors.cardBackground,
              softSurface,
            ],
          ),
          border: Border.all(
            color: stateColor.withOpacity(0.18),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: HotelColors.secondary.withOpacity(0.10),
                      borderRadius:
                      BorderRadius.circular(HotelRadius.button),
                    ),
                    child: const Icon(
                      Icons.restaurant_menu,
                      color: HotelColors.secondary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        _mealTypeLabel(menu.mealType.name),
                        style: const TextStyle(
                          color: HotelColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  StatusChip(
                    label: menu.isOpen ? 'Aperto' : 'Chiuso',
                    color: stateColor,
                  ),
                  const SizedBox(width: 6),
                  _MoreMenuButton(
                    isOpen: menu.isOpen,
                    ordersCount: ordersCount,
                    onEdit: onEdit,
                    onDelete: onDelete,
                    onArchive: onArchive,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _InfoRow(
                icon: Icons.calendar_today_outlined,
                label: 'Data',
                value: _formatDate(menu.date),
              ),
              const SizedBox(height: 8),
              _InfoRow(
                icon: Icons.schedule_outlined,
                label: 'Deadline',
                value: _formatDateTime(menu.deadline),
              ),
              const SizedBox(height: 8),
              _InfoRow(
                icon: Icons.layers_outlined,
                label: 'Portate',
                value: '${menu.courses.length}',
              ),
              const SizedBox(height: 8),
              _InfoRow(
                icon: Icons.receipt_long_outlined,
                label: 'Ordini',
                value: '$ordersCount',
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: HotelColors.secondary,
                        side: const BorderSide(
                          color: HotelColors.borderStrong,
                        ),
                        backgroundColor: Colors.white.withOpacity(0.70),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(HotelRadius.button),
                        ),
                      ),
                      onPressed: onCountOrders,
                      icon: const Icon(Icons.receipt_long_outlined),
                      label: Text(
                        ordersCount == 1
                            ? '1 ordine'
                            : '$ordersCount ordini',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: menu.isOpen
                            ? HotelColors.warning
                            : HotelColors.success,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
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
                      label: Text(
                        menu.isOpen ? 'Chiudi' : 'Apri',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
    return '$date • $hour:$minute';
  }
}

class _MoreMenuButton extends StatelessWidget {
  final bool isOpen;
  final int ordersCount;
  final VoidCallback onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onArchive;

  const _MoreMenuButton({
    required this.isOpen,
    required this.ordersCount,
    required this.onEdit,
    required this.onDelete,
    required this.onArchive,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_MenuAction>(
      tooltip: 'Altre azioni',
      color: HotelColors.cardBackground,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HotelRadius.button),
      ),
      icon: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.70),
          borderRadius: BorderRadius.circular(HotelRadius.button),
          border: Border.all(
            color: HotelColors.borderSoft,
          ),
        ),
        child: const Icon(
          Icons.more_vert,
          color: HotelColors.textSecondary,
          size: 20,
        ),
      ),
      onSelected: (value) {
        switch (value) {
          case _MenuAction.edit:
            onEdit();
            break;
          case _MenuAction.delete:
            if (onDelete != null) {
              onDelete!();
            }
            break;
          case _MenuAction.archive:
            if (onArchive != null) {
              onArchive!();
            }
            break;
        }
      },
      itemBuilder: (context) {
        final items = <PopupMenuEntry<_MenuAction>>[
          const PopupMenuItem<_MenuAction>(
            value: _MenuAction.edit,
            child: Row(
              children: [
                Icon(Icons.edit_outlined, size: 20),
                SizedBox(width: 10),
                Text('Modifica'),
              ],
            ),
          ),
        ];

        if (!isOpen) {
          if (ordersCount == 0 && onDelete != null) {
            items.add(
              const PopupMenuItem<_MenuAction>(
                value: _MenuAction.delete,
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: HotelColors.warning,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Elimina',
                      style: TextStyle(color: HotelColors.warning),
                    ),
                  ],
                ),
              ),
            );
          } else if (ordersCount > 0 && onArchive != null) {
            items.add(
              const PopupMenuItem<_MenuAction>(
                value: _MenuAction.archive,
                child: Row(
                  children: [
                    Icon(
                      Icons.archive_outlined,
                      size: 20,
                      color: HotelColors.secondary,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Archivia',
                      style: TextStyle(color: HotelColors.secondary),
                    ),
                  ],
                ),
              ),
            );
          }
        }

        return items;
      },
    );
  }
}

enum _MenuAction {
  edit,
  delete,
  archive,
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: HotelColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: const TextStyle(
            color: HotelColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: HotelColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}