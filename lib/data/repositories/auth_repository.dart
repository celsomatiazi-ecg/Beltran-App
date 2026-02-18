import 'dart:developer';

import '/data/constants/local_storage_constants.dart';
import '/data/models/login_response_model.dart';
import '/data/models/tokens_model.dart';
import '/services/secure_storage_service.dart';
import '../../services/http/http_client.dart';
import '../constants/http_constants.dart';
import '../models/signup_model.dart';

abstract class IAuthRepository {
  Future postSignup({required SignupModel signupData});
  Future postLogin({required String cpf, required String password});
  Future postForgotPassword({required String identification});
  Future postSecurityCode({required String code, required String cpf});
  Future postPassword({
    required String identification,
    required String password,
  });
  Future logout();
  Future<TokensModel> getLocalTokens();
  Future updateDeviceAuthStatus(bool status);
}

class AuthRepository implements IAuthRepository {
  final ISecureStorageService secureStorageService;
  final IHttpClient client;
  AuthRepository({required this.secureStorageService, required this.client});

  @override
  Future postSignup({required SignupModel signupData}) async {
    final response = await client.post(
      url: HttpConstants.signup,
      body: signupData.toMap(),
      headers: {"Content-Type": "application/json; charset=UTF-8"},
    );

    try {
      return response['detail'];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future postLogin({required String cpf, required String password}) async {
    try {
      final body = await client.post(
        url: HttpConstants.login,
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: {"cpf": cpf, "password": password},
      );

      await secureStorageService.write(
        key: LocalStorageConstants.accessToken,
        value: body[LocalStorageConstants.accessToken],
      );
      await secureStorageService.write(
        key: LocalStorageConstants.refreshToken,
        value: body[LocalStorageConstants.refreshToken],
      );

      return LoginModel.fromMap(body);
    } catch (e, s) {
      log("AUTH REPO", error: e, stackTrace: s);
      rethrow;
    }
  }

  @override
  Future postForgotPassword({required String identification}) async {
    try {
      await client.post(
        url: HttpConstants.resendSecurityCode,
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: {"cpf": identification},
      );
    } catch (e, s) {
      log("FORGOT PASSWORD REPO", error: e.toString(), stackTrace: s);
      rethrow;
    }
  }

  @override
  Future postSecurityCode({required String code, required String cpf}) async {
    try {
      await client.post(
        url: HttpConstants.securityCode,
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: {"code": code, "cpf": cpf},
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future postPassword({
    required String identification,
    required String password,
  }) async {
    try {
      final body = await client.post(
        url: HttpConstants.password,
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: {"cpf": identification, "password": password},
      );
      return body["detail"];
    } catch (e, s) {
      log("SAVE NEW PASSWORD", error: e.toString(), stackTrace: s);
      rethrow;
    }
  }

  @override
  Future logout() async {
    // var refreshToken = await secureStorageService.read(
    //   key: LocalStorageConstants.refreshToken,
    // );

    try {
      // await client.post(
      //   body: {"refresh": refreshToken},
      //   url: HttpConstants.logout,
      //   headers: {"Content-Type": "application/json; charset=UTF-8"},
      // );
      await secureStorageService.delete(key: LocalStorageConstants.accessToken);
      await secureStorageService.delete(
        key: LocalStorageConstants.refreshToken,
      );
    } catch (e, s) {
      log("LOGOUT REPO", error: e, stackTrace: s);
    }
  }

  @override
  Future<TokensModel> getLocalTokens() async {
    var accessToken = await secureStorageService.read(
      key: LocalStorageConstants.accessToken,
    );
    var refreshToken = await secureStorageService.read(
      key: LocalStorageConstants.refreshToken,
    );
    return TokensModel(accessToken: accessToken, refreshToken: refreshToken);
  }

  @override
  Future updateDeviceAuthStatus(bool status) async {
    await secureStorageService.write(
      key: LocalStorageConstants.localAuth,
      value: status ? "true" : "false",
    );
  }
}
