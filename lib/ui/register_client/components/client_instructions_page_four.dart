import 'package:flutter/material.dart';
import 'package:utils_tool_kit/utils_tool_kit.dart';

import '/ui/app_constants/app_assets.dart';
import '../../app_constants/app_style.dart';

class ClientInstructionsPageFour extends StatelessWidget {
  const ClientInstructionsPageFour({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth,
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Passo 3: A Educação", style: AppStyle.titleLight),
          Text(
            "Esta é a parte mais importante. Mostre a ele como os códigos de 6 dígitos mudam a cada 30 segundos, tanto na sua tela quanto na dele.",
            style: AppStyle.body,
          ),

          Image.asset(AppAssets.code),
          Text(
            """I-O advogado sempre inicia a validação fornecendo o código. \n 
II- Para maior segurança o cliente nunca deve fornecer o código para o advogado para evitar golpes.""",
          ),
        ],
      ),
    );
  }
}
