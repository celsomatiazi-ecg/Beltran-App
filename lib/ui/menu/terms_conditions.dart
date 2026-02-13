import 'package:flutter/material.dart';

import '/ui/menu/components/menu_item_widget.dart';

class TermsConditions extends StatelessWidget {
  const TermsConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Termos e condições")),

      body: Column(
        children: [
          const SizedBox(height: 20),

          MenuItemWidget(
            title: "Termos de uso",
            icon: const Icon(Icons.article_outlined),
            onClick: () {},
          ),

          MenuItemWidget(
            title: "Polica de privacidade",
            icon: const Icon(Icons.article_rounded),
            onClick: () {},
          ),
        ],
      ),
    );
  }
}
