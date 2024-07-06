import 'package:flutter/material.dart';

class CartBadge extends StatelessWidget {
  final Widget child;
  final String value;
  final Color color;

  const CartBadge(
      {super.key,
      required this.value,
      required this.child,
      this.color = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.all(2.0),
            constraints: const BoxConstraints(maxWidth: 16, minHeight: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              // shape: BoxShape.circle,
              color:
                  (color == Colors.blue) ? Theme.of(context).hintColor : color,
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
              ),
            ),
          ),
        )
      ],
    );
  }
}
