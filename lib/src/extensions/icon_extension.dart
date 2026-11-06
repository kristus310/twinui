part of '../../styled_widget.dart';

extension StyledIcon<T extends Icon> on T {
  T copyWith({
    double? size,
    Color? color,
    String? semanticLabel,
    TextDirection? textDirection,
  }) =>
      (this is _StyledAnimatedIconContainer
          // The animated container only supports a subset of Icon's properties.
          ? _StyledAnimatedIconContainer(
              icon,
              color: color ?? this.color,
              size: size ?? this.size,
              semanticLabel: semanticLabel ?? this.semanticLabel,
              textDirection: textDirection ?? this.textDirection,
            )
          : Icon(
              icon,
              key: key,
              size: size ?? this.size,
              fill: fill,
              weight: weight,
              grade: grade,
              opticalSize: opticalSize,
              color: color ?? this.color,
              shadows: shadows,
              semanticLabel: semanticLabel ?? this.semanticLabel,
              textDirection: textDirection ?? this.textDirection,
              applyTextScaling: applyTextScaling,
              blendMode: blendMode,
              fontWeight: fontWeight,
            )) as T;

  T iconSize(double size) => copyWith(size: size);

  T iconColor(Color color) => copyWith(color: color);
}
