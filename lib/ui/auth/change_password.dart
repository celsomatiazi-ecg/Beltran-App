import 'dart:developer';

import 'package:beltran_adv/ui/utils/navigate_to_root.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:utils_tool_kit/utils_tool_kit.dart';

import '/ui/app_constants/app_style.dart';
import '/ui/app_controllers/user_controller.dart';
import '/ui/utils/loader.dart';
import '../../data/exceptions/exceptions.dart';
import '../app_components/dialog_information.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword>
    with AppMessages, Loader, NavigateTo {
  final _formKey = GlobalKey<FormState>();

  final _currentPasswordCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _hasLength = false;
  bool _hasCapital = false;
  bool _hasNormal = false;
  bool _hasSpecial = false;

  bool _validateCapitalLetter(String value) {
    String pattern = r'[A-Z]';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool _validateNormalLetter(String value) {
    String pattern = r'[a-z]';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool _validateSpecialLetter(String value) {
    String pattern = r'[`!@#$%^&*()_+\-=\[\]{};"|,.<>?~]';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool _validateNumber(String value) {
    String pattern = r'[0-9]';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool _validateNumberLength(String value) {
    return !(value.length < 8);
  }

  String? _confCurrentPasswordValidator(String? value) {
    if (value == null || value.isEmpty) return "Campo obrigatório.";
    if ((value.length < 5)) return "Senha inválida";
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) return "Campo obrigatório.";

    if (!_validateCapitalLetter(value) ||
        !_validateNormalLetter(value) ||
        !_validateNumber(value) ||
        !_validateSpecialLetter(value) ||
        !_validateNumberLength(value)) {
      return "Senha inválida";
    }
    return null;
  }

  String? _confPasswordValidator(String? value) {
    if (value == null || value.isEmpty) return "Campo obrigatório.";
    if ((value != _passwordCtrl.text)) return "Senhas não conferem.";
    return null;
  }

  void _validate() {
    if (_formKey.currentState!.validate()) {
      _savePassword();
    }
  }

  Future<void> _savePassword() async {
    var ctrl = context.read<UserController>();
    try {
      showLoader();
      await ctrl
          .updatePassword(
            currentPassword: _currentPasswordCtrl.text,
            password: _passwordCtrl.text,
          )
          .whenComplete(() {
            hideLoader();
          });
      _navigateTo();
    } on TokenException {
      _expiredSessionDialog();
    } catch (e, s) {
      log("Update password VIEW", error: e.toString(), stackTrace: s);
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

  void _navigateTo() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
    _currentPasswordCtrl.dispose();
    _passwordCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Redefinir senha")),
      body: Padding(
        padding: const EdgeInsets.all(20).copyWith(top: 0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Defina sua senha", style: AppStyle.title),
                      Text(
                        "Escolha uma senha forte, ela será usada para acessar o aplicativo.",
                        style: AppStyle.body,
                      ),

                      const SizedBox(height: 20),
                      Text("Senha atual", style: AppStyle.titleLight),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _currentPasswordCtrl,
                        onTapOutside: (_) {
                          FocusScope.of(context).unfocus();
                        },
                        decoration: InputDecoration(
                          hintText: "Digite sua senha atual",
                          hintStyle: AppStyle.body.copyWith(
                            color: Colors.black54,
                          ),
                        ),
                        validator: _confCurrentPasswordValidator,
                      ),

                      const SizedBox(height: 20),
                      Text("Nova senha", style: AppStyle.titleLight),
                      const SizedBox(height: 5),
                      TextFormField(
                        controller: _passwordCtrl,
                        onTapOutside: (_) {
                          FocusScope.of(context).unfocus();
                        },
                        onChanged: (value) {
                          if (!_validateNumberLength(value)) {
                            _hasLength = false;
                          } else {
                            _hasLength = true;
                          }
                          if (!_validateCapitalLetter(value)) {
                            _hasCapital = false;
                          } else {
                            _hasCapital = true;
                          }
                          if (!_validateNormalLetter(value)) {
                            _hasNormal = false;
                          } else {
                            _hasNormal = true;
                          }
                          if (!_validateNumber(value)) {
                            _hasSpecial = false;
                          } else {
                            _hasSpecial = true;
                          }
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: "Digite um senha forte",
                          hintStyle: AppStyle.body.copyWith(
                            color: Colors.black54,
                          ),
                        ),
                        validator: _passwordValidator,
                      ),

                      const SizedBox(height: 20),
                      Text("Confirme sua senha", style: AppStyle.titleLight),
                      const SizedBox(height: 5),
                      TextFormField(
                        onTapOutside: (_) {
                          FocusScope.of(context).unfocus();
                        },
                        decoration: InputDecoration(
                          hintText: "Digite sua senha novamente",
                          hintStyle: AppStyle.body.copyWith(
                            color: Colors.black54,
                          ),
                        ),
                        validator: _confPasswordValidator,
                      ),

                      const SizedBox(height: 20),
                      Row(
                        spacing: 5,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: _hasLength ? Colors.green : Colors.black45,
                          ),
                          Text(
                            "Minimo 8 caracteres",
                            style: AppStyle.body.copyWith(
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        spacing: 5,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: _hasSpecial ? Colors.green : Colors.black45,
                          ),
                          Text(
                            "Símbolos (! @ # \$ % *)",
                            style: AppStyle.body.copyWith(
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        spacing: 5,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: _hasCapital ? Colors.green : Colors.black45,
                          ),
                          Text(
                            "Letras maiúsculas (A-Z)",
                            style: AppStyle.body.copyWith(
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        spacing: 5,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: _hasNormal ? Colors.green : Colors.black45,
                          ),
                          Text(
                            "letra minúscula (a-z)",
                            style: AppStyle.body.copyWith(
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            ElevatedButton(onPressed: _validate, child: const Text("Concluir")),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
