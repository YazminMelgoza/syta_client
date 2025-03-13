import 'package:flutter/material.dart';

class CustomRowButton extends StatelessWidget {
  final IconData iconData;
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onTap;

  const CustomRowButton({
    Key? key,
    required this.iconData,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onTap, // Acción cuando se toca
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor, // Color de fondo
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              padding: const EdgeInsets.only(top: 14, bottom: 14, left: 0, right: 0),
              margin: const EdgeInsets.only(top: 15, bottom: 10, left: 0, right: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    iconData,
                    size: 24, // Tamaño del icono
                    color: textColor, // Color del icono
                  ),
                  Text(
                    text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
