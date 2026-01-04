import 'dart:io';

import 'package:flutter/material.dart';

/// Background music selection section.
class MusicSection extends StatelessWidget {
  const MusicSection({
    super.key,
    required this.backgroundMusic,
    required this.isLoading,
    required this.onPickMusic,
    required this.onClearMusic,
  });

  final File? backgroundMusic;
  final bool isLoading;
  final VoidCallback onPickMusic;
  final VoidCallback onClearMusic;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Background Music',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Optional audio track',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: backgroundMusic == null && !isLoading ? onPickMusic : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white54,
                      ),
                    )
                  : Icon(
                      backgroundMusic != null
                          ? Icons.music_note
                          : Icons.music_note_outlined,
                      color: backgroundMusic != null
                          ? Colors.green
                          : Colors.white54,
                    ),
              title: Text(
                isLoading
                    ? 'Loading...'
                    : backgroundMusic != null
                    ? backgroundMusic!.path.split('/').last
                    : 'Tap to select music',
                style: TextStyle(
                  color: backgroundMusic != null
                      ? Colors.white
                      : Colors.white54,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              trailing: backgroundMusic != null && !isLoading
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white54),
                          onPressed: onClearMusic,
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.folder_open,
                            color: Colors.white54,
                          ),
                          onPressed: onPickMusic,
                        ),
                      ],
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
