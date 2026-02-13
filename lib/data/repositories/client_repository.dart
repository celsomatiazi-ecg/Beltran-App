import 'dart:convert';
import 'dart:developer';

import '/data/constants/local_storage_constants.dart';
import '/data/models/client_model.dart';
import '../../services/http/http_client.dart';
import '../../services/http/http_interceptor.dart';
import '../../services/secure_storage_service.dart';
import '../constants/http_constants.dart';

final class ClientRepository {
  final IHttpClient client;
  final IHttpInterceptor httpInterceptor;
  final ISecureStorageService _storage;

  ClientRepository(this.client, this.httpInterceptor, this._storage);

  List<ClientModel> clients = [];

  Future getClients() async {
    try {
      return await httpInterceptor.handleAuth((headers) async {
        return client.get(url: HttpConstants.clients, headers: headers);
      });
    } catch (e, s) {
      log("GET CLIENTS REPO", error: e.toString(), stackTrace: s);
      rethrow;
    }
  }

  Future saveClient(ClientModel clientData) async {
    try {
      return await httpInterceptor.handleAuth((headers) async {
        return client.post(
          url: HttpConstants.saveClient,
          headers: headers,
          body: clientData.toMap(),
        );
      });
    } catch (e, s) {
      log("SAVE CLIENT REPO", error: e.toString(), stackTrace: s);
      rethrow;
    }
  }

  Future getClientCode(ClientModel clientData) async {
    try {
      return await httpInterceptor.handleAuth((headers) async {
        return client.post(
          url: HttpConstants.clientCode,
          headers: headers,
          body: {"id": clientData.id},
        );
      });
    } catch (e, s) {
      log("GET CLIENT CODE REPO", error: e.toString(), stackTrace: s);
      rethrow;
    }
  }

  Future<void> saveRecentClientsId(List recentIds) async {
    await _storage.write(
      key: LocalStorageConstants.recentClientsId,
      value: recentIds.toString(),
    );
  }

  Future<List> getRecentClientsId() async {
    var clientsId = await _storage.read(
      key: LocalStorageConstants.recentClientsId,
    );
    if (clientsId.isEmpty) return [];
    List result = json.decode(clientsId);
    return result;
  }
}
