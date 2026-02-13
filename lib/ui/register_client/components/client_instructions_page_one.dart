import 'package:beltran_adv/ui/app_controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utils_tool_kit/utils_tool_kit.dart';

import '../../app_constants/app_assets.dart';
import '../../app_constants/app_style.dart';

class ClientInstructionsPageOne extends StatelessWidget {
  const ClientInstructionsPageOne({super.key});

  @override
  Widget build(BuildContext context) {
    var ctrl = context.read<UserController>();
    return SizedBox(
      width: context.screenWidth,
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Image.asset(AppAssets.logo)),
          Text(
            "Olá, Dr(a) ${ctrl.userData?.name}.",
            style: AppStyle.titleLight,
          ),
          Text(
            "Nossa missão é garantir que sua comunicação com cada cliente seja sempre autêntica e protegida contra fraudes.  Para estabelecer essa conexão segura, precisaremos integrar seu cliente ao nosso sistema. É um processo simples e feito uma única vez. Estou aqui para te guiar em cada passo.",
            style: AppStyle.body,
          ),
        ],
      ),
    );
  }
}
