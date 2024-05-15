class NumberSnap {
  ///The number determining whether to snap or not.
  final double parameter;

  ///Effectively offsets [parameter] by [threshold].
  ///A higher [threshold] requires a higher [parameter] to snap and vice-versa.
  ///The default value is 0.
  final double threshold;

  ///The snapped number.
  final double snapped;

  ///The unsnapped number. The default value is [double.infinity].
  final double unsnapped;

  const NumberSnap({
    required this.parameter,
    required this.snapped,
    this.unsnapped = double.infinity,
    this.threshold = 0,
  });

  ///Returns [snapped] if [isSnapped], else returns [unsnapped].
  ///By making any parameter non-null, you override the respective field value locally,
  ///meaning the specified value will be used rather than the already specified field value.
  double snapNumber({
    double? ovrParameter,
    double? ovrThreshold,
    double? ovrSnapped,
    double? ovrUnsnapped,
  }) {
    return isSnapped(
      ovrParameter: ovrParameter,
      ovrThreshold: ovrThreshold,
    )
        ? (ovrSnapped ?? snapped)
        : (ovrUnsnapped ?? unsnapped);
  }

  ///Returns [parameter] > [threshold].
  ///By making any parameter non-null, you override the respective field value locally,
  ///meaning the specified value will be used rather than the already specified field value.
  bool isSnapped({
    double? ovrParameter,
    double? ovrThreshold,
  }) {
    return (ovrParameter ?? parameter) > (ovrThreshold ?? threshold);
  }
}
