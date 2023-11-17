import 'package:flutter/material.dart';

import '../helpers/text_button_style.dart';

class IconButtonWidget extends StatelessWidget {
  final IconData icon;
  final Function()? onPressed;
  final String tooltip;
  final String textButton;

  const IconButtonWidget({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
    required this.textButton,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: const Color.fromARGB(255, 29, 0, 158)),
          onPressed: onPressed,
          tooltip: tooltip,
        ),
        Text(textButton, style: textIconButtonStyle)
      ],
    );
  }
}
