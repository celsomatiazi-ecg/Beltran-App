import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:utils_tool_kit/utils_tool_kit.dart';

import '/data/models/signup_model.dart';
import '/ui/app_constants/app_style.dart';
import '/ui/utils/loader.dart';
import '../../app_components/custom_app_bar.dart';
import '../../app_components/custom_background_widget.dart';
import '../../app_components/dialog_information.dart';
import '../../app_controllers/auth_controller.dart';

class ContactDataScreen extends StatefulWidget {
  const ContactDataScreen({super.key});

  @override
  State<ContactDataScreen> createState() => _ContactDataScreenState();
}

class _ContactDataScreenState extends State<ContactDataScreen>
    with AppMessages, Loader {
  late SignupModel _signupData;

  final _formKey = GlobalKey<FormState>();
  final _phoneMask = MaskTextInputFormatter(mask: '(##)#####-####');
  final _emailCtrl = TextEditingController();

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) return "Campo obrigatório.";
    if (!value.contains("@") && !value.contains(".")) return "E-mail inválido.";
    return null;
  }

  String? _confEmailValidator(String? value) {
    if (value == null || value.isEmpty) return "Campo obrigatório.";
    if (_emailCtrl.text != value) return "E-mail não confere.";
    return null;
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.isEmpty) return "Campo obrigatório.";
    if (value.length != 14) return "Número de telefone inválido";
    return null;
  }

  void _validate() {
    if (_formKey.currentState!.validate()) {
      _signup();
    }
  }

  Future<void> _signup() async {
    var authCtrl = context.read<AuthController>();
    _signupData.email = _emailCtrl.text;
    _signupData.phoneNumber = _phoneMask.getUnmaskedText();
    try {
      showLoader();
      await authCtrl.register(_signupData).whenComplete(() {
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
  void dispose() {
    super.dispose();
    _emailCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _signupData = ModalRoute.of(context)!.settings.arguments as SignupModel;
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
                    Text("Dados de contato", style: AppStyle.title),
                    Text(
                      "Por favor, insira seu melhor e-mail e número de  telefone.",
                      style: AppStyle.body,
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
                        hintText: "ex@gmail.com",
                        hintStyle: AppStyle.body.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                      validator: _emailValidator,
                    ),

                    const SizedBox(height: 20),
                    Text("Confirme seu e-mail", style: AppStyle.titleLight),
                    const SizedBox(height: 5),
                    TextFormField(
                      onTapOutside: (_) {
                        FocusScope.of(context).unfocus();
                      },
                      decoration: InputDecoration(
                        hintText: "ex@gmail.com",
                        hintStyle: AppStyle.body.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                      validator: _confEmailValidator,
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
