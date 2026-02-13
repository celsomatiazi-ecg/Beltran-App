import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '/data/models/signup_model.dart';
import '/ui/app_components/custom_app_bar.dart';
import '/ui/app_constants/app_style.dart';
import '../../app_components/custom_background_widget.dart';

class PersonDataScreen extends StatefulWidget {
  const PersonDataScreen({super.key});

  @override
  State<PersonDataScreen> createState() => _PersonDataScreenState();
}

class _PersonDataScreenState extends State<PersonDataScreen> {
  final _formKey = GlobalKey<FormState>();

  final _cpfMask = MaskTextInputFormatter(mask: '###.###.###-##');

  final _nameCtrl = TextEditingController();
  final _oabCtrl = TextEditingController();

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

  void _validate() {
    if (_formKey.currentState!.validate()) {
      _navigateTo();
    }
  }

  void _navigateTo() {
    SignupModel signupData = SignupModel(
      name: _nameCtrl.text,
      identification: _cpfMask.getUnmaskedText(),
      oab: _oabCtrl.text,
    );
    Navigator.pushNamed(context, "/signup_contact_data", arguments: signupData);
  }

  @override
  void dispose() {
    super.dispose();
    _nameCtrl.dispose();
    _oabCtrl.dispose();
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
                    Text("Dados pessoais", style: AppStyle.title),
                    Text(
                      "Por favor, insira seus dados e o nome da empresa para concluir o cadastro.",
                      style: AppStyle.body,
                    ),

                    const SizedBox(height: 20),
                    Text("Nome", style: AppStyle.titleLight),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _nameCtrl,
                      onTapOutside: (_) {
                        FocusScope.of(context).unfocus();
                      },
                      decoration: InputDecoration(
                        hintText: "Nome completo",
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
                    Text("OAB", style: AppStyle.titleLight),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _oabCtrl,
                      onTapOutside: (_) {
                        FocusScope.of(context).unfocus();
                      },
                      decoration: InputDecoration(
                        hintText: "Ex: UF000000",
                        hintStyle: AppStyle.body.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
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
