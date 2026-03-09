import 'package:flutter/material.dart';
import 'package:menuhub/application/use_cases/client/create_client_session_uc.dart';
import 'package:menuhub/application/use_cases/client/place_order_uc.dart';
import 'package:menuhub/domain/menu_package/menu.dart';
import 'package:menuhub/local/client_session_local_repository.dart';
import 'package:menuhub/presentation/client/controllers/client_session_controller.dart';
import 'package:menuhub/presentation/client/pages/client_menu_page.dart';

class ClientSessionFormPage extends StatefulWidget {
  final Menu menu;
  final String hotelId;
  final PlaceOrderUC placeOrderUC;
  final CreateClientSessionUC createClientSessionUC;
  final ClientSessionLocalRepository localRepository;

  const ClientSessionFormPage({
    super.key,
    required this.menu,
    required this.hotelId,
    required this.placeOrderUC,
    required this.createClientSessionUC,
    required this.localRepository,
  });

  @override
  State<ClientSessionFormPage> createState() => _ClientSessionFormPageState();
}

class _ClientSessionFormPageState extends State<ClientSessionFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _roomController;
  late final TextEditingController _reservationController;
  late final TextEditingController _peopleCountController;

  late final ClientSessionController _controller;

  @override
  void initState() {
    super.initState();

    _roomController = TextEditingController();
    _reservationController = TextEditingController();
    _peopleCountController = TextEditingController();

    _controller = ClientSessionController(
      hotelId: widget.hotelId,
      createClientSessionUC: widget.createClientSessionUC,
      localRepository: widget.localRepository,
    );

    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _roomController.dispose();
    _reservationController.dispose();
    _peopleCountController.dispose();

    _controller.removeListener(_onControllerChanged);
    _controller.dispose();

    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    try {
      final clientSession = await _controller.submit(
        roomNumber: _roomController.text,
        reservationName: _reservationController.text,
        peopleCountText: _peopleCountController.text,
      );

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ClientMenuPage(
            menu: widget.menu,
            clientSession: clientSession,
            placeOrderUC: widget.placeOrderUC,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Errore durante la creazione della sessione: $e',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4EF),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Benvenuto',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2E2E2E),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Inserisci i dati del soggiorno per continuare',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF6B6B6B),
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _roomController,
                        decoration: InputDecoration(
                          labelText: 'Numero camera',
                          filled: true,
                          fillColor: const Color(0xFFF8F3EC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: _controller.validateRoomNumber,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _reservationController,
                        decoration: InputDecoration(
                          labelText: 'Nome prenotazione',
                          filled: true,
                          fillColor: const Color(0xFFF8F3EC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: _controller.validateReservationName,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _peopleCountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Numero persone',
                          filled: true,
                          fillColor: const Color(0xFFF8F3EC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        validator: _controller.validatePeopleCount,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _controller.isSubmitting ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          backgroundColor: const Color(0xFFD8BFA3),
                          foregroundColor: const Color(0xFF2E2E2E),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        child: _controller.isSubmitting
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.4,
                                ),
                              )
                            : const Text(
                                'Continua',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}