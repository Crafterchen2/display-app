import 'package:json_annotation/json_annotation.dart';

part 'limits.g.dart';

@JsonSerializable()
class Limits {
  final double max_current;
  final int nr_of_phases_available;
  final String uuid;

  Limits(this.max_current, this.nr_of_phases_available, this.uuid);

  factory Limits.fromJson(Map<String, dynamic> json) => _$LimitsFromJson(json);

  Map<String, dynamic> toJson() => _$LimitsToJson(this);
}
