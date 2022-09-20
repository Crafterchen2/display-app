import 'package:json_annotation/json_annotation.dart';

part 'frequency_hz.g.dart';

@JsonSerializable()
class FrequencyHz {
  final double L1;
  final double L2;
  final double L3;

  FrequencyHz(this.L1, this.L2, this.L3);

  factory FrequencyHz.fromJson(Map<String, dynamic> json) =>
      _$FrequencyHzFromJson(json);

  Map<String, dynamic> toJson() => _$FrequencyHzToJson(this);
}





