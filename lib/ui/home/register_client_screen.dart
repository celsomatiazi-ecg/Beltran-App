import 'dart:developer';

import 'package:beltran_adv/ui/utils/navigate_to_root.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:utils_tool_kit/utils_tool_kit.dart';

import '/data/models/client_model.dart';
import '/ui/app_components/custom_background_widget.dart';
import '/ui/app_components/dialog_information.dart';
import '/ui/app_constants/app_style.dart';
import '/ui/utils/loader.dart';
import '../../data/exceptions/exceptions.dart';
import '../app_controllers/client_controller.dart';

class RegisterClientScreen extends StatefulWidget {
  final bool showAppBar;

  const RegisterClientScreen({super.key, this.showAppBar = true});

  @override
  State<RegisterClientScreen> createState() => _RegisterClientScreenState();
}

class _RegisterClientScreenState extends State<RegisterClientScreen>
    with AppMessages, Loader, NavigateTo {
  final _formKey = GlobalKey<FormState>();
  final _cpfMask = MaskTextInputFormatter(mask: '###.###.###-##');
  final _phoneMask = MaskTextInputFormatter(mask: '(##)#####-####');

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) return "Campo obrigatório.";
    if (value.length < 5) return "Nome inválido";
    return null;
  }

  String? _cpfValidator(String? value) {
    if (value == null || value.isEmpty) return "Campo obrigatório.";
    if (_cpfMask.getMaskedText().length < 14 ||
        !CPFValidator.isValid(_cpfMask.getMaskedText())) {
      return "CPF inválido.";
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) return "Campo obrigatório.";
    if (!value.contains("@") && !value.contains(".")) return "E-mail inválido.";
    return null;
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.isEmpty) return "Campo obrigatório.";
    if (value.length != 14) return "Número de telefone inválido";
    return null;
  }

  void _validate() {
    if (_formKey.currentState!.validate()) {
      _saveClient();
    }
  }

  Future _saveClient() async {
    var ctrl = context.read<ClientController>();

    var client = ClientModel(
      name: _nameCtrl.text,
      cpf: _cpfMask.getUnmaskedText(),
      phone: _phoneMask.getUnmaskedText(),
      email: _emailCtrl.text,
    );

    try {
      showLoader();
      var result = await ctrl.saveClient(client).whenComplete(() {
        hideLoader();
      });
      _navigateTo(result["secret"]);
    } on TokenException {
      _expiredSessionDialog();
    } catch (e, s) {
      log("Save Client", error: e, stackTrace: s);
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

  void _navigateTo(String arguments) {
    Navigator.pushNamed(context, "/qr_code", arguments: arguments);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar ? AppBar() : null,

      body: CustomBackgroundWidget(
        topChild: SizedBox(
          width: context.screenWidth,
          child: Padding(
            padding: const EdgeInsets.all(20).copyWith(top: 0),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Adicionar cliente",
                  style: AppStyle.title.copyWith(color: Colors.white),
                ),
                Text(
                  "Insira os dados do cliente para futuros contatos, não se esqueça de validar a autenticação.",
                  style: AppStyle.body.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
        bottomChild: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text("Nome", style: AppStyle.titleLight),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _nameCtrl,
                        onTapOutside: (_) {
                          FocusScope.of(context).unfocus();
                        },
                        decoration: InputDecoration(
                          hintText: "Nome conpleto",
                          hintStyle: AppStyle.body.copyWith(
                            color: Colors.black54,
                          ),
                        ),
                        validator: _nameValidator,
                      ),

                      const SizedBox(height: 20),
                      Text("CPF", style: AppStyle.titleLight),
                      const SizedBox(height: 5),
                      TextFormField(
                        inputFormatters: [_cpfMask],
                        onTapOutside: (_) {
                          FocusScope.of(context).unfocus();
                        },
                        decoration: InputDecoration(
                          hintText: "000.000.000-00",
                          hintStyle: AppStyle.body.copyWith(
                            color: Colors.black54,
                          ),
                        ),
                        validator: _cpfValidator,
                      ),

                      const SizedBox(height: 20),
                      Text("Celular", style: AppStyle.titleLight),
                      const SizedBox(height: 5),
                      TextFormField(
                        inputFormatters: [_phoneMask],
                        onTapOutside: (_) {
                          FocusScope.of(context).unfocus();
                        },
                        decoration: InputDecoration(
                          hintText: "(00)00000-0000",
                          hintStyle: AppStyle.body.copyWith(
                            color: Colors.black54,
                          ),
                        ),
                        validator: _phoneValidator,
                      ),

                      const SizedBox(height: 20),
                      Text("E-mail", style: AppStyle.titleLight),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _emailCtrl,
                        onTapOutside: (_) {
                          FocusScope.of(context).unfocus();
                        },
                        decoration: InputDecoration(
                          hintText: "Digite seu e-mail",
                          hintStyle: AppStyle.body.copyWith(
                            color: Colors.black54,
                          ),
                        ),
                        validator: _emailValidator,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _validate,
              child: const Text("Gerar autenticador"),
            ),

            if (widget.showAppBar) const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
