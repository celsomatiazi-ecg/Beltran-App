import 'package:flutter/material.dart';

import '/ui/app_components/custom_app_bar.dart';
import '/ui/app_constants/app_style.dart';
import '../../app_components/custom_background_widget.dart';

class EnterpriseDataScreen extends StatefulWidget {
  const EnterpriseDataScreen({super.key});

  @override
  State<EnterpriseDataScreen> createState() => _EnterpriseDataScreenState();
}

class _EnterpriseDataScreenState extends State<EnterpriseDataScreen> {
  final _formKey = GlobalKey<FormState>();

  final _enterpriseCtrl = TextEditingController();
  final _cnpjCtrl = TextEditingController();
  bool noCnpj = false;

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) return "Campo obrigatório.";
    if (!value.contains("@") && !value.contains(".")) return "E-mail inválido.";
    return null;
  }

  void _validate() {
    Navigator.pushNamed(context, "/signup_contact_data");
    if (_formKey.currentState!.validate()) {
      Navigator.pushNamed(context, "/signup_contact_data");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _enterpriseCtrl.dispose();
    _cnpjCtrl.dispose();
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
                    Text("Dados da empresa", style: AppStyle.title),
                    Text(
                      "Por favor, insira seus dados e o nome da empresa para concluir o cadastro.",
                      style: AppStyle.body,
                    ),

                    const SizedBox(height: 20),
                    Text("Empresa", style: AppStyle.titleLight),
                    const SizedBox(height: 5),
                    TextFormField(
                      onTapOutside: (_) {
                        FocusScope.of(context).unfocus();
                      },
                      decoration: InputDecoration(
                        hintText: "Nome fantasia da empresa",
                        hintStyle: AppStyle.body.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                      validator: _emailValidator,
                    ),

                    const SizedBox(height: 20),
                    Text("CNPJ", style: AppStyle.titleLight),
                    const SizedBox(height: 5),
                    TextFormField(
                      onTapOutside: (_) {
                        FocusScope.of(context).unfocus();
                      },
                      decoration: InputDecoration(
                        hintText: "000.000.000/0000-00",
                        hintStyle: AppStyle.body.copyWith(
                          color: Colors.black54,
                        ),
                      ),
                      validator: _emailValidator,
                    ),

                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          value: noCnpj,
                          onChanged: (status) {
                            noCnpj = status!;
                            setState(() {});
                          },
                        ),

                        Text(
                          "Sou autônomo, não possuo CNPJ.",
                          style: AppStyle.body,
                        ),
                      ],
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
