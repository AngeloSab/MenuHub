import 'package:flutter/material.dart';

import '../../../../application/use_cases/staff/create_menu_uc.dart';
import '../../../../application/use_cases/staff/get_menu_by_id_uc.dart';
import '../../shared/hotel_colors.dart';
import '../../shared/hotel_radius.dart';
import '../controllers/edit_menu_controller.dart';
import '../controllers/menu_list_controller.dart';
import '../widgets/menu_list_item_card.dart';
import 'edit_menu_page.dart';

class MenuListPage extends StatefulWidget {
  final MenuListController controller;
  final String hotelId;
  final GetMenuByIdUC getMenuByIdUC;
  final CreateMenuUC createMenuUC;
  final CreateMenuUC updateMenuUC;

  const MenuListPage({
    super.key,
    required this.controller,
    required this.hotelId,
    required this.getMenuByIdUC,
    required this.createMenuUC,
    required this.updateMenuUC,
  });

  @override
  State<MenuListPage> createState() => _MenuListPageState();
}

class _MenuListPageState extends State<MenuListPage> {
  @override
  void initState() {
    super.initState();
    widget.controller.startWatching(widget.hotelId);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      builder: (context, _) {
        final model = widget.controller.model;
        final openCount = model.menus.where((m) => m.isOpen).length;
        final closedCount = model.menus.where((m) => !m.isOpen).length;

        return Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButton: FloatingActionButton.extended(
            elevation: 0,
            backgroundColor: HotelColors.accent,
            foregroundColor: Colors.white,
            onPressed: _openCreateMenu,
            icon: const Icon(Icons.add),
            label: const Text(
              'Nuovo menu',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  HotelColors.backgroundSecondary,
                  HotelColors.background,
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -90,
                  left: -30,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: HotelColors.glowBlue,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                Positioned(
                  top: 90,
                  right: -40,
                  child: Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      color: HotelColors.glowPurple,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Gestione Menu',
                                style: TextStyle(
                                  color: HotelColors.textPrimary,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.4,
                                ),
                              ),
                            ),
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.72),
                                borderRadius: BorderRadius.circular(
                                  HotelRadius.button,
                                ),
                                border: Border.all(
                                  color: HotelColors.borderSoft,
                                ),
                              ),
                              child: const Icon(
                                Icons.grid_view_rounded,
                                color: HotelColors.secondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: model.isLoading
                            ? const Center(
                          child: CircularProgressIndicator(),
                        )
                            : RefreshIndicator(
                          color: HotelColors.primary,
                          onRefresh: () async {
                            widget.controller.startWatching(widget.hotelId);
                          },
                          child: ListView(
                            padding: const EdgeInsets.fromLTRB(
                              16,
                              14,
                              16,
                              100,
                            ),
                            children: [
                              _HeroSection(
                                totalMenus: model.menus.length,
                                openMenus: openCount,
                                closedMenus: closedCount,
                              ),
                              const SizedBox(height: 18),
                              if (model.errorMessage != null)
                                _PageErrorCard(
                                  message: model.errorMessage!,
                                  onRetry: () {
                                    widget.controller.clearError();
                                    widget.controller.startWatching(
                                      widget.hotelId,
                                    );
                                  },
                                )
                              else if (model.menus.isEmpty)
                                _EmptyMenuState(
                                  onCreateMenu: _openCreateMenu,
                                )
                              else
                                Column(
                                  children: model.menus.map((menu) {
                                    final ordersCount = widget.controller
                                        .ordersCountForMenu(menu.id);

                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 14,
                                      ),
                                      child: MenuListItemCard(
                                        menu: menu,
                                        ordersCount: ordersCount,
                                        onEdit: () =>
                                            _openEditMenu(menu.id),
                                        onToggleOpen: () async {
                                          if (menu.isOpen) {
                                            await widget.controller
                                                .closeMenu(
                                              hotelId: widget.hotelId,
                                              menuId: menu.id,
                                            );
                                          } else {
                                            await widget.controller
                                                .openMenu(
                                              hotelId: widget.hotelId,
                                              menuId: menu.id,
                                            );
                                          }
                                        },
                                        onCountOrders: () {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                ordersCount == 1
                                                    ? 'Questo menu ha 1 ordine'
                                                    : 'Questo menu ha $ordersCount ordini',
                                              ),
                                            ),
                                          );
                                        },
                                        onDelete: () =>
                                            _confirmDeleteMenu(menu.id),
                                        onArchive: () =>
                                            _confirmArchiveMenu(menu.id),
                                      ),
                                    );
                                  }).toList(),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openCreateMenu() async {
    final editorController = MenuEditorController(
      getMenuByIdUC: widget.getMenuByIdUC,
      createMenuUC: widget.createMenuUC,
      updateMenuUC: widget.updateMenuUC,
      hotelId: widget.hotelId,
    );

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MenuEditorPage(
          controller: editorController,
          hotelId: widget.hotelId,
          onSaved: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Future<void> _openEditMenu(String menuId) async {
    final editorController = MenuEditorController(
      getMenuByIdUC: widget.getMenuByIdUC,
      createMenuUC: widget.createMenuUC,
      updateMenuUC: widget.updateMenuUC,
      hotelId: widget.hotelId,
    );

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MenuEditorPage(
          controller: editorController,
          hotelId: widget.hotelId,
          menuId: menuId,
          onSaved: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Future<void> _confirmDeleteMenu(String menuId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Elimina menu'),
          content: const Text(
            'Questo menu non ha ordini associati e può essere eliminato definitivamente. L\'azione non può essere annullata.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Annulla'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Elimina'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;
    if (!mounted) return;

    final ok = await widget.controller.deleteMenu(
      hotelId: widget.hotelId,
      menuId: menuId,
    );

    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Menu eliminato con successo'),
        ),
      );
    }
  }

  Future<void> _confirmArchiveMenu(String menuId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Archivia menu'),
          content: const Text(
            'Questo menu ha ordini associati. Verrà rimosso dalla lista principale ma resterà disponibile nello storico.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Annulla'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Archivia'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;
    if (!mounted) return;

    final ok = await widget.controller.archiveMenu(
      hotelId: widget.hotelId,
      menuId: menuId,
    );

    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Menu archiviato con successo'),
        ),
      );
    }
  }
}

class _HeroSection extends StatelessWidget {
  final int totalMenus;
  final int openMenus;
  final int closedMenus;

