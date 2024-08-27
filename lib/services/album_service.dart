import 'package:dio/dio.dart';

class AlbumService {
  final Dio dio = Dio();
  final _baseAlbumURL = 'https://photoslibrary.googleapis.com/v1/';
  ///CREATE ALBUM
  /// GET LIST OF ALBUMS
  Future<List<dynamic>> getAlbums({required String accessToken}) async {
    List<dynamic> albumsList = [];
    String? nextPageToken;

    try {
      do {
        final response = await dio.get(
          '${_baseAlbumURL}albums',
          queryParameters: {
            'pageSize': 50, // You can adjust this number based on your needs
            'pageToken': nextPageToken,
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            },
          ),
        );

        if (response.statusCode == 200) {
          final data = response.data;
          final albums = data['albums'] ?? [];
          albumsList.addAll(albums);
          nextPageToken = data['nextPageToken'];
        } else {
          print('Failed to retrieve album list: ${response.statusCode}');
          break;
        }
      } while (nextPageToken != null);
    } on DioException catch (e) {
      print('Error retrieving albums: ${e.response?.data ?? e.message}');
    } catch (e) {
      print('An unexpected error occurred: $e');
    }

    return albumsList;
  }
}