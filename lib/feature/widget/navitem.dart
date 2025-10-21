import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class _NavItem extends StatelessWidget {
  final String svgPath;
  final String label;
  final bool active;

  const _NavItem({
    Key? key,
    required this.svgPath,
    required this.label,
    this.active = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          svgPath,
          color: active ? Colors.blue : Colors.grey,
          width: 24,
          height: 24,
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            color: active ? Colors.blue : Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
