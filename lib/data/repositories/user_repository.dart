import 'dart:developer';

import '/data/models/user_model.dart';
import '../../services/http/http_client.dart';
import '../../services/http/http_interceptor.dart';
import '../../services/secure_storage_service.dart';
import '../constants/http_constants.dart';

final class UserRepository {
  final IHttpClient _client;
  final IHttpInterceptor _httpInterceptor;
  final ISecureStorageService _storage;

  UserRepository(this._client, this._httpInterceptor, this._storage);

  UserModel? user;

  Future<UserModel> getUserData() async {
    try {
      return await _httpInterceptor.handleAuth((headers) async {
        var response = await _client.get(
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
      return await _httpInterceptor.handleAuth((headers) async {
        return _client.post(
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
      var response = await _httpInterceptor.handleAuth((headers) async {
        return _client.delete(url: HttpConstants.userData, headers: headers);
      });
      _storage.deleteAll();
      return response;
    } catch (e, s) {
      log("DELETE USER REPO", error: e.toString(), stackTrace: s);
      rethrow;
    }
  }

  Future postUpdatePassword({
    required String currentPassword,
    required String password,
  }) async {
    try {
      return await _httpInterceptor.handleAuth((headers) async {
        return await _client.post(
          url: HttpConstants.updatePassword,
          headers: headers,
          body: {"password": currentPassword, "newPassword": password},
        );
      });
    } catch (e, s) {
      log("Update PASSWORD", error: e.toString(), stackTrace: s);
      rethrow;
    }
  }
}
