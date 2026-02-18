import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/data/repositories/auth_repository.dart';
import '/data/repositories/client_repository.dart';
import '/data/repositories/splash_repository.dart';
import '/data/repositories/user_repository.dart';
import '/services/http/http_interceptor.dart';
import '/services/local_auth/local_auth_service.dart';
import '/ui/app_controllers/local_auth_controller.dart';
import '/ui/app_controllers/user_controller.dart';
import '../services/http/http_client.dart';
import '../services/http/refresh_token_service.dart';
import '../services/secure_storage_service.dart';
import '../ui/app_controllers/auth_controller.dart';
import '../ui/app_controllers/client_controller.dart';

class DependenceInjection extends StatelessWidget {
  final Widget child;

  const DependenceInjection({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ISecureStorageService>(
          create: (context) => SecureStorageService(),
        ),
        Provider<IHttpClient>(create: (context) => HttpClient()),
        Provider<ILocalAuthService>(create: (context) => LocalAuthService()),
        Provider<IRefreshTokenService>(
          create: (context) => RefreshTokenService(
            client: context.read(),
            secureStorageService: context.read(),
          ),
        ),
        Provider<IHttpInterceptor>(
          create: (context) =>
              HttpInterceptor(refreshTokenService: context.read()),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthController(
            AuthRepository(
              client: context.read(),
              secureStorageService: context.read(),
            ),
          ),
        ),
        //ChangeNotifierProvider(create: (context) => SessionController()),
        ChangeNotifierProvider(
          create: (context) => ClientController(
            ClientRepository(context.read(), context.read(), context.read()),
            //context.read(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => UserController(
            UserRepository(context.read(), context.read(), context.read()),
          ),
        ),

        ChangeNotifierProvider(
          create: (context) => LocalAuthController(
            LocalAuthRepository(context.read()),
            context.read(),
          ),
        ),
      ],
      child: child,
    );
  }
}
