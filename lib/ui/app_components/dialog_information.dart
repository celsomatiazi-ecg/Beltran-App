import 'package:flutter/material.dart';

class DialogInformationWidget extends StatelessWidget {
  final String message;
  final String title;

  const DialogInformationWidget({
    super.key,
    required this.message,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        spacing: 20,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          Text(message, style: TextStyle(fontSize: 16)),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Entendi"),
          ),
        ],
      ),
    );
  }
}
