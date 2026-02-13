import 'package:beltran_adv/ui/app_controllers/client_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/data/models/client_model.dart';
import '../../app_constants/app_style.dart';

class ClientBoxWidget extends StatelessWidget {
  final ClientModel client;

  const ClientBoxWidget({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        var ctrl = context.read<ClientController>();
        ctrl.addClientIdToRecent(client.id!);
        Navigator.pushNamed(context, "/client_detail", arguments: client);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xffFBFBFB),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(client.name, style: AppStyle.titleLight),
                  Text("Nº ${client.cpf}", style: AppStyle.body),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}
