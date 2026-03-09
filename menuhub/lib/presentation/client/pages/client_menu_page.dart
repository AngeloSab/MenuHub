import 'package:flutter/material.dart';
import 'package:menuhub/domain/menu_package/menu.dart';
import 'package:menuhub/presentation/client/widgets/bottom_action_bar.dart';
import 'package:menuhub/presentation/client/widgets/confirm_order_dialog.dart';
import 'package:menuhub/presentation/client/widgets/course_section.dart';
import 'package:menuhub/presentation/client/widgets/menu_header.dart';

import '../../../application/use_cases/client/place_order_uc.dart';
import '../../../domain/client_package/client_session.dart';
import '../controllers/clilent_menu_controller.dart';

class ClientMenuPage extends StatefulWidget {
  final Menu menu;
  final ClientSession clientSession;
  final PlaceOrderUC placeOrderUC;

  const ClientMenuPage({
    super.key,
    required this.menu,
    required this.clientSession,
    required this.placeOrderUC,
  });

  @override
  State<ClientMenuPage> createState() => _ClientMenuPageState();
}

class _ClientMenuPageState extends State<ClientMenuPage> {
  late final ClientMenuController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ClientMenuController(
      menu: widget.menu,
      placeOrderUC: widget.placeOrderUC,
    );
    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _onConfirmPressed() async {
    if (!_controller.hasSelections || _controller.isSubmitting) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const ConfirmOrderDialog(),
    );

    if (confirmed != true) return;

    try {
      final order = await _controller.submitOrder(
        clientSession: widget.clientSession,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ordine confermato con ${order.selections.length} selezioni.',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Errore durante l\'invio dell\'ordine: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final menu = widget.menu;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EF),
      body: SafeArea(
        child: Column(
          children: [
            MenuHeader(menu: menu),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                child: Column(
                  children: menu.courses.map((course) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: CourseSection(
                        course: course,
                        orderedCount: _controller.orderedCountForCourse(course),
                        quantityOf: _controller.quantityOf,
                        variationOf: _controller.variationOf,
                        isVariationVisible: _controller.isVariationVisible,
                        onIncrement: _controller.incrementDish,
                        onDecrement: _controller.decrementDish,
                        onToggleVariation: _controller.toggleVariation,
                        onVariationChanged: _controller.updateVariation,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomActionBar(
        onClear: (!_controller.hasSelections || _controller.isSubmitting)
            ? null
            : _controller.clearOrder,
        onConfirm: (!_controller.hasSelections || _controller.isSubmitting)
            ? null
            : _onConfirmPressed,
      ),
    );
  }
}