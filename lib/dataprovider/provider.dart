import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Provider {
  static final storage = FlutterSecureStorage();
  static Future<void> storeTokens(
      String accessToken, String refreshToken) async {
    await storage.write(key: 'accessToken', value: accessToken);
    await storage.write(key: 'refreshToken', value: refreshToken);
  }

  static Dio dio = Dio(
    BaseOptions(
      //baseUrl: 'http://192.168.1.6:8000',
      baseUrl: 'https://nrkdfs8q-8000.uks1.devtunnels.ms/',
    ),
  );
  static Future<String> refreshToken() async {
    try {
      String refresh = await storage.read(key: "refreshToken") ?? "";

      Response response = await dio.post(
        '/api/auth/refresh/',
        data: {'refresh': refresh},
      );
      //  print(response.data);
      Map<String, dynamic> data = response.data;
      return data['access'];
    } on DioException catch (e) {
      throw Exception("Error message ${e.message}");
    }
  }

  static void addInterceptor() {
    dio.interceptors.add(RequestInterceptor());
  }
}

class RequestInterceptor extends Interceptor {
  @override
  void onError(DioException err, handler) async {
    if (err.response?.statusCode == 401) {
      // If a 401 response is received, refresh the access token
      String newAccessToken = await Provider.refreshToken();

      // Update the request header with the new access token
      err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

      // Repeat the request with the updated header
      return handler.resolve(await Provider.dio.fetch(err.requestOptions));
    }
    return handler.next(err);
  }

  @override
  void onRequest(options, handler) async {
    // Add the access token to the request header
    String access = await Provider.storage.read(key: "accessToken") ?? "";
    options.headers['Authorization'] = 'Bearer $access';
    return handler.next(options);
  }
}

// export 'provider.dart';