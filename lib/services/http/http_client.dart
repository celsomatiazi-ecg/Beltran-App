import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../data/exceptions/exceptions.dart';

abstract class IHttpClient {
  Future<Map<String, dynamic>> get({
    required String url,
    required Map<String, String> headers,
  });
  Future<Map<String, dynamic>> post({
    required Map<String, dynamic>? body,
    required String url,
    required Map<String, String> headers,
  });
}

// class HttpClient implements IHttpClient {
//   final client = http.Client();
//
//   @override
//   Future<Map<String, dynamic>> get({
//     required String url,
//     required Map<String, String> headers,
//   }) async {
//     log("HTTP CLIENT GET");
//     log(url);
//
//     try {
//       final response = await client.get(Uri.parse(url), headers: headers);
//       //log(headers.toString());
//       log(response.statusCode.toString());
//       //log(response.body);
//       Map<String, dynamic> bodyData = {};
//       if (response.statusCode == 401) {
//         throw UnauthorizedException();
//       }
//       if (response.body.isNotEmpty) bodyData = jsonDecode(response.body);
//       if (response.statusCode == 200) return bodyData;
//       throw bodyData['message'] ?? HttpConstants.httpUnknownError;
//     } on UnauthorizedException {
//       rethrow;
//     } on SocketException {
//       throw "Sem conexão com a internet.";
//     } on TimeoutException {
//       throw "Tempo limite excedido.";
//     } catch (e) {
//       throw "Desculpe, houve um erro e não conseguimos completar a operação!";
//     }
//   }
//
//   @override
//   Future<Map<String, dynamic>> post({
//     required body,
//     required String url,
//     Map<String, String>? headers,
//   }) async {
//     log("HTTP CLIENT POST");
//     log(url);
//
//     try {
//       var response = await client.post(
//         Uri.parse(url),
//         headers: headers,
//         body: body != null ? json.encode(body) : null,
//       );
//       // log(body.toString());
//       // log("HEADERS");
//       // log(headers.toString());
//       log(response.statusCode.toString());
//       //log(response.body);
//       Map<String, dynamic> bodyData = {};
//       if (response.statusCode == 401) {
//         throw UnauthorizedException();
//       }
//       if (response.body.isNotEmpty) bodyData = jsonDecode(response.body);
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return bodyData;
//       }
//       throw bodyData['message'] ?? HttpConstants.httpUnknownError;
//     } on UnauthorizedException {
//       rethrow;
//     } on SocketException {
//       throw "Sem conexão com a internet.";
//     } on TimeoutException {
//       throw "Tempo limite excedido.";
//     } catch (e) {
//       throw "Desculpe, houve um erro e não conseguimos completar a operação!";
//     }
//   }
// }

class HttpClient implements IHttpClient {
  final client = http.Client();

  @override
  Future<Map<String, dynamic>> get({
    required String url,
    required Map<String, String> headers,
  }) async {
    log(url);
    try {
      final response = await client.get(Uri.parse(url), headers: headers);
      log(response.statusCode.toString());
      //log(response.body);
      Map<String, dynamic> bodyData = {};
      if (response.statusCode == 401) throw UnauthorizedException();
      if (response.body.isNotEmpty) bodyData = jsonDecode(response.body);
      if (response.statusCode == 200) return bodyData;
      throw ServerException(bodyData['message']);
    } on UnauthorizedException {
      rethrow;
    } on SocketException {
      throw NetworkException();
    } on TimeoutException {
      throw TimeoutException();
    } catch (e) {
      throw UnknownException();
    }
  }

  @override
  Future<Map<String, dynamic>> post({
    required body,
    required String url,
    Map<String, String>? headers,
  }) async {
    log(url);
    try {
      var response = await client.post(
        Uri.parse(url),
        headers: headers,
        body: body != null ? json.encode(body) : null,
      );
      // log(body.toString());
      // log(headers.toString());
      log(response.statusCode.toString());
      //log(response.body);
      Map<String, dynamic> bodyData = {};
      if (response.statusCode == 401) throw UnauthorizedException();
      if (response.body.isNotEmpty) bodyData = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return bodyData;
      }
      throw ServerException(bodyData['message']);
    } on UnauthorizedException {
      rethrow;
    } on SocketException {
      throw NetworkException();
    } on TimeoutException {
      throw TimeoutException();
    } catch (e) {
      throw UnknownException();
    }
  }
}
