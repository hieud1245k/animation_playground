abstract class BaseException extends Error {
  final String message;

  BaseException(this.message);
}

class ServerException extends BaseException {
  final int? code;
  final String? name;

  ServerException({
    required String message,
    this.code,
    this.name,
  }) : super(message);
}

class LocalException extends BaseException {
  LocalException({required String message}) : super(message);
}
