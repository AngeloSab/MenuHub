import 'package:flutter/material.dart';

class VariationRow extends StatelessWidget {
  final bool isVisible;
  final String value;
  final VoidCallback onToggle;
  final ValueChanged<String> onChanged;

  const VariationRow({
    super.key,
    required this.isVisible,
    required this.value,
    required this.onToggle,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(999),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0E6DA),
              borderRadius: BorderRadius.circular(999),
            ),
            child: const Icon(
              Icons.edit_note_rounded,
              size: 18,
              color: Color(0xFF4A4036),
            ),
          ),
        ),
        if (isVisible) ...[
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              initialValue: value,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: 'Inserisci variazione',
                hintStyle: const TextStyle(
                  color: Color(0xFFB2AAA2),
                ),
                filled: true,
                fillColor: const Color(0xFFF8F3EC),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}