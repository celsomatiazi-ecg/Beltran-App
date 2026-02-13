import 'package:flutter/material.dart';
import 'package:utils_tool_kit/utils_tool_kit.dart';

import '../app_constants/app_assets.dart';

class CustomAppBarWidget extends StatelessWidget {
  const CustomAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(AppAssets.logo, height: 87),
          Positioned(
            top: 10,
            left: 15,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
