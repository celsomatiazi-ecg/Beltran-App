import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utils_tool_kit/utils_tool_kit.dart';

import '/ui/app_constants/app_assets.dart';
import '/ui/app_controllers/client_controller.dart';
import '../app_components/custom_background_widget.dart';
import '../app_constants/app_style.dart';
import '../app_controllers/user_controller.dart';
import 'components/client_box_widget.dart';

class HomePageWidget extends StatelessWidget {
  const HomePageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundWidget(
      topChild: Consumer<UserController>(
        builder: (context, ctrl, _) {
          return Column(
            children: [
              Container(
                width: 126,
                height: 126,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Image.asset(AppAssets.logo, fit: BoxFit.cover),
              ),

              const SizedBox(height: 20),
              Text(
                "Beltran Advogados",
                style: AppStyle.titleLight.copyWith(color: Colors.white),
              ),

              const SizedBox(height: 5),
              Text(
                ctrl.userData?.name ?? "",
                style: AppStyle.body.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 188,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/register_client");
                  },
                  child: const Text("Cadastrar cliente"),
                ),
              ),
              const SizedBox(height: 20),
            ],
          );
        },
      ),
      bottomChild: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Clientes recentes", style: AppStyle.title),

          Consumer<ClientController>(
            builder: (context, ctrl, _) {
              return Expanded(
                child: ctrl.recentClients.isEmpty
                    ? ClientEmptyStateWidget()
                    : ListView.builder(
                        itemCount: ctrl.recentClients.length,
                        itemBuilder: (context, index) {
                          return ClientBoxWidget(
                            client: ctrl.recentClients[index],
                          );
                        },
                      ),
              );
            },
          ),

          //const ClientBoxWidget(),
        ],
      ),
    );
  }
}

class ClientEmptyStateWidget extends StatelessWidget {
  const ClientEmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.screenWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 40, color: Colors.black26),
          Text(
            "Nenhum cliente recente",
            style: AppStyle.body.copyWith(color: Colors.black26),
          ),
        ],
      ),
    );
  }
}
