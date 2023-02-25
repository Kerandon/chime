import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../configs/app_colors.dart';
import '../configs/constants.dart';

class CustomAnimatedGridBox extends ConsumerWidget {
  const CustomAnimatedGridBox({
    required this.labelText,
    required this.onPressed,
    required this.isSelected,
    required this.contents,
    this.selectedLabelColor,
    super.key,
  });

  final String labelText;
  final VoidCallback? onPressed;
  final bool isSelected;
  final Widget contents;
  final Color? selectedLabelColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    return ClipRRect(
      borderRadius: BorderRadius.circular(kBorderRadius),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Stack(
            children: [
              Center(
                child: AnimatedContainer(
                  width: isSelected ? size.width * 0.50 : size.width * 0.45,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOutCubic,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(kBorderRadius),
                    border: Border.all(
                      color: isSelected
                          //colorTheme == state.colorTheme
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(size.width * 0.01),
                    child: contents,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(size.width * 0.05),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(kBorderRadius),
                      color: isSelected
                          ? selectedLabelColor ?? Theme.of(context).primaryColor
                          : AppColors.grey.withOpacity(0.50)),
                  child: Padding(
                    padding: EdgeInsets.all(size.width * 0.01),
                    child: Text(
                      labelText,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: kFadeInTimeMilliseconds.milliseconds * 2)
        .scaleXY(begin: 0.90);
  }
}
