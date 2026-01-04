import 'package:flutter/material.dart';

import '../../domain/transition_type.dart';
import 'duration_setting.dart';
import 'transition_type_setting.dart';

/// Settings section for transition and duration configuration.
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.transitionType,
    required this.imageDuration,
    required this.transitionDuration,
    required this.onTransitionTypeChanged,
    required this.onImageDurationChanged,
    required this.onTransitionDurationChanged,
  });

  final TransitionType transitionType;
  final Duration imageDuration;
  final Duration transitionDuration;
  final void Function(TransitionType) onTransitionTypeChanged;
  final void Function(Duration) onImageDurationChanged;
  final void Function(Duration) onTransitionDurationChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TransitionTypeSetting(
                value: transitionType,
                onChanged: onTransitionTypeChanged,
              ),
              const Divider(color: Colors.white12),
              DurationSetting(
                label: 'Photo Duration',
                value: imageDuration,
                minSeconds: 2,
                maxSeconds: 10,
                stepMs: 1000,
                onChanged: onImageDurationChanged,
              ),
              const Divider(color: Colors.white12),
              DurationSetting(
                label: 'Transition Duration',
                value: transitionDuration,
                minSeconds: 0.5,
                maxSeconds: 2.0,
                stepMs: 500,
                onChanged: onTransitionDurationChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
