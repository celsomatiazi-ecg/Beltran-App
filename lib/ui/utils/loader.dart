import 'package:flutter/material.dart';

mixin Loader<T extends StatefulWidget> on State<T> {
  var isOpen = false;
  // ignore: strict_top_level_inference
  showLoader() {
    if (!isOpen) {
      isOpen = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: SizedBox(
              width: 70,
              height: 70,
              child: CircularProgressIndicator(
                strokeWidth: 8,
                backgroundColor: Colors.white,
                color: Color(0xff8B0100),
              ),
            ),
          );
        },
      );
    }
  }

  void hideLoader() {
    if (isOpen) {
      isOpen = false;
      Navigator.pop(context);
    }
  }
}
