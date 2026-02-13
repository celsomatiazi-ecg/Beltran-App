import '/data/exceptions/exceptions.dart';
import '/services/secure_storage_service.dart';
import '../../data/constants/http_constants.dart';
import '../../data/constants/local_storage_constants.dart';
import 'http_client.dart';

abstract class IRefreshTokenService {
  Future refreshToken();
  Future<Map<String, String>> getAuthHeaders();
}

final class RefreshTokenService implements IRefreshTokenService {
  final IHttpClient client;
  final ISecureStorageService secureStorageService;

  RefreshTokenService({
    required this.client,
    required this.secureStorageService,
  });

  @override
  Future refreshToken() async {
    String refreshToken = await secureStorageService.read(
      key: LocalStorageConstants.refreshToken,
    );

    var body = {};
    try {
      body = await client.post(
        url: HttpConstants.refresh,
        headers: {"Content-Type": "application/json; charset=UTF-8"},
        body: {"refreshToken": refreshToken},
      );
      await secureStorageService.write(
        key: LocalStorageConstants.accessToken,
        value: body["accessToken"],
      );
      await secureStorageService.write(
        key: LocalStorageConstants.refreshToken,
        value: body["refreshToken"],
      );
    } on UnauthorizedException {
      _deleteTokens();
      throw TokenException();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<String, String>> getAuthHeaders() async {
    final token = await secureStorageService.read(
      key: LocalStorageConstants.accessToken,
    );
    return {
      'Authorization': 'Bearer $token',
      "Content-type": "application/json; charset=UTF-8",
    };
  }

  // ignore: strict_top_level_inference
  _deleteTokens() async {
    await secureStorageService.delete(key: LocalStorageConstants.accessToken);
    await secureStorageService.delete(key: LocalStorageConstants.refreshToken);
  }
}
