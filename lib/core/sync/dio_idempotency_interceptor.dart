import 'package:dio/dio.dart';

class DioIdempotencyInterceptor extends Interceptor {
  final String Function()? idempotencyKeyProvider;
  final String Function()? clientCuidProvider;

  DioIdempotencyInterceptor({
    this.idempotencyKeyProvider,
    this.clientCuidProvider,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final extraHeaders = options.extra['_outboxHeaders'] as Map<String, String>?;

    if (extraHeaders != null) {
      if (extraHeaders.containsKey('Idempotency-Key')) {
        options.headers['Idempotency-Key'] = extraHeaders['Idempotency-Key'];
      }
      if (extraHeaders.containsKey('X-Client-Cuid')) {
        options.headers['X-Client-Cuid'] = extraHeaders['X-Client-Cuid'];
      }
    }

    handler.next(options);
  }
}
