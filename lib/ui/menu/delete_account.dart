import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utils_tool_kit/utils_tool_kit.dart';

import '/data/exceptions/exceptions.dart';
import '/ui/app_constants/app_style.dart';
import '/ui/app_controllers/user_controller.dart';
import '/ui/utils/navigate_to_root.dart';
import '../app_components/dialog_information.dart';
import '../utils/loader.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount>
    with AppMessages, Loader, NavigateTo {
  void _showDeleteAccountDialog() {
    showCustomDialog(
      children: [
        Material(
          color: Colors.white,
          child: Column(
            children: [
              Text(
                "Tem certeza que deseja excluir a conta?",
                textAlign: TextAlign.center,
                style: AppStyle.titleLight,
              ),
              const SizedBox(height: 20),
              Text(
                "Não será possível reverter a exclusão.",
                style: AppStyle.body,
              ),

              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _deleteAccount,
                child: const Text("Excluir"),
              ),

              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Voltar"),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _deleteAccount() async {
    var ctrl = context.read<UserController>();
    try {
      showLoader();
      await ctrl.deleteAccount().whenComplete(() {
        hideLoader();
      });
      navigateTo("/auth_options");
    } on TokenException {
      _expiredSessionDialog();
    } catch (e) {
      showCustomDialog(
        children: [
          DialogInformationWidget(message: e.toString(), title: "Beltran"),
        ],
      );
    }
  }

  void _expiredSessionDialog() {
    showCustomDialog(
      children: [
        DialogInformationWidget(
          message: "Sua sessão expirou, por favor faça login novamente",
          title: "Beltran",
        ),
      ],
    ).then((_) {
      navigateTo("/auth_login");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Excluir conta")),

      body: Padding(
        padding: const EdgeInsets.all(20).copyWith(bottom: 40),
        child: Column(
          spacing: 20,
          children: [
            Text(
              "Tem certeza que deseja excluir sua conta? Ao excluir sua conta, você:",
              style: AppStyle.titleLight.copyWith(fontWeight: FontWeight.w400),
            ),

            const SizedBox(height: 5),

            const ItemWidget(
              content: "Perderá sua carteira de clientes cadastradas!",
            ),

            const ItemWidget(
              content: "Não poderá validar a identidade com seus clientes.",
            ),

            const ItemWidget(
              content:
                  "Caso tenha um plano cadastrado não será possível reaver a conta com plano ativo.",
            ),

            const ItemWidget(
              content:
                  "Caso tenha um plano ativo, as cobranças continuarão até o fim do contrato de 1 ano.",
            ),

            const Spacer(),

            ElevatedButton(
              onPressed: _showDeleteAccountDialog,
              child: const Text("Excluir conta"),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemWidget extends StatelessWidget {
  final String content;

  const ItemWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          spacing: 10,
          children: [
            const Icon(Icons.close, color: Colors.red, size: 22),
            Expanded(child: Text(content, style: AppStyle.body)),
          ],
        ),
        const SizedBox(height: 20),
        const Divider(height: 0),
      ],
    );
  }
}
