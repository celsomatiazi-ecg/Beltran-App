import 'dart:developer';

import '/data/models/user_model.dart';
import '../../services/http/http_client.dart';
import '../../services/http/http_interceptor.dart';
import '../constants/http_constants.dart';

final class UserRepository {
  final IHttpClient client;
  final IHttpInterceptor httpInterceptor;

  UserRepository(this.client, this.httpInterceptor);

  UserModel? user;

  Future<UserModel> getUserData() async {
    try {
      return await httpInterceptor.handleAuth((headers) async {
        var response = await client.get(
          url: HttpConstants.userData,
          headers: headers,
        );
        return UserModel.fromMap(response);
      });
    } catch (e, s) {
      log("GET UserData REPO", error: e.toString(), stackTrace: s);
      rethrow;
    }
  }

  Future updateUserData(UserModel userData) async {
    try {
      return await httpInterceptor.handleAuth((headers) async {
        return client.post(
          url: HttpConstants.updateUserData,
          headers: headers,
          body: userData.toMap(),
        );
      });
    } catch (e, s) {
      log("POST UpdateUserData REPO", error: e.toString(), stackTrace: s);
      rethrow;
    }
  }

  Future deleteUser() async {
    try {
      return await httpInterceptor.handleAuth((headers) async {
        return client.get(url: HttpConstants.updateUserData, headers: headers);
      });
    } catch (e, s) {
      log("POST UpdateUserData REPO", error: e.toString(), stackTrace: s);
      rethrow;
    }
  }
}
