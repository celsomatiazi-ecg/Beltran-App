import 'package:beltran_adv/ui/app_controllers/local_auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utils_tool_kit/utils_tool_kit.dart';

import '/ui/app_constants/app_assets.dart';
import '/ui/app_constants/app_style.dart';

class DeviceAuth extends StatelessWidget {
  const DeviceAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: context.screenWidth,
        height: context.screenHeight,
        child: Padding(
          padding: const EdgeInsets.all(20).copyWith(bottom: 40),
          child: Column(
            spacing: 10,
            children: [
              const Spacer(),
              Image.asset(AppAssets.faceId),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Agora, vamos deixar sua conta mais segura",
                  textAlign: TextAlign.center,
                  style: AppStyle.title,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Ative a autenticação ou senha do seu celular para entrar na EasyChange de forma segura",
                  textAlign: TextAlign.center,
                  style: AppStyle.body.copyWith(fontSize: 16),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  var ctrl = context.read<LocalAuthController>();
                  ctrl.saveLocalAuthStatus(true);
                  Navigator.pushNamed(context, "/home");
                },
                child: const Text("Usar autenticação do celular"),
              ),

              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/home");
                },
                child: const Text("Pular, farei depois"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
