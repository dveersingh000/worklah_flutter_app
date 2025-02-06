import 'package:flutter/material.dart';
import 'package:work_lah/utility/colors.dart';

class DashedDivider extends StatelessWidget {
  const DashedDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        150 ~/ 2,
        (index) => Expanded(
          child: Container(
            color: index % 2 == 0
                ? Colors.transparent
                : AppColors.lightBorderColor,
            height: 1,
          ),
        ),
      ),
    );
  }
}
