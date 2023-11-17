import 'package:flutter/material.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final IconData icon;
  final Function()? onPressed;

  const ElevatedButtonWidget({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Icon(icon),
    );
  }
}
