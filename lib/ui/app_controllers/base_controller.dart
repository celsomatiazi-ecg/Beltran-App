import 'dart:developer';

import 'package:flutter/material.dart';

import '../../data/exceptions/exceptions.dart';

abstract class BaseController extends ChangeNotifier {
  BaseController();
  Future<T> request<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on TokenException {
      rethrow;
    } on AppException catch (e, s) {
      log("BaseController ERROR", error: e.toString(), stackTrace: s);
      throw mapErrorToMessage(e);
    }
  }
}
