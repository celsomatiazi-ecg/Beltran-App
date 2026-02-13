import 'package:flutter/material.dart';

import '../../data/repositories/splash_repository.dart';
import '../../services/local_auth/local_auth_service.dart';

enum LocalAuthState { loading, goHome, goLogin }

final class LocalAuthController extends ChangeNotifier {
  final LocalAuthRepository _repository;
  final ILocalAuthService _localAuthService;

  LocalAuthController(this._repository, this._localAuthService);

  LocalAuthState _state = LocalAuthState.loading;
  LocalAuthState get state => _state;

  bool localAuthStatus = false;

  Future<void> init() async {
    final hasToken = await _repository.hasSavedToken();
    final canUseBiometric = await _localAuthService.isBiometricAvailable();
    final authenticated = await _localAuthService.authenticate();

    if (!hasToken) {
      _state = LocalAuthState.goLogin;
      notifyListeners();
      return;
    }
    if (!canUseBiometric) {
      _state = LocalAuthState.goLogin;
      notifyListeners();
      return;
    }
    _state = authenticated ? LocalAuthState.goHome : LocalAuthState.goLogin;
    notifyListeners();
  }

  Future getLocalAuthStatus() async {
    localAuthStatus = await _repository.getLocalAuthStatus();
  }

  Future saveLocalAuthStatus(bool status) async {
    localAuthStatus = status;
    await _repository.saveLocalAuthStatus(status);
    notifyListeners();
  }
}
