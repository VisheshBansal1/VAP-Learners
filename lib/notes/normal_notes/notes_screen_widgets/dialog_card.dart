import 'package:flutter/material.dart';

class DialogCard extends StatelessWidget {
  const DialogCard({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final media = MediaQuery.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: media.viewInsets.bottom + 16,
        ),
        child: Material(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          elevation: 12,
          shadowColor: Colors.black.withOpacity(0.4),
          child: Container(
            width: media.size.width * 0.85,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.colorScheme.onSurface.withOpacity(0.2),
                width: 1.5,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
