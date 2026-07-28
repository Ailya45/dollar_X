import 'package:dollar_x_app/presentation/constants/colors.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class SwapDivider extends StatelessWidget {
  final VoidCallback onSwap;

  const SwapDivider({super.key, required this.onSwap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          const Expanded(
            child: Divider(
              color: Colors.white12,
              thickness: 0.5,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 0.5,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: onSwap,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Transform.rotate(
                    angle: pi / 2,
                    child: Icon(
                      Icons.swap_vert_rounded,
                      size: 20,
                      color: AppColors.primary.withValues(alpha: 0.7),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Expanded(
            child: Divider(
              color: Colors.white12,
              thickness: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
