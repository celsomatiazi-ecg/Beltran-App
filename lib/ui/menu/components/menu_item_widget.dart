import 'package:flutter/material.dart';

import '../../app_constants/app_style.dart';

class MenuItemWidget extends StatelessWidget {
  final String title;
  final Widget icon;
  final VoidCallback onClick;

  const MenuItemWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        onTap: onClick,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              spacing: 10,
              children: [
                icon,
                Expanded(child: Text(title, style: AppStyle.titleLight)),
                const Icon(Icons.arrow_forward_ios, size: 18),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(height: 0),
          ],
        ),
      ),
    );
  }
}
