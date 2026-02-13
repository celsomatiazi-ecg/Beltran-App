import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utils_tool_kit/utils_tool_kit.dart';

import '/ui/app_components/custom_background_widget.dart';
import '/ui/app_components/dialog_information.dart';
import '/ui/app_constants/app_style.dart';
import '/ui/home/components/client_box_widget.dart';
import '/ui/utils/loader.dart';
import '/ui/utils/navigate_to_root.dart';
import '../../data/exceptions/exceptions.dart';
import '../app_controllers/client_controller.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({super.key});

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage>
    with AppMessages, Loader, NavigateTo {
  final _searchCtrl = TextEditingController();
  final ValueNotifier<bool> _fieldIsEmpty = ValueNotifier<bool>(true);

  void _toggleSearchIcon(String text) {
    if (text.isEmpty) _fieldIsEmpty.value = true;
    if (text.isNotEmpty) _fieldIsEmpty.value = false;
    var ctrl = context.read<ClientController>();
    ctrl.updateClientsBySearch(text);
  }

  Future<void> _getClients() async {
    var ctrl = context.read<ClientController>();
    try {
      showLoader();
      await ctrl.getClients().whenComplete(() {
        hideLoader();
      });
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
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getClients();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchCtrl.dispose();
    _fieldIsEmpty.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundWidget(
      topChild: Padding(
        padding: const EdgeInsets.all(20).copyWith(top: 0),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Clientes",
              style: AppStyle.title.copyWith(color: Colors.white),
            ),
            Text(
              "Gerencie sua carteira, para acessar código de autenticação acesse o perfil do cliente.",
              style: AppStyle.body.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),

      bottomChild: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: _fieldIsEmpty,
            builder: (context, value, child) {
              return TextField(
                controller: _searchCtrl,
                onChanged: _toggleSearchIcon,
                onTapOutside: (_) {
                  FocusScope.of(context).unfocus();
                },
                decoration: InputDecoration(
                  suffixIcon: InkWell(
                    onTap: () {
                      if (!value) {
                        _searchCtrl.clear();
                        _fieldIsEmpty.value = true;
                        var ctrl = context.read<ClientController>();
                        ctrl.updateClientsBySearch("");
                      }
                    },
                    child: Icon(value ? Icons.search : Icons.close),
                  ),
                  hintText: "Buscar cliente",
                ),
              );
            },
          ),

          const SizedBox(height: 10),

          Consumer<ClientController>(
            builder: (context, ctrl, _) {
              return Expanded(
                child: ListView.builder(
                  itemCount: ctrl.clients.length,
                  itemBuilder: (context, index) {
                    return ClientBoxWidget(client: ctrl.clients[index]);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
