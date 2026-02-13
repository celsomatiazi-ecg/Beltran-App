import '../../services/secure_storage_service.dart';
import '../constants/local_storage_constants.dart';

abstract class ILocalAuthRepository {
  Future<bool> hasSavedToken();
  Future<bool> getLocalAuthStatus();
  Future saveLocalAuthStatus(bool status);
}

class LocalAuthRepository implements ILocalAuthRepository {
  final ISecureStorageService _storage;

  LocalAuthRepository(this._storage);

  @override
  Future<bool> hasSavedToken() async {
    final token = await _storage.read(key: LocalStorageConstants.accessToken);
    return token.isNotEmpty;
  }

  @override
  Future<bool> getLocalAuthStatus() async {
    String status = await _storage.read(key: LocalStorageConstants.localAuth);
    return status == "true" ? true : false;
  }

  @override
  Future<void> saveLocalAuthStatus(bool status) async {
    await _storage.write(
      key: LocalStorageConstants.localAuth,
      value: status.toString(),
    );
  }
}
