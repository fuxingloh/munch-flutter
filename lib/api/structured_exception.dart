import 'package:http/http.dart' as http;
import 'package:munch_app/api/api.dart';

/// A list of Munch top level Exception,
/// Not all of them are implemented, only the user facing one are
///
/// munch.restful.core.exception.AuthenticationException
/// munch.restful.core.exception.BadRequestException
/// munch.restful.core.exception.CodeException
/// munch.restful.core.exception.ExceptionParser
/// munch.restful.core.exception.ForbiddenException
/// munch.restful.core.exception.JsonException
/// munch.restful.core.exception.LimitException
/// munch.restful.core.exception.OfflineException
/// munch.restful.core.exception.ParamException
/// munch.restful.core.exception.StructuredException
/// munch.restful.core.exception.TimeoutException
/// munch.restful.core.exception.UnavailableException
/// munch.restful.core.exception.UnknownException
/// munch.restful.core.exception.ValidationException
class StructuredException implements Exception {
  StructuredException({this.code, this.type, this.message});

  final int code;
  final String type;
  final String message;

  static StructuredException parse(RestfulMeta meta, http.Response response) {
    if (meta?.error?.type != null) {
      return StructuredException(
        code: meta.code ?? 200,
        type: meta.error.type,
        message: meta.error.message,
      );
    }

    switch (response.statusCode) {
      case 403:
        return ForbiddenException();

      case 404:
        return NotFoundException();

      case 502:
      case 503:
        return UnavailableException();

      case 301:
      case 410:
        return DeprecatedException();

      default:
        return null;
    }
  }

  String get title {
    switch (type) {
      case "munch.restful.core.exception.ForbiddenException":
        return "Forbidden (403)";

      case "munch.restful.core.exception.JsonException":
        return "Data Parsing Error (JSON)";

      default:
        return type;
    }
  }
}

class UnknownException extends StructuredException {
  UnknownException() : super(code: 500, type: "Unknown Exception");
}

class ForbiddenException extends StructuredException {
  ForbiddenException() : super(code: 403, type: "Forbidden Exception");
}

class NotFoundException extends StructuredException {
  NotFoundException() : super(code: 404, type: "Not Found");
}

class UnavailableException extends StructuredException {
  UnavailableException()
      : super(code: 502, type: "Service Unavailable", message: "Server temporary down, try again later.");
}

class DeprecatedException extends StructuredException {
  DeprecatedException()
      : super(
            code: 410,
            type: 'App Update Required',
            message: 'Your application version is not supported. Please update the app.');
}
