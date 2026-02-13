import 'package:flutter/material.dart';

mixin NavigateTo<T extends StatefulWidget> on State<T> {
  void navigateTo(String route) {
    Navigator.pushNamedAndRemoveUntil(context, route, ModalRoute.withName("/"));
  }
}
