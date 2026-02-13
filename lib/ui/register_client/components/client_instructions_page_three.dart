import 'package:flutter/material.dart';
import 'package:utils_tool_kit/utils_tool_kit.dart';

import '/ui/app_constants/app_assets.dart';
import '../../app_constants/app_style.dart';

class ClientInstructionsPageThree extends StatelessWidget {
  const ClientInstructionsPageThree({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth,
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Passo 2: A Conexão", style: AppStyle.titleLight),
          Text(
            "Após cadastrar um novo cliente,  vamos gerar um QR Code, como este do exemplo.",
            style: AppStyle.body,
          ),

          Image.asset(AppAssets.qrCode),

          // ignore: prefer_const_constructors
          Text(
            """I- Peça para seu cliente abrir o Google Authenticator, tocar no + e escolher 'Ler um código QR'.\n
II- Quando ele apontar a câmera do celular dele para a sua tela suas contas estarão conectadas instantaneamente.""",
          ),
        ],
      ),
    );
  }
}
