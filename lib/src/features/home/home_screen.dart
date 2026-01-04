import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../export/export_screen.dart';
import '../preview/preview_screen.dart';
import 'providers/home_state.dart';
import 'widgets/music_section.dart';
import 'widgets/photo_section.dart';
import 'widgets/preview_button.dart';
import 'widgets/settings_section.dart';

/// Home screen for photo selection and project configuration.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeNotifierProvider);
    final notifier = ref.read(homeNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        title: const Text('Photo Sequence'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PhotoSection(
              photos: state.photos,
              isLoading: state.isPicking,
              onPickPhotos: notifier.pickPhotos,
              onRemovePhoto: notifier.removePhoto,
              onReorder: notifier.reorderPhotos,
            ),
            const SizedBox(height: 24),
            MusicSection(
              backgroundMusic: state.backgroundMusic,
              isLoading: state.isPicking,
              onPickMusic: notifier.pickMusic,
              onClearMusic: notifier.clearMusic,
            ),
            const SizedBox(height: 24),
            SettingsSection(
              transitionType: state.transitionType,
              imageDuration: state.imageDuration,
              transitionDuration: state.transitionDuration,
              onTransitionTypeChanged: notifier.setTransitionType,
              onImageDurationChanged: notifier.setImageDuration,
              onTransitionDurationChanged: notifier.setTransitionDuration,
            ),
            const SizedBox(height: 32),
            PreviewButton(
              canPreview: state.canPreview,
              totalDurationSeconds: state.project.totalDuration.inSeconds,
              onPressed: () => _openPreview(context, ref),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openPreview(BuildContext context, WidgetRef ref) async {
    final state = ref.read(homeNotifierProvider);
    if (!state.canPreview) return;

    final shouldExport = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => PreviewScreen(project: state.project),
      ),
    );

    if (shouldExport == true && context.mounted) {
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ExportScreen(project: state.project),
        ),
      );
    }
  }
}
