import 'package:chat_wave/extension/widget_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  const CardButton({
    required this.title,
    required this.imagePath,
    required this.color,
    required this.onPressed,
    required this.isMainButton,
    this.foregroundColor,
    super.key,
  });
  final String title;
  final String imagePath;
  final Color color;
  final Color? foregroundColor;
  final VoidCallback onPressed;
  final bool isMainButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 16,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child:ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(16),
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor:
                  Colors.white.withOpacity(0.4),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Image.asset(
                      imagePath,
                      color: context.theme.colorScheme.background,
                    ),
                  ),
                ),
                Icon(
                  CupertinoIcons.forward,
                  color: foregroundColor ?? context.theme.colorScheme.background,
                  size: 32,
                ),
              ],
            ),
            SizedBox(
              height: isMainButton ? 64 : 14,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                title,
                style: context.theme.textTheme.bodyLarge!.copyWith(
                  color: foregroundColor ?? context.theme.colorScheme.background,
                  fontSize: isMainButton ? 32 : 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}