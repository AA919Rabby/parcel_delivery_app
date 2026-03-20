import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class CustomText extends StatelessWidget {
  final String labelText;
  final String hintText;
  final Widget? prefixIcon;
  final Icon? suffixIcon;
  final bool obscureText;
  final VoidCallback? onSuffixTap;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;

  const CustomText({
    super.key,
    required this.labelText,
    this.onSuffixTap,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      validator: validator,
      onTap: onTap,
      style:  GoogleFonts.numans(
        color: Colors.black,
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon != null
            ? IconButton(
          icon: suffixIcon!,
          onPressed: onSuffixTap,
        )
            : null,
        labelStyle: const TextStyle(color: Colors.black),
        floatingLabelStyle: TextStyle(color: Colors.black),
        hintStyle:GoogleFonts.numans(color: Colors.black),
      ),
    );
  }
}