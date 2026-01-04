import 'package:flutter/material.dart';

import '../../../core/models/transition_type.dart';

/// Transition type dropdown setting.
class TransitionTypeSetting extends StatelessWidget {
  const TransitionTypeSetting({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final TransitionType value;
  final void Function(TransitionType) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Transition', style: TextStyle(color: Colors.white)),
        DropdownButton<TransitionType>(
          value: value,
          dropdownColor: const Color(0xFF2A2A2A),
          style: const TextStyle(color: Colors.white),
          underline: const SizedBox(),
          items: TransitionType.values.map((type) {
            return DropdownMenuItem(value: type, child: Text(type.displayName));
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) onChanged(newValue);
          },
        ),
      ],
    );
  }
}
