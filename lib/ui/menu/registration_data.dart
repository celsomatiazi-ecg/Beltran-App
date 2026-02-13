import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:utils_tool_kit/utils_tool_kit.dart';

import '/data/models/user_model.dart';
import '/ui/app_components/dialog_information.dart';
import '../app_constants/app_style.dart';
import '../app_controllers/user_controller.dart';
import '../utils/loader.dart';

class RegistrationData extends StatefulWidget {
  const RegistrationData({super.key});

  @override
  State<RegistrationData> createState() => _RegistrationDataState();
}

class _RegistrationDataState extends State<RegistrationData>
    with AppMessages, Loader {
  final _formKey = GlobalKey<FormState>();

  final _cpfMask = MaskTextInputFormatter(mask: '###.###.###-##');
  final _phoneMask = MaskTextInputFormatter(mask: '(##)#####-####');
  final _nameCtrl = TextEditingController();
  final _cpfCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _oabCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) return "Campo obrigatório.";
    if (value.length < 5) return "Nome inválido.";
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
      _updateUserData();
    }
  }

  Future<void> _updateUserData() async {
    var ctrl = context.read<UserController>();
    var userData = UserModel(
      name: _nameCtrl.text,
      phoneNumber: _phoneCtrl.text,
      email: _emailCtrl.text,
    );
    try {
      showLoader();
      await ctrl.updateUserData(userData).whenComplete(() {
        hideLoader();
      });
      showCustomDialog(
        children: [
          DialogInformationWidget(
            message: "Dados atualizados com sucesso!",
            title: "Beltran",
          ),
        ],
      );
    } catch (e) {
      showCustomDialog(
        children: [
          DialogInformationWidget(message: e.toString(), title: "Beltran"),
        ],
      );
    }
  }

  void _setDataFields() {
    var ctrl = context.read<UserController>();
    _nameCtrl.text = ctrl.userData?.name ?? "";
    _cpfCtrl.text = _cpfMask.maskText(ctrl.userData?.identification ?? "");
    _emailCtrl.text = ctrl.userData?.email ?? "";
    _oabCtrl.text = ctrl.userData?.oab ?? "";
    _phoneCtrl.text = _phoneMask.maskText(ctrl.userData?.phoneNumber ?? "");
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setDataFields();
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _cpfCtrl.dispose();
    _emailCtrl.dispose();
    _oabCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dados cadastrais")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Consumer<UserController>(
                  builder: (context, ctrl, _) {
                    // _nameCtrl.text = ctrl.userData?.name ?? "";
                    // _cpfCtrl.text = _cpfMask.maskText(
                    //   ctrl.userData?.identification ?? "",
                    // );
                    // _emailCtrl.text = ctrl.userData?.email ?? "";
                    // _oabCtrl.text = ctrl.userData?.oab ?? "";
                    // _phoneCtrl.text = _phoneMask.maskText(
                    //   ctrl.userData?.phoneNumber ?? "",
                    // );

                    return Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Nome", style: AppStyle.titleLight),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: _nameCtrl,
                            validator: _nameValidator,
                            onTapOutside: (_) {
                              FocusScope.of(context).unfocus();
                            },
                            decoration: InputDecoration(
                              hintText: "Nome conpleto",
                              hintStyle: AppStyle.body.copyWith(
                                color: Colors.black54,
                              ),
                              suffixIcon: const Icon(Icons.edit),
                            ),
                          ),

                          const SizedBox(height: 20),
                          Text("E-mail", style: AppStyle.titleLight),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: _emailCtrl,
                            validator: _emailValidator,
                            onTapOutside: (_) {
                              FocusScope.of(context).unfocus();
                            },
                            decoration: InputDecoration(
                              hintText: "Digite seu e-mail",
                              hintStyle: AppStyle.body.copyWith(
                                color: Colors.black54,
                              ),
                              suffixIcon: const Icon(Icons.edit),
                            ),
                          ),

                          const SizedBox(height: 20),
                          Text("Celular", style: AppStyle.titleLight),
                          const SizedBox(height: 5),
                          TextFormField(
                            controller: _phoneCtrl,
                            validator: _phoneValidator,
                            onTapOutside: (_) {
                              FocusScope.of(context).unfocus();
                            },
                            decoration: InputDecoration(
                              hintText: "(00)00000-0000",
                              hintStyle: AppStyle.body.copyWith(
                                color: Colors.black54,
                              ),
                              suffixIcon: const Icon(Icons.edit),
                            ),
                          ),

                          const SizedBox(height: 20),
                          Text("CPF", style: AppStyle.titleLight),
                          const SizedBox(height: 5),
                          TextField(
                            controller: _cpfCtrl,
                            readOnly: true,
                            onTapOutside: (_) {
                              FocusScope.of(context).unfocus();
                            },
                            decoration: InputDecoration(
                              hintText: "000.000.000-00",
                              hintStyle: AppStyle.body.copyWith(
                                color: Colors.black54,
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),
                          Text("OAB", style: AppStyle.titleLight),
                          const SizedBox(height: 5),
                          TextField(
                            controller: _oabCtrl,
                            readOnly: true,
                            onTapOutside: (_) {
                              FocusScope.of(context).unfocus();
                            },
                            decoration: InputDecoration(
                              hintText: "F4DKF40d",
                              hintStyle: AppStyle.body.copyWith(
                                color: Colors.black54,
                              ),
                            ),
                          ),

                          // const SizedBox(height: 20),
                          // Text("Empresa", style: AppStyle.titleLight),
                          // const SizedBox(height: 5),
                          // TextFormField(
                          //   onTapOutside: (_) {
                          //     FocusScope.of(context).unfocus();
                          //   },
                          //   decoration: InputDecoration(
                          //     hintText: "Nome da empresa",
                          //     hintStyle: AppStyle.body.copyWith(
                          //       color: Colors.black54,
                          //     ),
                          //     suffixIcon: const Icon(Icons.edit),
                          //   ),
                          // ),

                          // const SizedBox(height: 20),
                          // Text("CNPJ", style: AppStyle.titleLight),
                          // const SizedBox(height: 5),
                          // TextFormField(
                          //   onTapOutside: (_) {
                          //     FocusScope.of(context).unfocus();
                          //   },
                          //   decoration: InputDecoration(
                          //     hintText: "000.000.000/0000-00",
                          //     hintStyle: AppStyle.body.copyWith(
                          //       color: Colors.black54,
                          //     ),
                          //     suffixIcon: const Icon(Icons.edit),
                          //   ),
                          // ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            ElevatedButton(
              onPressed: _validate,
              child: const Text("Salvar alterações"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
