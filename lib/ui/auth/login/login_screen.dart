import 'dart:developer';

import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:utils_tool_kit/utils_tool_kit.dart';

import '/ui/app_components/custom_app_bar.dart';
import '/ui/app_constants/app_style.dart';
import '/ui/app_controllers/local_auth_controller.dart';
import '/ui/utils/loader.dart';
import '../../app_components/custom_background_widget.dart';
import '../../app_components/dialog_information.dart';
import '../../app_controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with AppMessages, Loader {
  final _formKey = GlobalKey<FormState>();
  final _cpfMask = MaskTextInputFormatter(mask: '###.###.###-##');
  final _passwordCtrl = TextEditingController();

  String? _cpfValidator(String? value) {
    if (value == null || value.isEmpty) return "Campo obrigatório.";
    if (_cpfMask.getMaskedText().length < 14 ||
        !CPFValidator.isValid(_cpfMask.getMaskedText())) {
      return "CPF inválido.";
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) return "Campo obrigatório.";
    if (value.length < 8) return "Senha inválida.";
    return null;
  }

  void _validate() {
    if (_formKey.currentState!.validate()) {
      _login();
    }
  }

  Future<void> _login() async {
    var authCtrl = context.read<AuthController>();
    try {
      showLoader();
      await authCtrl
          .login(cpf: _cpfMask.getUnmaskedText(), password: _passwordCtrl.text)
          .whenComplete(() {
            hideLoader();
          });
      _navigateTo();
    } catch (e, s) {
      log("LOGIN ERROR", error: e, stackTrace: s);
      showCustomDialog(
        children: [
          DialogInformationWidget(
            title: "SEGURANÇA BELTRAN",
            message: e.toString(),
          ),
        ],
      );
    }
  }

  Future<void> _navigateTo() async {
    var ctrl = context.read<LocalAuthController>();

    if (mounted) {
      if (ctrl.localAuthStatus) {
        Navigator.pushReplacementNamed(context, "/home");
      } else {
        Navigator.pushReplacementNamed(context, "/device_auth");
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _passwordCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomBackgroundWidget(
      topChild: const CustomAppBarWidget(),
      bottomChild: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Entrar", style: AppStyle.title),
                    Text(
                      "Por favor, insira os dados cadastrados para acessar a conta.",
                      style: AppStyle.body,
                    ),

                    const SizedBox(height: 20),
                    Text("CPF", style: AppStyle.title),
                    const SizedBox(height: 10),
                    TextFormField(
                      inputFormatters: [_cpfMask],
                      onTapOutside: (_) {
                        FocusScope.of(context).unfocus();
                      },
                      decoration: InputDecoration(
                        hintText: "Insira o CPF cadastrado",
                        hintStyle: AppStyle.body.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                      validator: _cpfValidator,
                    ),

                    const SizedBox(height: 20),
                    Text("Senha", style: AppStyle.title),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordCtrl,
                      onTapOutside: (_) {
                        FocusScope.of(context).unfocus();
                      },
                      decoration: InputDecoration(
                        hintText: "Insira sua senha",
                        hintStyle: AppStyle.body.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                      validator: _passwordValidator,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      spacing: 5,
                      children: [
                        Text("Esqueceu sua senha?", style: AppStyle.body),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, "/forgot_password");
                          },
                          child: Text(
                            "Redefinir senha",
                            style: AppStyle.body.copyWith(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          ElevatedButton(onPressed: _validate, child: const Text("Entrar")),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
