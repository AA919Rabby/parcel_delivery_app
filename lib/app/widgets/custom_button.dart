import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  String label;
  Color color;
  Color? labelColor;
  VoidCallback? onTap;
  VoidCallback? onPressed;

  CustomButton({
    required this.color,
    required this.label,
    this.onTap,
    this.onPressed,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed ?? onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 46),
        maximumSize: const Size(double.infinity, 46),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 2, // You can adjust or set to 0 if you want it completely flat
        padding: EdgeInsets.zero,
      ),
      child: Text(
        label,
        style: GoogleFonts.numans(
          color: labelColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}


