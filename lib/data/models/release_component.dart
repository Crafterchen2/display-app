import 'package:json_annotation/json_annotation.dart';

part 'release_component.g.dart';

@JsonSerializable()
class ReleaseComponent {
  final String name;
  final String version;
  final String description;
  final String license;

  ReleaseComponent(this.name, this.version, this.description, this.license);

  factory ReleaseComponent.fromJson(Map<String, dynamic> json) =>
      _$ReleaseComponentFromJson(json);

  Map<String, dynamic> toJson() => _$ReleaseComponentToJson(this);
}
