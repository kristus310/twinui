part of '../../styled_widget.dart';

extension StyledText<T extends Text> on T {
  T copyWith({
    Key? key,
    String? data,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    double? textScaleFactor,
    TextScaler? textScaler,
    int? maxLines,
    String? semanticsLabel,
    String? semanticsIdentifier,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,
  }) {
    if (this is _StyledAnimatedTextContainer) {
      // The animated container only supports a subset of Text's properties.
      return _StyledAnimatedTextContainer(
        data ?? this.data ?? '',
        style: style ?? this.style,
        strutStyle: strutStyle ?? this.strutStyle,
        textAlign: textAlign ?? this.textAlign,
        locale: locale ?? this.locale,
        maxLines: maxLines ?? this.maxLines,
        overflow: overflow ?? this.overflow,
        semanticsLabel: semanticsLabel ?? this.semanticsLabel,
        softWrap: softWrap ?? this.softWrap,
        textDirection: textDirection ?? this.textDirection,
        textScaleFactor: textScaleFactor ?? this.textScaleFactor,
        textWidthBasis: textWidthBasis ?? this.textWidthBasis,
      ) as T;
    }

    // ignore: deprecated_member_use
    final double? oldFactor = this.textScaleFactor;
    final TextScaler? scaler = textScaler ??
        (textScaleFactor != null ? TextScaler.linear(textScaleFactor) : null) ??
        this.textScaler ??
        (oldFactor != null ? TextScaler.linear(oldFactor) : null);

    final String? newData = data ?? this.data;
    if (newData != null) {
      return Text(
        newData,
        key: key ?? this.key,
        style: style ?? this.style,
        strutStyle: strutStyle ?? this.strutStyle,
        textAlign: textAlign ?? this.textAlign,
        textDirection: textDirection ?? this.textDirection,
        locale: locale ?? this.locale,
        softWrap: softWrap ?? this.softWrap,
        overflow: overflow ?? this.overflow,
        textScaler: scaler,
        maxLines: maxLines ?? this.maxLines,
        semanticsLabel: semanticsLabel ?? this.semanticsLabel,
        semanticsIdentifier: semanticsIdentifier ?? this.semanticsIdentifier,
        textWidthBasis: textWidthBasis ?? this.textWidthBasis,
        textHeightBehavior: textHeightBehavior ?? this.textHeightBehavior,
        selectionColor: selectionColor ?? this.selectionColor,
      ) as T;
    }
    return Text.rich(
      this.textSpan!,
      key: key ?? this.key,
      style: style ?? this.style,
      strutStyle: strutStyle ?? this.strutStyle,
      textAlign: textAlign ?? this.textAlign,
      textDirection: textDirection ?? this.textDirection,
      locale: locale ?? this.locale,
      softWrap: softWrap ?? this.softWrap,
      overflow: overflow ?? this.overflow,
      textScaler: scaler,
      maxLines: maxLines ?? this.maxLines,
      semanticsLabel: semanticsLabel ?? this.semanticsLabel,
      semanticsIdentifier: semanticsIdentifier ?? this.semanticsIdentifier,
      textWidthBasis: textWidthBasis ?? this.textWidthBasis,
      textHeightBehavior: textHeightBehavior ?? this.textHeightBehavior,
      selectionColor: selectionColor ?? this.selectionColor,
    ) as T;
  }

  T textStyle(TextStyle style) => copyWith(
        style: (this.style ?? const TextStyle()).copyWith(
          background: style.background,
          backgroundColor: style.backgroundColor,
          color: style.color,
          debugLabel: style.debugLabel,
          decoration: style.decoration,
          decorationColor: style.decorationColor,
          decorationStyle: style.decorationStyle,
          decorationThickness: style.decorationThickness,
          fontFamily: style.fontFamily,
          fontFamilyFallback: style.fontFamilyFallback,
          fontFeatures: style.fontFeatures,
          fontVariations: style.fontVariations,
          leadingDistribution: style.leadingDistribution,
          overflow: style.overflow,
          fontSize: style.fontSize,
          fontStyle: style.fontStyle,
          fontWeight: style.fontWeight,
          foreground: style.foreground,
          height: style.height,
          inherit: style.inherit,
          letterSpacing: style.letterSpacing,
          locale: style.locale,
          shadows: style.shadows,
          textBaseline: style.textBaseline,
          wordSpacing: style.wordSpacing,
        ),
      );

  T textScale(double scaleFactor) =>
      copyWith(textScaleFactor: scaleFactor);

  T bold() => copyWith(
        style: (style ?? const TextStyle()).copyWith(
          fontWeight: FontWeight.bold,
        ),
      );

  T italic() => copyWith(
        style: (style ?? const TextStyle()).copyWith(
          fontStyle: FontStyle.italic,
        ),
      );

  T fontWeight(FontWeight? fontWeight) => copyWith(
        style: (style ?? const TextStyle()).copyWith(
          fontWeight: fontWeight,
        ),
      );

  T fontSize(double? size) => copyWith(
        style: (style ?? const TextStyle()).copyWith(
          fontSize: size,
        ),
      );

  T fontFamily(String? font) => copyWith(
        style: (style ?? const TextStyle()).copyWith(
          fontFamily: font,
        ),
      );

  T letterSpacing(double? space) => copyWith(
        style: (style ?? const TextStyle()).copyWith(
          letterSpacing: space,
        ),
      );

  T wordSpacing(double? space) => copyWith(
        style: (style ?? const TextStyle()).copyWith(
          wordSpacing: space,
        ),
      );

  T textShadow({
    Color color = const Color(0x33000000),
    double blurRadius = 0.0,
    Offset offset = Offset.zero,
  }) =>
      copyWith(
        style: (style ?? const TextStyle()).copyWith(
          shadows: [
            Shadow(
              color: color,
              blurRadius: blurRadius,
              offset: offset,
            ),
          ],
        ),
      );

  T textElevation(
    double elevation, {
    double angle = 0.0,
    Color color = const Color(0x33000000),
    double opacityRatio = 1.0,
  }) {
    final double calculatedOpacity =
        _elevationOpacityCurve(elevation) * opacityRatio;

    final Shadow shadow = Shadow(
      color: color.withOpacity(calculatedOpacity),
      blurRadius: elevation,
      offset: Offset(sin(angle) * elevation, cos(angle) * elevation),
    );
    return copyWith(
      style: (style ?? const TextStyle()).copyWith(
        shadows: [
          shadow,
        ],
      ),
    );
  }

  T textColor(Color? color) => copyWith(
        style: (style ?? const TextStyle()).copyWith(
          color: color,
        ),
      );

  T textAlignment(TextAlign? align) => copyWith(textAlign: align);

  T textDirection(TextDirection? direction) =>
      copyWith(textDirection: direction);

  T textBaseline(TextBaseline? textBaseline) => copyWith(
        style: (style ?? const TextStyle()).copyWith(
          textBaseline: textBaseline,
        ),
      );

  T textWidthBasis(TextWidthBasis? textWidthBasis) =>
      copyWith(textWidthBasis: textWidthBasis);
}
