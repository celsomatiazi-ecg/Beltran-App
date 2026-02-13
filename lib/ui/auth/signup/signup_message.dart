import 'package:flutter/material.dart';
import 'package:utils_tool_kit/utils_tool_kit.dart';

import '/ui/app_constants/app_assets.dart';
import '/ui/app_constants/app_style.dart';

class SignupMessage extends StatelessWidget {
  const SignupMessage({super.key});

  @override
  Widget build(BuildContext context) {
    var isSignup = ModalRoute.of(context)!.settings.arguments as bool;

    return Scaffold(
      body: SizedBox(
        width: context.screenWidth,
        height: context.screenHeight,
        child: Padding(
          padding: const EdgeInsets.all(20.0).copyWith(bottom: 40),
          child: Column(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(AppAssets.checkIcon),
              if (isSignup)
                Text("Conta criada com sucesso!", style: AppStyle.title),
              if (!isSignup)
                Text("Senha atualizada com sucesso!", style: AppStyle.title),
              Text(
                "Agora é só acessar o app e começar a usar.",
                textAlign: TextAlign.center,
                style: AppStyle.titleLight,
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/auth_login");
                },
                child: const Text("Acessar app"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
