import 'package:beltran_adv/ui/app_controllers/local_auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/ui/app_constants/app_style.dart';

class SecurityPrivacyScreen extends StatefulWidget {
  const SecurityPrivacyScreen({super.key});

  @override
  State<SecurityPrivacyScreen> createState() => _SecurityPrivacyScreenState();
}

class _SecurityPrivacyScreenState extends State<SecurityPrivacyScreen> {
  Future<void> _updateLocalAuthStatus(bool status) async {
    var authCtrl = context.read<LocalAuthController>();
    authCtrl.saveLocalAuthStatus(status);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Segurança e privacidade")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            MenuItemWidget(
              onTap: () {
                Navigator.pushNamed(context, "/change_password");
              },
              icon: const Icon(Icons.key),
              title: "Altere sua senha",
              rightIcon: const Icon(Icons.arrow_forward_ios, size: 18),
            ),

            MenuItemWidget(
              icon: const Icon(Icons.remember_me),
              title: "Altenticação do celular",
              verticalSpace: 5,
              rightIcon: Transform.scale(
                scale: .8,
                child: Consumer<LocalAuthController>(
                  builder: (context, ctrl, _) {
                    return Switch(
                      padding: EdgeInsets.zero,
                      value: ctrl.localAuthStatus,
                      onChanged: _updateLocalAuthStatus,
                    );
                  },
                ),
              ),
            ),

            MenuItemWidget(
              onTap: () {
                Navigator.pushNamed(context, "/delete_account");
              },
              icon: const Icon(Icons.delete_outline),
              title: "Excluir conta",
              rightIcon: const Icon(Icons.arrow_forward_ios, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItemWidget extends StatelessWidget {
  final String title;
  final Widget icon;
  final Widget rightIcon;
  final double verticalSpace;
  final VoidCallback? onTap;

  const MenuItemWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.rightIcon,
    this.verticalSpace = 17,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          SizedBox(height: verticalSpace),
          Row(
            spacing: 5,
            children: [
              icon,
              Expanded(child: Text(title, style: AppStyle.titleLight)),
              rightIcon,
            ],
          ),
          SizedBox(height: verticalSpace),
          const Divider(height: 0),
        ],
      ),
    );
  }
}
