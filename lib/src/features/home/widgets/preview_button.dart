import 'package:flutter/material.dart';

/// Preview button at the bottom of home screen.
class PreviewButton extends StatelessWidget {
  const PreviewButton({
    super.key,
    required this.canPreview,
    required this.totalDurationSeconds,
    required this.onPressed,
  });

  final bool canPreview;
  final int totalDurationSeconds;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: canPreview ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        disabledBackgroundColor: Colors.white24,
        disabledForegroundColor: Colors.white54,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(canPreview ? Icons.play_arrow : Icons.photo_library_outlined),
          const SizedBox(width: 8),
          Text(
            canPreview
                ? 'Preview (${totalDurationSeconds}s)'
                : 'Select at least 3 photos',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
