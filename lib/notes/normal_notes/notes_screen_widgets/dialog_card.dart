import 'package:flutter/material.dart';

class DialogCard extends StatelessWidget {
  const DialogCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: MediaQuery.viewInsetsOf(context),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: [
            BoxShadow(
              offset: Offset(8, 8),
              blurRadius: 12,
              spreadRadius: 1,
              color: Colors.black.withOpacity(0.4),
            ),
          ],
        ),

        width: MediaQuery.of(context).size.width * 0.75,
        padding: const EdgeInsets.all(16.0),

        clipBehavior: Clip.antiAlias,
        child: Material(
          borderRadius: BorderRadius.circular(12),

          child: child,
        ),
      ),
    );
  }
}
