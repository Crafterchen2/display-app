import 'package:json_annotation/json_annotation.dart';

part 'power_w.g.dart';

@JsonSerializable()
class PowerW {
  final double L1;
  final double L2;
  final double L3;
  final double total;

  PowerW(this.L1, this.L2, this.L3, this.total);

  factory PowerW.fromJson(Map<String, dynamic> json) =>
      _$PowerWFromJson(json);

  Map<String, dynamic> toJson() => _$PowerWToJson(this);
}





