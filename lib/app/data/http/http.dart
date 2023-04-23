import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../../domain/either/either.dart';
import '../../domain/typedefs.dart';
part 'failure.dart';
part 'parse_response_body.dart';

class Http {
  Http({
    required String baseUrl,
    required String apiKey,
    required Client client,
  })  : _client = client,
        _apiKey = apiKey,
        _baseUrl = baseUrl;
  final Client _client;
  final String _baseUrl;
  final String _apiKey;

  Future<Either<HttpFailure, R>> request<R>(
    String path, {
    required R Function(dynamic) onSuccess,
    HttpMethod method = HttpMethod.get,
    Map<String, String> headers = const {},
    Map<String, String> queryParameters = const {},
    Json body = const {},
    bool useApiKey = true,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    Json logs = {};
    try {
      if (useApiKey) {
        queryParameters = {
          ...queryParameters,
          'api_key': _apiKey,
        };
      }
      Uri url = Uri.parse(
        path.startsWith('http') ? path : '$_baseUrl$path',
      );
      if (queryParameters.isNotEmpty) {
        url = url.replace(
          queryParameters: queryParameters,
        );
      }
      headers = {
        'Content-Type': 'application/json',
        ...headers,
      };
      late final Response response;
      final bodyString = jsonEncode(body);
      logs = {
        'url': url.toString(),
        'method': method.name,
        'body': body,
      };
      switch (method) {
        case HttpMethod.get:
          response = await _client.get(url).timeout(timeout);
          break;
        case HttpMethod.post:
          response = await _client
              .post(
                url,
                headers: headers,
                body: bodyString,
              )
              .timeout(timeout);
          break;
        case HttpMethod.patch:
          response = await _client
              .patch(
                url,
                headers: headers,
                body: bodyString,
              )
              .timeout(timeout);
          break;
        case HttpMethod.delete:
          response = await _client
              .delete(
                url,
                headers: headers,
                body: bodyString,
              )
              .timeout(timeout);
          break;
        case HttpMethod.put:
          response = await _client
              .put(
                url,
                headers: headers,
                body: bodyString,
              )
              .timeout(timeout);
          break;
      }
      final statusCode = response.statusCode;
      final responseBody = _parseResponseBody(response.body);
      logs = {
        ...logs,
        'statusCode': statusCode,
        'responseBody': responseBody,
      };
      if (statusCode >= 200 && statusCode < 300) {
        return Either.right(
          onSuccess(
            responseBody,
          ),
        );
      }
      return Either.left(
        HttpFailure(
          statusCode: statusCode,
          data: responseBody,
        ),
      );
    } catch (e, stackTrace) {
      logs = {
        ...logs,
        'exception': e.runtimeType.toString(),
        'stackTrace': stackTrace.toString(),
      };
      if (e is SocketException || e is ClientException) {
        logs = {
          ...logs,
          'exception': 'NetworkException',
        };
        return Either.left(
          HttpFailure(
            exception: NetworkException(),
          ),
        );
      }
      return Either.left(
        HttpFailure(
          exception: e,
        ),
      );
    } finally {
      //print(const JsonEncoder.withIndent(' ').convert(logs));
    }
  }
}

enum HttpMethod {
  get,
  post,
  patch,
  delete,
  put,
}
