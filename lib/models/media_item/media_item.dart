import 'package:freezed_annotation/freezed_annotation.dart';

part 'media_item.freezed.dart';
part 'media_item.g.dart';

@freezed
class MediaItem with _$MediaItem {
  const factory MediaItem({
    @JsonKey(name: 'id') String? id,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'productUrl') String? productUrl,
    @JsonKey(name: 'baseUrl') String? baseUrl,
  }) = _MediaItem;

  factory MediaItem.fromJson(Map<String, dynamic> json) =>
      _$MediaItemFromJson(json);
}
