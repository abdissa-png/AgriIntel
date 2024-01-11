import 'package:crop_recommendation/dataprovider/provider.dart';
import 'package:crop_recommendation/model/login_model.dart';
import 'package:crop_recommendation/model/user_model.dart';
import 'package:dio/dio.dart';

Future<Object> login(Login loginData) async {
  try {
    print("${loginData.email} ${loginData.password}");
    dynamic response = await Provider.dio.post(
      '/api/auth/login/',
      data: {"email": loginData.email, "password": loginData.password},
    );
    // print(response.data);
    Map<String, dynamic> data = response.data;
    await Provider.storeTokens(data['access'], data['refresh']);
    return data;
  } on DioException catch (e) {
    // print(e.message);
    throw Exception("Error message ${e.message}");
  }
}

Future<Object> register(User user) async {
  try {
    dynamic response = await Provider.dio.post(
      '/api/auth/register/',
      data: {
        'username': user.username,
        'email': user.email,
        'first_name': user.firstName,
        'last_name': user.lastName,
        'password': user.password
      },
    );
    //  print(response.data);
    Map<String, dynamic> data = response.data;
    await Provider.storeTokens(data['access'], data['refresh']);
    return data;
  } on DioException catch (e) {
    throw Exception("Error message ${e.message}");
  }
}
