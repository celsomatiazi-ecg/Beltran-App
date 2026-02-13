import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utils_tool_kit/utils_tool_kit.dart';

import '/ui/app_controllers/user_controller.dart';
import '../app_constants/app_assets.dart';
import '../app_constants/app_style.dart';
import '../app_controllers/auth_controller.dart';
import '../menu/components/menu_item_widget.dart';
import '../utils/loader.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> with Loader {
  Future<void> _logout() async {
    showLoader();
    var authCtrl = context.read<AuthController>();
    await authCtrl.logout().whenComplete(() {
      hideLoader();
    });
    _navigateToAuthOptions();
  }

  void _navigateToAuthOptions() {
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        "/auth_options",
        ModalRoute.withName("/"),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.screenWidth,
      height: context.screenHeight,
      color: Colors.white,
      child: Column(
        children: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                padding: EdgeInsets.all(20).copyWith(bottom: 0),
                alignment: Alignment.centerLeft,
                width: context.screenWidth,
                color: AppStyle.primaryColor,
                child: Row(
                  spacing: 10,
                  children: [
                    SafeArea(child: Image.asset(AppAssets.logo, width: 100)),
                    Expanded(
                      child: Consumer<UserController>(
                        builder: (context, ctrl, _) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              Text(
                                "Olá ${ctrl.userData?.name}",
                                style: AppStyle.labelButton.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                "OAB ${ctrl.userData?.oab}",
                                style: AppStyle.labelButton.copyWith(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SafeArea(
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          MenuItemWidget(
            title: "Dados cadastrais",
            icon: const Icon(Icons.person_2_outlined),
            onClick: () {
              Navigator.pushNamed(context, "/registration_data");
            },
          ),

          // MenuItemWidget(
          //   title: "Notificações",
          //   icon: const Icon(Icons.notifications_none),
          //   onClick: () {
          //     Navigator.pushNamed(context, "/notifications");
          //   },
          // ),
          MenuItemWidget(
            title: "Segurança e privacidade",
            icon: const Icon(Icons.lock_open),
            onClick: () {
              Navigator.pushNamed(context, "/security_privacy");
            },
          ),

          MenuItemWidget(
            title: "Termos e condições",
            icon: const Icon(Icons.sticky_note_2_outlined),
            onClick: () {
              Navigator.pushNamed(context, "/terms_conditions");
            },
          ),

          MenuItemWidget(
            title: "Sair",
            icon: const Icon(Icons.exit_to_app),
            onClick: _logout,
          ),
        ],
      ),
    );
  }
}
