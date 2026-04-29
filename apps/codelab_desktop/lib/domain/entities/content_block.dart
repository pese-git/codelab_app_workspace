import 'package:freezed_annotation/freezed_annotation.dart';

part 'content_block.freezed.dart';
part 'content_block.g.dart';

@Freezed(unionKey: 'type', fallbackUnion: 'text')
sealed class ContentBlock with _$ContentBlock {
  const factory ContentBlock.text({required String text}) = TextContentBlock;

  const factory ContentBlock.image({
    required String data,
    required String mimeType,
    String? uri,
  }) = ImageContentBlock;

  const factory ContentBlock.audio({
    required String data,
    required String mimeType,
  }) = AudioContentBlock;

  const factory ContentBlock.resourceLink({
    required String uri,
    required String name,
  }) = ResourceLinkContentBlock;

  const factory ContentBlock.resource({
    required Map<String, dynamic> resource,
  }) = EmbeddedResourceContentBlock;

  factory ContentBlock.fromJson(Map<String, dynamic> json) =>
      _$ContentBlockFromJson(json);
}
