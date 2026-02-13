import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:utils_tool_kit/utils_tool_kit.dart';

import '/ui/app_components/custom_app_bar.dart';
import '/ui/app_constants/app_style.dart';
import '../../app_components/custom_background_widget.dart';

class SecurityCodeScreen extends StatefulWidget {
  const SecurityCodeScreen({super.key});

  @override
  State<SecurityCodeScreen> createState() => _SecurityCodeScreenState();
}

class _SecurityCodeScreenState extends State<SecurityCodeScreen>
    with AppMessages {
  final ValueNotifier<bool> _allowResendCode = ValueNotifier<bool>(false);
  final ValueNotifier<int> _currentValue = ValueNotifier<int>(60);

  late Timer timer;
  String _securityCode = "";

  void _timer() {
    timer = Timer(const Duration(seconds: 1), () {
      _currentValue.value--;
      if (_currentValue.value > 0) _timer();
      if (_currentValue.value == 0) _allowResendCode.value = true;
    });
  }

  void _resendCode() {
    if (_currentValue.value == 0) {
      _currentValue.value = 60;
      _allowResendCode.value = false;
      _timer();
    }
  }

  void _validate() {
    if (_securityCode.isEmpty) {
      showBanner(message: "Digite o código de segurança", color: Colors.red);
    } else {
      Navigator.pushNamed(context, "/device_auth");
    }
  }

  @override
  void initState() {
    super.initState();
    _timer();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Código de verificação", style: AppStyle.title),
                    Text(
                      "Insira o código de 4 dígitos enviado para o número cadastrado.",
                      style: AppStyle.body,
                    ),

                    const SizedBox(height: 20),

                    Center(
                      child: VerificationCode(
                        length: 4,
                        cursorColor: Colors.black12,
                        fullBorder: true,
                        itemSize: 70,
                        fillColor: Colors.white12,
                        padding: const EdgeInsets.all(10),
                        textStyle: AppStyle.title.copyWith(fontSize: 30),
                        onCompleted: (code) {
                          _securityCode = code;
                        },
                        onEditing: (_) {},
                      ),
                    ),

                    const SizedBox(height: 20),
                    Row(
                      spacing: 5,
                      children: [
                        Text("Não recebeu o código?", style: AppStyle.body),
                        ValueListenableBuilder(
                          valueListenable: _currentValue,
                          builder: (context, value, child) {
                            return InkWell(
                              onTap: () {
                                if (_allowResendCode.value) {
                                  _resendCode();
                                }
                              },
                              child: Text(
                                "Reenviar em (${value.toString()}s)",
                                style: AppStyle.body.copyWith(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            );
                          },
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
    );
  }
}
