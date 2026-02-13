sealed class AppException implements Exception {}

class TokenException implements AppException {}

class NetworkException extends AppException {}

class TimeoutException extends AppException {}

class UnauthorizedException extends AppException {}

class ServerException extends AppException {
  String? message;
  ServerException(this.message);
}

class UnknownException extends AppException {}

String mapErrorToMessage(AppException exception) {
  return switch (exception) {
    NetworkException() => 'Sem conexão com a internet.',
    TimeoutException() => 'Tempo de requisição excedido.',
    UnauthorizedException() => 'Sessão expirada. Faça login novamente.',
    TokenException() => "Sessão expirada. Faça login novamente.",
    ServerException(:final message) =>
      message?.isNotEmpty == true
          ? message!
          : "Desculpe, houve um erro e não conseguimos completar a operação!",
    UnknownException() =>
      "Desculpe, houve um erro e não conseguimos completar a operação!",
  };
}
