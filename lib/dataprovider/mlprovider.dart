import 'dart:io';

import 'package:crop_recommendation/dataprovider/provider.dart';
import 'package:crop_recommendation/model/recommendation_model.dart';
import 'package:dio/dio.dart';

Future<Object> cropRecommendation(RecommendationData inputdata) async {
  try {
    dynamic response = await Provider.dio.post(
      '/api/predict/Crop/',
      data: inputdata.toMap(),
    );
    // print(response.data);
    Map<String, dynamic> data = response.data;
    return data;
  } on DioException catch (e) {
    // print(e);
    throw Exception("Error message ${e.message}");
  }
}

// path names CropDisease,CropDamage,WeedDetection
Future<Map<String, dynamic>> imageRecognition(File file, String path) async {
  try {
    String fileName = file.path.split('/').last;
    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(file.path, filename: fileName),
    });
    dynamic response = await Provider.dio.post(
      '/api/predict/$path/',
      data: formData,
    );
    // print(response.data);
    Map<String, dynamic> data = response.data;
    return data;
  } on DioException catch (e) {
    print(e);
    throw Exception("Error message ${e.message}");
  }
}
