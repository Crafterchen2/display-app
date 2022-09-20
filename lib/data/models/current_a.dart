import 'package:json_annotation/json_annotation.dart';

part 'current_a.g.dart';

@JsonSerializable()
class CurrentA {
  final double L1;
  final double L2;
  final double L3;
  final double N;

  CurrentA(this.L1, this.L2, this.L3, this.N);

  factory CurrentA.fromJson(Map<String, dynamic> json) =>
      _$CurrentAFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentAToJson(this);
}





