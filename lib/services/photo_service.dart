import 'dart:io';

import 'package:dio/dio.dart';

class PhotoService {
  final Dio dio = Dio();
  final _uploadBaseURL = 'https://photoslibrary.googleapis.com/v1/';

  ///UPLOAD IMAGES TO GOOGLE PHOTOS
  Future<String?> uploadImagesToGooglePhotos(
      {required String filePath, required String accessToken}) async {
    try {
      final imageBytes = await File(filePath).readAsBytes();
      Response response = await dio.post("${_uploadBaseURL}uploads",
          data: imageBytes,
          options: Options(
            headers: {
              'Content-type': 'application/octet-stream',
              'X-Goog-Upload-File-Name': filePath.split('/').last,
              'X-Goog-Upload-Protocol': 'raw',
              'Authorization': 'Bearer $accessToken',
            },
          ));
      if (response.statusCode == 200) {
        print('Upload successful: ${response.data}');
        return response.data;  // Upload token returned
      } else {
        print('Failed to upload image: ${response.statusCode}');
        return null;
      }
    } on DioException catch (e) {
      print('Dio error: ${e.response?.statusCode} ${e.response?.data}');
      return null;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  ///CREATE MEDIA ITEMS
  Future<void> createMediaItems({required String uploadToken, required String accessToken}) async {
    try {
      final data = {
        "newMediaItems": [
          {
            "description": "Upload From Photo App",
            'simpleMediaItem': {
              'uploadToken': uploadToken,
            }
          }
        ]
      };
      Response response = await dio.post(
        "${_uploadBaseURL}mediaItems:batchCreate",
        data: data,
        options: Options(
          headers: {
            'Content-type': 'application/json',
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
      if (response.statusCode == 200) {
        print('Media item created successfully: ${response.data}');
      } else {
        print('Failed to create media item: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('Dio error: ${e.response?.statusCode} ${e.response?.data}');
    } catch (e) {
      print('Error creating media item: $e');
    }
  }
}
