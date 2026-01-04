import 'package:flutter/material.dart';

/// Button to add more photos.
class AddPhotoButton extends StatelessWidget {
  const AddPhotoButton({
    super.key,
    required this.isDisabled,
    required this.isEmpty,
    required this.onTap,
  });

  final bool isDisabled;
  final bool isEmpty;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDisabled ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white24, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              color: isDisabled ? Colors.white24 : Colors.white54,
            ),
            const SizedBox(width: 8),
            Text(
              isEmpty ? 'Select Photos' : 'Add More',
              style: TextStyle(
                color: isDisabled ? Colors.white24 : Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
