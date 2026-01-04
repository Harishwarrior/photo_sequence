import 'package:flutter/material.dart';

/// Duration setting with increment/decrement buttons.
class DurationSetting extends StatelessWidget {
  const DurationSetting({
    super.key,
    required this.label,
    required this.value,
    required this.minSeconds,
    required this.maxSeconds,
    required this.stepMs,
    required this.onChanged,
  });

  final String label;
  final Duration value;
  final double minSeconds;
  final double maxSeconds;
  final int stepMs;
  final void Function(Duration) onChanged;

  @override
  Widget build(BuildContext context) {
    final canDecrement = value.inMilliseconds > (minSeconds * 1000);
    final canIncrement = value.inMilliseconds < (maxSeconds * 1000);
    final displayValue = value.inMilliseconds / 1000;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove, color: Colors.white54),
              onPressed: canDecrement
                  ? () => onChanged(
                      Duration(milliseconds: value.inMilliseconds - stepMs),
                    )
                  : null,
            ),
            Text(
              '${displayValue}s',
              style: const TextStyle(color: Colors.white),
            ),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.white54),
              onPressed: canIncrement
                  ? () => onChanged(
                      Duration(milliseconds: value.inMilliseconds + stepMs),
                    )
                  : null,
            ),
          ],
        ),
      ],
    );
  }
}