  const _HeroSection({
    required this.totalMenus,
    required this.openMenus,
    required this.closedMenus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(HotelRadius.card),
        boxShadow: const [
          BoxShadow(
            color: HotelColors.glowBlue,
            blurRadius: 28,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(HotelRadius.card),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              HotelColors.primary,
              HotelColors.secondary,
              HotelColors.accent,
            ],
            stops: [0.0, 0.55, 1.0],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Menu manager',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Crea, modifica, apri e chiudi i menu del tuo hotel in modo rapido e ordinato.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'Totali',
                    value: '$totalMenus',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatCard(
                    label: 'Aperti',
                    value: '$openMenus',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatCard(
                    label: 'Chiusi',
                    value: '$closedMenus',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(HotelRadius.button),
        border: Border.all(
          color: Colors.white.withOpacity(0.14),
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _PageErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _PageErrorCard({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: HotelColors.cardBackground,
        borderRadius: BorderRadius.circular(HotelRadius.card),
        border: Border.all(
          color: HotelColors.warning.withOpacity(0.18),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 42,
            color: HotelColors.warning,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: HotelColors.textPrimary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: onRetry,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: HotelColors.secondary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  HotelRadius.button,
                ),
              ),
            ),
            child: const Text('Riprova'),
          ),
        ],
      ),
    );
  }
}

class _EmptyMenuState extends StatelessWidget {
  final VoidCallback onCreateMenu;

  const _EmptyMenuState({
    required this.onCreateMenu,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: HotelColors.accent.withOpacity(0.10),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(
              Icons.restaurant_menu,
              size: 34,
              color: HotelColors.accent,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Nessun menu disponibile',
            style: TextStyle(
              color: HotelColors.textPrimary,
              fontSize: 19,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Crea il primo menu per iniziare a pubblicare le proposte per gli ospiti.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: HotelColors.textSecondary,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: onCreateMenu,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: HotelColors.accent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  HotelRadius.button,
                ),
              ),
            ),
            icon: const Icon(Icons.add),
            label: const Text('Crea menu'),
          ),
        ],
      ),
    );
  }
}