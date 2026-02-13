import 'package:local_auth/local_auth.dart';

abstract class ILocalAuthService {
  Future<bool> isBiometricAvailable();
  Future<bool> authenticate();
}

class LocalAuthService implements ILocalAuthService {
  final LocalAuthentication auth = LocalAuthentication();

  @override
  Future<bool> isBiometricAvailable() async {
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    return canAuthenticateWithBiometrics || await auth.isDeviceSupported();
  }

  @override
  Future<bool> authenticate() async {
    try {
      return await auth.authenticate(localizedReason: "Authenticate");
    } catch (e) {
      throw Exception();
    }
  }
}
