import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RoundTile extends StatelessWidget {
  final String svgPath;
  final double iconSize;
  final Function()? onTap;

  const RoundTile({
    Key? key,
    required this.svgPath,
    required, this.onTap,
    this.iconSize = 80,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: iconSize + 16,
        height: iconSize + 16,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SvgPicture.asset(
              svgPath,
              fit: BoxFit.contain,
              width: iconSize,
              height: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
