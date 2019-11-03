import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'package:movies_app/config/all.dart';
import 'package:movies_app/config/keys.dart';

class ApiClient extends DioMixin {
  List<Function> callbacks = [];

  ApiClient() {
    httpClientAdapter = DefaultHttpClientAdapter();

    interceptors.add(PrettyDioLogger());
    interceptors.add(InterceptorsWrapper(
      onError: (DioError dioError) {
        if (dioError.response.statusCode == HttpStatus.unauthorized) {
          callbacks.forEach((function) => function());
        }
      },
    ));
  }

  void setUnauthorizedCallback(Function callback) {
    callbacks.add(callback);
  }

  ApiClient setBaseUrl(String baseUrl) {
    this.options ??= BaseOptions();
    this.options.baseUrl = baseUrl;

    return this;
  }

  ApiClient setContentType(String contentType) {
    this.setHeaders({"Content-Type": contentType});

    return this;
  }

  ApiClient setHeaders(Map<String, dynamic> headers) {
    this.options ??= BaseOptions();
    this.options.headers = headers;

    return this;
  }

  ApiClient setAuthorizationHeader(String value) {
    this.setHeaders({Keys.authorizationHeader: "Bearer $value"});

    return this;
  }
}
