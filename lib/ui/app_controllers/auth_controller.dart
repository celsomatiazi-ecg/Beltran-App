import 'dart:developer';

import 'package:flutter/material.dart';

import '/data/models/signup_model.dart';
import '/data/models/tokens_model.dart';
import '/data/repositories/auth_repository.dart';
import '../../data/exceptions/exceptions.dart';

class AuthController extends ChangeNotifier {
  final IAuthRepository authRepository;
  AuthController(this.authRepository);

  TokensModel? currentTokens;

  Future login({required String cpf, required String password}) async {
    try {
      await authRepository.postLogin(cpf: cpf, password: password);
      getLocalTokens();
    } on AppException catch (e, s) {
      log("Login CTRL ERROR", error: e.toString(), stackTrace: s);
      throw mapErrorToMessage(e);
    }
  }

  Future forgotPassword({required String identification}) async {
    try {
      await authRepository.postForgotPassword(identification: identification);
    } on AppException catch (e) {
      throw mapErrorToMessage(e);
    }
  }

  Future register(SignupModel data) async {
    try {
      var successMessage =
          await authRepository.postSignup(signupData: data) ?? "";
      return successMessage ?? "";
    } on AppException catch (e, s) {
      log("Register Error", error: e.toString(), stackTrace: s);
      throw mapErrorToMessage(e);
    }
  }

  Future sendSecurityCode({required String code, required String cpf}) async {
    try {
      await authRepository.postSecurityCode(code: code, cpf: cpf);
    } on AppException catch (e, s) {
      log("Send Security Code Error", error: e.toString(), stackTrace: s);
      throw mapErrorToMessage(e);
    }
  }

  Future savePassword({
    required String identification,
    required String password,
  }) async {
    try {
      return await authRepository.postPassword(
        identification: identification,
        password: password,
      );
    } on AppException catch (e) {
      throw mapErrorToMessage(e);
    }
  }

  Future logout() async {
    try {
      await authRepository.logout();
      currentTokens = null;
    } on AppException catch (e, s) {
      log("AUTH LOGOUT", error: e, stackTrace: s);
    }
  }

  Future getLocalTokens() async {
    currentTokens = null;
    currentTokens = await authRepository.getLocalTokens();
  }
}
