import 'package:flutter/material.dart';
import 'package:menuhub/application/use_cases/client/create_client_session_uc.dart';
import 'package:menuhub/application/use_cases/client/get_open_menus_uc.dart';
import 'package:menuhub/application/use_cases/client/place_order_uc.dart';
import 'package:menuhub/presentation/client/controllers/client_entry_controller.dart';
import 'package:menuhub/presentation/client/pages/client_menu_page.dart';
import 'package:menuhub/presentation/client/pages/client_session_form_page.dart';
import '../../../local/client_session_local_repository.dart';
import '../models/client_entry_resolution.dart';

class ClientEntryPage extends StatefulWidget {
  final GetOpenMenusUC getOpenMenusUC;
  final PlaceOrderUC placeOrderUC;
  final CreateClientSessionUC createClientSessionUC;
  final ClientSessionLocalRepository localRepository;

  const ClientEntryPage({
    super.key,
    required this.getOpenMenusUC,
    required this.placeOrderUC,
    required this.createClientSessionUC,
    required this.localRepository,
  });

  @override
  State<ClientEntryPage> createState() => _ClientEntryPageState();
}

class _ClientEntryPageState extends State<ClientEntryPage> {
  late final ClientEntryController _controller;

  @override
  void initState() {
    super.initState();

    _controller = ClientEntryController(
      getOpenMenusUC: widget.getOpenMenusUC,
      loadSavedClientSessionByHotelId: widget.localRepository.loadByHotelId,
    );

    _controller.addListener(_onControllerChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _resolveFlow();
    });
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

  Future<void> _resolveFlow() async {
    final ClientEntryResolution resolution =
    await _controller.resolveEntryFlow();

    if (!mounted) return;

    if (resolution.shouldOpenMenu) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ClientMenuPage(
            menu: resolution.menu!,
            clientSession: resolution.clientSession!,
            placeOrderUC: widget.placeOrderUC,
          ),
        ),
      );
      return;
    }

    if (resolution.shouldOpenForm) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ClientSessionFormPage(
            menu: resolution.menu!,
            hotelId: resolution.hotelId!,
            placeOrderUC: widget.placeOrderUC,
            createClientSessionUC: widget.createClientSessionUC,
            localRepository: widget.localRepository,
          ),
        ),
      );
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final errorMessage = _controller.errorMessage;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EF),
      body: Center(
        child: _controller.isLoading
            ? const CircularProgressIndicator()
            : Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.info_outline_rounded,
                size: 48,
                color: Color(0xFF8B5E3C),
              ),
              const SizedBox(height: 16),
              Text(
                errorMessage ?? 'Nessun menu disponibile al momento',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E2E2E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}