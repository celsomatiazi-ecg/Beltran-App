import 'package:flutter/material.dart';
import 'package:utils_tool_kit/utils_tool_kit.dart';

import '/ui/app_constants/app_assets.dart';
import '../../app_constants/app_style.dart';

class ClientInstructionsPageTwo extends StatelessWidget {
  const ClientInstructionsPageTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth,
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Passo 1: A Instalação", style: AppStyle.titleLight),
          Text(
            "Sua primeira missão é ajudar seu cliente a instalar o Google Authenticator.",
            style: AppStyle.body,
          ),

          Image.asset(AppAssets.playStore),

          // ignore: prefer_const_constructors
          Text(
            """I- Peça para ele abrir a loja de aplicativos (App Store ou Play Store) e buscar por esse nome.\n 
II- Acompanhe a instalação para garantir que ele baixe o aplicativo oficial do Google.\n
III- Assim que ele confirmar, estaremos prontos para o próximo passo.""",
          ),
        ],
      ),
    );
  }
}
