import 'package:flutter/material.dart';
import 'package:devbank/shared/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

enum ButtonType { filled, hollow }

class Custombutton extends StatelessWidget {
  const Custombutton(
      {super.key, required this.text, required this.type, this.onPressed});

  final String text;
  final ButtonType type;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 287,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          side: type == ButtonType.hollow
              ? const BorderSide(
                  color: AppColors.primary100,
                  width: 3.0,
                )
              : null,
          backgroundColor: type == ButtonType.hollow
              ? AppColors.neutral70
              : AppColors.primary100,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: onPressed,
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.lato(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: type == ButtonType.hollow
                  ? AppColors.primary100
                  : AppColors.neutral70,
            ),
          ),
        ),
      ),
    );
  }
}
