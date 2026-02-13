import 'dart:developer';

import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:utils_tool_kit/utils_tool_kit.dart';

import '/data/models/signup_model.dart';
import '/ui/app_components/custom_app_bar.dart';
import '/ui/app_constants/app_style.dart';
import '/ui/utils/loader.dart';
import '../app_components/custom_background_widget.dart';
import '../app_components/dialog_information.dart';
import '../app_controllers/auth_controller.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with AppMessages, Loader {
  late SignupModel _signupData;

  final _formKey = GlobalKey<FormState>();
  final _cpfMask = MaskTextInputFormatter(mask: '###.###.###-##');

  String? _cpfValidator(String? value) {
    if (value == null || value.isEmpty) return "Campo obrigatório.";
    if (_cpfMask.getMaskedText().length < 14 ||
        !CPFValidator.isValid(_cpfMask.getMaskedText())) {
      return "CPF inválido.";
    }
    return null;
  }

  void _validate() {
    if (_formKey.currentState!.validate()) {
      _forgetPassword();
    }
  }

  Future<void> _forgetPassword() async {
    var authCtrl = context.read<AuthController>();
    _signupData = SignupModel(identification: _cpfMask.getUnmaskedText());

    try {
      showLoader();
      await authCtrl
          .forgotPassword(identification: _cpfMask.getUnmaskedText())
          .whenComplete(() {
            hideLoader();
          });
      _navigateTo();
    } catch (e, s) {
      log("SIGNUP VIEW", error: e.toString(), stackTrace: s);
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

  void _navigateTo() {
    Navigator.pushNamed(
      context,
      "/signup_security_code",
      arguments: _signupData,
    );
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
                    Text("Redefinir senha", style: AppStyle.title),
                    Text(
                      "Por favor, insira o CPF cadastrado.",
                      style: AppStyle.body,
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
                  ],
                ),
              ),
            ),
          ),

          ElevatedButton(onPressed: _validate, child: const Text("Continuar")),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
