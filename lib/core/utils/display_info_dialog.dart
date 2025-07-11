import 'package:flutter/material.dart';

void displayInfoDialog({
  required BuildContext context,
  required String title,
  required Widget content,
}) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: Text(title),
          content: content,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
  );
}
