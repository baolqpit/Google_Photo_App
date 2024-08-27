import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';

class BaseApi {
  final Dio _dio = Dio();
  final _baseUrl = "https://photoslibrary.googleapis.com/v1/";

  ///GET APP DATA FOR ALL THE API
  getAppDataFromAPI(
      {required String url,
      Map<String, dynamic>? queryParameters,
      required String token}) async {
    try {
      // print(_baseUrl + url);
      // await Future.delayed(Duration(milliseconds: 1500));
      Response<dynamic> response = await _dio.get(_baseUrl + url,
          queryParameters: queryParameters ?? null,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          ));
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        // The request was made and the server responded with a status code
        // that falls out of the range of 2xx and is also not 304.
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }
    }
  }

  ///POST APP DATA FOR ALL THE API
  Future<dynamic> postAppDataFromAPI({
    required String url,
    required String filePath,
    required String accessToken,
  }) async {
    try {
      // Read the file as bytes
      final fileBytes = await File(filePath).readAsBytes();

      // Set headers for the POST request
      final headers = {
        'Content-Type': 'application/octet-stream',
        'X-Goog-Upload-File-Name': filePath.split('/').last,
        'X-Goog-Upload-Protocol': 'raw',
        'Authorization': 'Bearer $accessToken',
      };

      Response response = await _dio.post(
        _baseUrl + url,
        data: fileBytes,
        options: Options(headers: headers),
      );

      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        print('Error sending request!');
        print(e.message);
      }
    } catch (e) {
      print('Unexpected error: $e');
    }
  }

  ///PUT APP DATA FOR ALL THE API
  putPetCareAppDataFromApi(
      {required String url,
      Map<String, dynamic>? data,
      Map<String, dynamic>? queryParameters}) async {
    try {
      // print(_baseUrl + url);
      // await Future.delayed(Duration(milliseconds: 1500));
      Response<dynamic> response = await _dio.put(_baseUrl + url,
          queryParameters: queryParameters ?? null,
          data: data ?? null,
          options: Options(contentType: 'application/json'));
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        // The request was made and the server responded with a status code
        // that falls out of the range of 2xx and is also not 304.
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }
    }
  }

  ///DELETE APP DATA FOR ALL THE API
  deletePetCareAppDataFromApi(
      {required String url, Map<String, dynamic>? queryParameters}) async {
    try {
      // print(_baseUrl + url);
      // await Future.delayed(Duration(milliseconds: 1500));
      Response<dynamic> response = await _dio.delete(_baseUrl + url,
          queryParameters: queryParameters ?? null,
          options: Options(contentType: 'application/json'));
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        // The request was made and the server responded with a status code
        // that falls out of the range of 2xx and is also not 304.
        print('Dio error!');
        print('STATUS: ${e.response?.statusCode}');
        print('DATA: ${e.response?.data}');
        print('HEADERS: ${e.response?.headers}');
      } else {
        // Error due to setting up or sending the request
        print('Error sending request!');
        print(e.message);
      }
    }
  }
}
