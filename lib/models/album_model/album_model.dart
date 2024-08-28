import 'package:freezed_annotation/freezed_annotation.dart';

part 'album_model.freezed.dart';
part 'album_model.g.dart';

@freezed
class AlbumModel with _$AlbumModel {
  const factory AlbumModel({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'title') String? title,
    @JsonKey(name: 'productUrl') String? productUrl,
    @JsonKey(name: 'isWriteable') bool? isWriteable,
    @JsonKey(name: 'mediaItemsCount') String? mediaItemsCount,
    @JsonKey(name: 'coverPhotoBaseUrl') String? coverPhotoBaseUrl,
    @JsonKey(name: 'coverPhotoMediaItemId') String? coverPhotoMediaItemId,

  }) = _AlbumModel;

  factory AlbumModel.fromJson(Map<String, dynamic> json) =>
      _$AlbumModelFromJson(json);
}
