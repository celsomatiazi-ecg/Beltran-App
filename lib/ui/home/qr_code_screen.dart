import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:utils_tool_kit/utils_tool_kit.dart';

import '/ui/app_components/custom_background_widget.dart';
import '/ui/app_constants/app_style.dart';
import '../register_client/client_instructions_widget.dart';

class QrCodeScreen extends StatefulWidget {
  const QrCodeScreen({super.key});

  @override
  State<QrCodeScreen> createState() => _QrCodeScreenState();
}

class _QrCodeScreenState extends State<QrCodeScreen> with AppMessages {
  void _instructionsModal() {
    showCustomDialog(children: [const ClientInstructionsWidget()]);
  }

  void _copyToClipboard(String code) {
    Clipboard.setData(ClipboardData(text: code));
    showBanner(
      message: "Código copiado para area de transferência!!",
      color: Colors.green,
    );
  }

  @override
  Widget build(BuildContext context) {
    String code = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(),

      body: CustomBackgroundWidget(
        topChild: SizedBox(
          width: context.screenWidth,
          child: Padding(
            padding: const EdgeInsets.all(20).copyWith(top: 10),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "QR Code para autenticação",
                  style: AppStyle.title.copyWith(color: Colors.white),
                ),

                Text(
                  "Lembre-se de instruir o cliente sobre as etapas necessárias para validação.",
                  style: AppStyle.titleLight.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),

        bottomChild: Column(
          children: [
            const SizedBox(height: 20),
            SizedBox(
              width: context.percentWidth(.65),
              height: context.percentWidth(.65),
              child: QrImageView(
                data: code,
                version: QrVersions.auto, // Ajusta a densidade automaticamente
                //size: 300.0,
                gapless: true,
                backgroundColor: Colors.white,
                errorStateBuilder: (cxt, err) {
                  return const Center(
                    child: Text(
                      "Erro ao gerar QR Code",
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),
            Text(code, textAlign: TextAlign.center, style: AppStyle.body),
            SizedBox(height: 20),

            Row(
              spacing: 20,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: context.percentWidth(.37),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyle.primaryColor,
                    ),
                    onPressed: () => _copyToClipboard(code),
                    child: Text("Copiar"),
                  ),
                ),

                // SizedBox(
                //   width: context.percentWidth(.37),
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: AppStyle.primaryColor,
                //     ),
                //     onPressed: () {},
                //     child: Text("Compartilhar"),
                //   ),
                // ),
              ],
            ),
            const Spacer(),

            ElevatedButton(
              onPressed: _instructionsModal,
              child: const Text("Instruções"),
            ),

            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Voltar"),
            ),
          ],
        ),
      ),
    );
  }
}
