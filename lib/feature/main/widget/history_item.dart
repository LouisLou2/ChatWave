import 'package:chat_wave/extension/widget_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget{
  const HistoryItem({
    required this.label,
    required this.imagePath,
    required this.color,
    super.key,
    this.onPressed,
  });
  final String label;
  final String imagePath;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.theme.colorScheme.surface,
          foregroundColor: color,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: context.theme.colorScheme.outlineVariant,
              width: 0.5,
            ),
          ),
          padding: const EdgeInsets.all(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: CupertinoColors.activeBlue.withOpacity(0.8),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  imagePath,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.theme.textTheme.bodyMedium?.copyWith(
                  color: context.theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: context.theme.colorScheme.onPrimaryContainer,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}