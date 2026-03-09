import 'package:flutter/material.dart';

class ConfirmOrderDialog extends StatelessWidget {
  const ConfirmOrderDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      title: const Text(
        'Conferma ordine',
        style: TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
      content: const Text(
        'Vuoi confermare il tuo ordine?',
        style: TextStyle(
          fontSize: 15,
          color: Color(0xFF5C5C5C),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text(
            'Annulla',
            style: TextStyle(
              color: Color(0xFF6B6B6B),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD8BFA3),
            foregroundColor: const Color(0xFF2E2E2E),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: const Text(
            'Conferma',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}