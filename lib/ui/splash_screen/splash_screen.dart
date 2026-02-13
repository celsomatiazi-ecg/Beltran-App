import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utils_tool_kit/utils_tool_kit.dart';

import '/ui/app_constants/app_assets.dart';
import '/ui/app_constants/app_style.dart';
import '../app_controllers/local_auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late LocalAuthController controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startLocalAuthService();
    });
  }

  Future<void> _startLocalAuthService() async {
    controller = context.read<LocalAuthController>();
    await controller.getLocalAuthStatus();
    if (controller.localAuthStatus) {
      controller.addListener(_onStateChanged);
      controller.init();
    } else {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/auth_options');
      }
    }
  }

  void _onStateChanged() {
    if (!mounted) return;
    switch (controller.state) {
      case LocalAuthState.goHome:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case LocalAuthState.goLogin:
        Navigator.pushReplacementNamed(context, '/auth_options');
        break;
      case LocalAuthState.loading:
        break;
    }
  }

  @override
  void dispose() {
    controller.removeListener(_onStateChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: context.screenHeight,
        width: context.screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 60),
            Image.asset(AppAssets.logo),
            SizedBox(height: 40),
            CircularProgressIndicator(color: AppStyle.secondaryColor),
            SizedBox(height: 10),
            Text("Carregando..."),
          ],
        ),
      ),
    );
  }
}
