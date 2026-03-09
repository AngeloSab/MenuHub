import 'package:flutter/material.dart';
import 'package:menuhub/application/use_case/create_guest_session_uc.dart';
import 'package:menuhub/application/use_case/place_order_uc.dart';
import 'package:menuhub/domain/client_package/client_session.dart';
import 'package:menuhub/domain/menu_package/menu.dart';
import 'package:menuhub/infrastructure/local/client_session_local_repository.dart';
import 'package:menuhub/presentation/client/controllers/client_entry_controller.dart';
import 'package:menuhub/presentation/client/pages/client_menu_page.dart';
import 'package:menuhub/presentation/client/pages/client_session_form_page.dart';

class ClientEntryPage extends StatefulWidget {
  final Menu menu;
  final PlaceOrderUC placeOrderUC;
  final CreateGuestSessionUC createGuestSessionUC;
  final ClientSessionLocalRepository localRepository;

  const ClientEntryPage({
    super.key,
    required this.menu,
    required this.placeOrderUC,
    required this.createGuestSessionUC,
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
    final hotelIdFromUrl = _controller.readHotelIdFromUrl();

    if (!mounted) return;

    if (hotelIdFromUrl == null) {
      return;
    }

    ClientSession? savedSession;
    try {
      savedSession = await _controller.resolveSavedClientSession(hotelIdFromUrl);
    } catch (_) {
      return;
    }

    if (!mounted) return;

    if (savedSession != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ClientMenuPage(
            menu: widget.menu,
            clientSession: savedSession,
            placeOrderUC: widget.placeOrderUC,
          ),
        ),
      );
      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ClientSessionFormPage(
          menu: widget.menu,
          placeOrderUC: widget.placeOrderUC,
          createGuestSessionUC: widget.createGuestSessionUC,
          localRepository: widget.localRepository,
          hotelId: hotelIdFromUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final errorMessage = _controller.errorMessage;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EF),
      body: Center(
        child: _controller.isLoading
            ? const CircularProgressIndicator()
            : errorMessage != null
                ? Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          size: 48,
                          color: Color(0xFF8B5E3C),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Impossibile aprire il menu',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2E2E2E),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          errorMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF6B6B6B),
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
      ),
    );
  }
}