import 'package:flutter/material.dart';

import '/ui/app_constants/app_style.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final ValueNotifier<bool> _allowNotification = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notificações")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          spacing: 5,
          children: [
            const Icon(Icons.notifications_none),

            Expanded(
              child: Text("Permitir notificações", style: AppStyle.titleLight),
            ),

            Transform.scale(
              scale: .8,
              child: ValueListenableBuilder(
                valueListenable: _allowNotification,
                builder: (context, value, child) {
                  return Switch(
                    value: value,
                    onChanged: (value) {
                      _allowNotification.value = value;
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
