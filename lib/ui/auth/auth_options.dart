import 'package:flutter/material.dart';
import 'package:utils_tool_kit/utils_tool_kit.dart';

import '/ui/app_constants/app_assets.dart';

class AuthOptions extends StatefulWidget {
  const AuthOptions({super.key});

  @override
  State<AuthOptions> createState() => _AuthOptionsState();
}

class _AuthOptionsState extends State<AuthOptions> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //_navigateTo();
    });
  }

  // _navigateTo() async {
  //   var authCtrl = context.read<AuthController>();
  //   await authCtrl.getLocalTokens();
  //   if (authCtrl.currentTokens!.accessToken.isNotEmpty && mounted) {
  //     if (mounted) Navigator.pushReplacementNamed(context, "/home");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: context.screenWidth,
        height: context.screenHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.background),
            fit: BoxFit.cover,
          ),
        ),

        child: Column(
          spacing: 40,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(AppAssets.logo),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              width: context.screenWidth,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                spacing: 10,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/signup_person_data");
                    },
                    child: const Text("Criar conta"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/auth_login");
                    },
                    child: const Text("Entrar"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
