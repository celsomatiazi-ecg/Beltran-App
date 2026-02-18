import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';
import 'package:utils_tool_kit/utils_tool_kit.dart';

import '/data/models/client_model.dart';
import '/ui/app_components/custom_background_widget.dart';
import '/ui/app_constants/app_style.dart';
import '/ui/utils/loader.dart';
import '/ui/utils/navigate_to_root.dart';
import '../../data/exceptions/exceptions.dart';
import '../app_components/dialog_information.dart';
import '../app_controllers/client_controller.dart';

class ClientDetailScreen extends StatefulWidget {
  const ClientDetailScreen({super.key});

  @override
  State<ClientDetailScreen> createState() => _ClientDetailScreenState();
}

class _ClientDetailScreenState extends State<ClientDetailScreen>
    with AppMessages, Loader, SingleTickerProviderStateMixin, NavigateTo {
  late ClientModel client;
  late AnimationController _controller;

  final ValueNotifier<String> _currentCode = ValueNotifier<String>("      ");

  bool _isFetchingCode = false;

  static const int _cycleSeconds = 30;

  var formattedDate = DateFormat('dd-MM-yyyy - HH:mm');
  final _cpfMask = MaskTextInputFormatter(mask: '###.###.###-##');
  final _phoneMask = MaskTextInputFormatter(mask: '(##)#####-####');

  /// calcula quanto falta para o próximo ciclo (30s / 60s)
  int _remainingSecondsFromNow() {
    final now = DateTime.now().second;
    return now < _cycleSeconds ? _cycleSeconds - now : 60 - now;
  }

  void _startCounter() {
    final remaining = _remainingSecondsFromNow();
    _controller
      ..stop()
      ..duration = Duration(seconds: remaining)
      ..value = 0
      ..forward();
  }

  /// segundos restantes (derivados da animação)
  int get _secondsLeft {
    final total = _controller.duration?.inSeconds ?? 1;
    return (total * (1 - _controller.value)).ceil();
  }

  Future<void> _onCounterFinished() async {
    if (!mounted) return;
    await _getClientCode();
  }

  Future<void> _getClientCode() async {
    if (_isFetchingCode) return;
    _isFetchingCode = true;
    final ctrl = context.read<ClientController>();
    try {
      //showLoader();
      _currentCode.value = await ctrl.getClientCode(client);
      _startCounter();
    } on TokenException {
      _expiredSessionDialog();
    } catch (e, s) {
      log("erro", error: e.toString(), stackTrace: s);
      showCustomDialog(
        children: [
          DialogInformationWidget(title: "Erro", message: e.toString()),
        ],
      );
    } finally {
      hideLoader();
      _isFetchingCode = false;
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
    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _onCounterFinished();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getClientCode();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _currentCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    client = ModalRoute.of(context)!.settings.arguments as ClientModel;

    return Scaffold(
      appBar: AppBar(
        title: Text("Beltran"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/qr_code", arguments: client);
            },
            icon: Icon(Icons.qr_code),
          ),
        ],
      ),
      body: CustomBackgroundWidget(
        topChild: _buildClientInfo(context),
        bottomChild: _buildBottomContent(),
      ),
    );
  }

  Widget _buildClientInfo(BuildContext context) {
    return SizedBox(
      width: context.screenWidth,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              client.name,
              style: AppStyle.title.copyWith(color: Colors.white),
            ),
            Text(
              "Cadastrado ${formattedDate.format(client.createdAtt!)}",
              style: AppStyle.body.copyWith(color: Colors.white),
            ),
            Text(
              "Responsável: ${client.responsible}",
              style: AppStyle.body.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 20),
            Text(
              "CPF: ${_cpfMask.maskText(client.cpf)}",
              style: AppStyle.titleLight.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              "Celular: ${_phoneMask.maskText(client.phone)}",
              style: AppStyle.titleLight.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              "E-mail: ${client.email}",
              style: AppStyle.titleLight.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomContent() {
    return Column(
      children: [
        Text("Código de verificação", style: AppStyle.title),
        const SizedBox(height: 10),
        Text(
          "Por segurança, compartilhe este código com o cliente. Ele deverá confirmar que a sequência é idêntica à gerada no aplicativo Google Authenticator dele.",
          textAlign: TextAlign.center,
          style: AppStyle.body,
        ),
        const SizedBox(height: 30),

        ValueListenableBuilder(
          valueListenable: _currentCode,
          builder: (context, value, _) {
            return Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                6,
                (i) => CodeNumberBoxWidget(number: value[i]),
              ),
            );
          },
        ),

        const SizedBox(height: 30),

        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 60,
                  width: 60,
                  child: CircularProgressIndicator(
                    value: _controller.value,
                    strokeWidth: 6,
                    backgroundColor: Colors.black12,
                  ),
                ),
                Text('${_secondsLeft}s', style: AppStyle.title),
              ],
            );
          },
        ),

        const SizedBox(height: 30),

        Text(
          "Lembre-se: para mais segurança você deverá compartilhar seu código primeiro!",
          textAlign: TextAlign.center,
          style: AppStyle.body.copyWith(color: Colors.red),
        ),

        const Spacer(),

        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Voltar"),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}

class CodeNumberBoxWidget extends StatelessWidget {
  final String number;

  const CodeNumberBoxWidget({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 45,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black26),
      ),
      child: Text(number, style: AppStyle.titleLight),
    );
  }
}
