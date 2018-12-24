import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:munch_app/api/structured_exception.dart';

String _url = 'https://api.munch.app/v0.17.0';
DateFormat _format = DateFormat("yyyy-MM-dd'T'HH:MM:ss");

class MunchApi {
  const MunchApi._();

  static const instance = MunchApi._();

  Map<String, String> get _headers {
    return {
      // 2018-12-20T05:18:57
      'user-local-time': _format.format(DateTime.now().toLocal()),
      // TODO User Lat Lng
      'user-lat-lng': null,
      // TODO Authentication
      'authorization': null,
    };
  }

  String _path(String path) {
    return '$_url$path';
  }

  Future<RestfulResponse> get(String path) async {
    final response = await http.get(_path(path), headers: _headers);
    return RestfulResponse._(response);
  }

  Future<RestfulResponse> put(String path, {body}) async {
    final response = await http.put(
      _path(path),
      headers: _headers,
      body: body ? json.encode(body) : null,
    );
    return RestfulResponse._(response);
  }

  Future<RestfulResponse> post(String path, {body}) async {
    final response = await http.post(
      _path(path),
      headers: _headers,
      body: body ? json.encode(body) : null,
    );
    return RestfulResponse._(response);
  }

  Future<RestfulResponse> delete(String path) async {
    final response = await http.delete(_path(path), headers: _headers);
    return RestfulResponse._(response);
  }
}

class RestfulResponse {
  int _code;
  Map<String, dynamic> _body;
  RestfulMeta _meta;

  int get code => _code;

  dynamic get data => _body['data'];

  dynamic get next => _body['next'];

  dynamic operator [](String key) => _body[key];

  RestfulResponse._(http.Response response) {
    if (response.body != null) {
      _body = json.decode(response.body);
      _meta = RestfulMeta.fromJson(_body['meta']);
    }

    _code = _meta?.code ?? response.statusCode;

    // Exception Parsing
    var exception = StructuredException.parse(_meta, response);
    if (exception != null) {
      throw exception;
    }
  }
}

class RestfulMeta {
  final int code;
  final RestfulError error;

  const RestfulMeta(this.code, this.error);

  factory RestfulMeta.fromJson(Map<String, dynamic> json) {
    RestfulError error;
    if (json.containsKey('error')) {
      dynamic error = json['error'];
      error = RestfulError(error['type'], error['message']);
    }

    return RestfulMeta(json['code'], error);
  }
}

class RestfulError {
  final String type;
  final String message;

  const RestfulError(this.type, this.message);
}
