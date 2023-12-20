import 'dart:io';

import 'package:dio/dio.dart';

const _kDefaultConnectTimeout = Duration.millisecondsPerMinute;
const _kDefaultReceiveTimeout = Duration.millisecondsPerMinute;

// Resolve XMLRequest error
// adb reverse tcp:8090 tcp:8090
// flutter run -d chrome --web-port=54349 --web-hostname 192.168.2.41

class DioService {
  final String baseUrl;
  final Dio _dio;
  final List<Interceptor> interceptors;

  DioService(
    this.baseUrl,
    Dio dio, {
    this.interceptors = const [],
  }) : _dio = Dio() {
    _dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout =
          const Duration(milliseconds: _kDefaultConnectTimeout)
      ..options.receiveTimeout =
          const Duration(milliseconds: _kDefaultReceiveTimeout)
      ..httpClientAdapter
      ..options.headers = {'Content-Type': 'application/json; charset=UTF-8'};
    if (interceptors.isNotEmpty) {
      _dio.interceptors.addAll(interceptors);
    }
  }

  Future<dynamic> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> post(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }

  Future<dynamic> put(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on FormatException catch (_) {
      throw FormatException("Unable to process the data");
    } catch (e) {
      throw e;
    }
  }
}
