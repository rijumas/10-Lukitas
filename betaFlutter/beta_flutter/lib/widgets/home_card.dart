import 'package:flutter/material.dart';

class HomeCard extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const HomeCard({super.key, required this.text, this.onPressed});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFFd47c69), // Cambia aquí el color
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
