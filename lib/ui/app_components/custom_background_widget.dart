import 'package:flutter/material.dart';
import 'package:utils_tool_kit/utils_tool_kit.dart';

import '../app_constants/app_style.dart';

class CustomBackgroundWidget extends StatelessWidget {
  final Widget topChild;
  final Widget bottomChild;

  const CustomBackgroundWidget({
    super.key,
    required this.topChild,
    required this.bottomChild,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: context.screenWidth,
        height: context.screenHeight,
        color: AppStyle.primaryColor,
        child: SafeArea(
          bottom: false,
          child: Column(
            spacing: 10,
            children: [
              topChild,

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: context.screenWidth,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                    ),
                  ),
                  child: bottomChild,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
