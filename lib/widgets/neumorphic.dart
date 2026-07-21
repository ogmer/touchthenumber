import 'package:flutter/material.dart';

/// ニューモフィズム（Soft UI）の配色。
/// 背景・要素で共有する単色ベースと、左上のハイライト／右下の影を保持する。
///
/// ベース色は [ThemeData.scaffoldBackgroundColor]（テーマ色から導出した淡い面）を
/// そのまま使い、そこから2方向の影を計算する。アクセントは colorScheme.primary。
class NeumorphicPalette {
  final Color base;
  final Color lightShadow;
  final Color darkShadow;
  final Color accent;
  final Color onBase;

  const NeumorphicPalette({
    required this.base,
    required this.lightShadow,
    required this.darkShadow,
    required this.accent,
    required this.onBase,
  });

  factory NeumorphicPalette.of(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.scaffoldBackgroundColor;
    final hsl = HSLColor.fromColor(base);

    // 左上ハイライトはほぼ白、右下の影は同系色を暗くしたもの。
    // ベースの色相を共有することで、テーマ色ごとに影も自然になじむ。
    final light = hsl
        .withSaturation((hsl.saturation * 0.4).clamp(0.0, 0.4))
        .withLightness((hsl.lightness + 0.08).clamp(0.0, 1.0))
        .toColor();
    final dark = hsl
        .withSaturation((hsl.saturation * 1.6).clamp(0.0, 0.30))
        .withLightness((hsl.lightness - 0.14).clamp(0.0, 1.0))
        .toColor();

    return NeumorphicPalette(
      base: base,
      lightShadow: light,
      darkShadow: dark,
      accent: theme.colorScheme.primary,
      onBase: theme.colorScheme.onSurface,
    );
  }
}

/// ニューモフィズムの見た目の種類。
/// - [raised]: 面から浮き上がって見える（既定）
/// - [pressed]: 面にへこんで見える（選択中・押下中）
/// - [flat]: 影のない平面
enum NeumorphicStyle { raised, pressed, flat }

/// 柔らかく押し出された／へこんだ面を描く汎用コンテナ。
class NeumorphicContainer extends StatelessWidget {
  final Widget? child;
  final NeumorphicStyle style;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final BoxShape shape;

  /// 影の距離・ぼかしの強さ。要素が大きいほど大きめにすると自然。
  final double depth;

  /// ベースの代わりに使う面の色（アクセント面などに使用）。
  final Color? color;

  const NeumorphicContainer({
    super.key,
    this.child,
    this.style = NeumorphicStyle.raised,
    this.borderRadius = 20,
    this.padding,
    this.shape = BoxShape.rectangle,
    this.depth = 6,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final palette = NeumorphicPalette.of(context);
    final surface = color ?? palette.base;

    if (style == NeumorphicStyle.pressed) {
      return CustomPaint(
        painter: _InsetShadowPainter(
          base: surface,
          lightShadow: palette.lightShadow,
          darkShadow: palette.darkShadow,
          radius: borderRadius,
          shape: shape,
          distance: depth * 0.6,
          blur: depth,
        ),
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
        ),
      );
    }

    final shadows = style == NeumorphicStyle.flat
        ? const <BoxShadow>[]
        : <BoxShadow>[
            BoxShadow(
              color: palette.darkShadow,
              offset: Offset(depth * 0.65, depth * 0.65),
              blurRadius: depth * 1.6,
            ),
            BoxShadow(
              color: palette.lightShadow,
              offset: Offset(-depth * 0.65, -depth * 0.65),
              blurRadius: depth * 1.6,
            ),
          ];

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: surface,
        shape: shape,
        borderRadius: shape == BoxShape.rectangle
            ? BorderRadius.circular(borderRadius)
            : null,
        boxShadow: shadows,
      ),
      child: child,
    );
  }
}

/// 押すとへこむニューモフィズム風ボタン。
class NeumorphicButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final BoxShape shape;
  final double depth;

  /// 面をアクセント色で塗る（主要アクション用）。
  final bool accent;

  const NeumorphicButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.borderRadius = 20,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    this.shape = BoxShape.rectangle,
    this.depth = 6,
    this.accent = false,
  });

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final palette = NeumorphicPalette.of(context);
    final enabled = widget.onPressed != null;
    final surface = widget.accent ? palette.accent : palette.base;

    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
      onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
      onTap: widget.onPressed,
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : 0.5,
        duration: const Duration(milliseconds: 150),
        child: NeumorphicContainer(
          style: _pressed ? NeumorphicStyle.pressed : NeumorphicStyle.raised,
          borderRadius: widget.borderRadius,
          shape: widget.shape,
          padding: widget.padding,
          depth: widget.depth,
          color: surface,
          child: Center(
            widthFactor: 1,
            heightFactor: 1,
            child: DefaultTextStyle.merge(
              style: TextStyle(
                color: widget.accent ? Colors.white : palette.accent,
                fontWeight: FontWeight.bold,
              ),
              child: IconTheme.merge(
                data: IconThemeData(
                  color: widget.accent ? Colors.white : palette.accent,
                ),
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 円形のニューモフィズム風アイコンボタン（AppBarのアクション等に使用）。
class NeumorphicIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double size;
  final Color? iconColor;

  const NeumorphicIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.size = 44,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final palette = NeumorphicPalette.of(context);
    final button = NeumorphicButton(
      onPressed: onPressed,
      shape: BoxShape.circle,
      borderRadius: size / 2,
      depth: 4,
      padding: EdgeInsets.zero,
      child: SizedBox(
        width: size,
        height: size,
        child: Icon(icon, color: iconColor ?? palette.accent, size: size * 0.5),
      ),
    );
    if (tooltip == null) return button;
    return Tooltip(message: tooltip!, child: button);
  }
}

/// へこんだ内側の影を描くペインタ。Flutterの BoxShadow は inset 非対応のため、
/// 角丸矩形/円にクリップした状態で、内側に少しずらしたぼかしストロークを重ねて表現する。
class _InsetShadowPainter extends CustomPainter {
  final Color base;
  final Color lightShadow;
  final Color darkShadow;
  final double radius;
  final double distance;
  final double blur;
  final BoxShape shape;

  _InsetShadowPainter({
    required this.base,
    required this.lightShadow,
    required this.darkShadow,
    required this.radius,
    required this.distance,
    required this.blur,
    required this.shape,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final RRect rrect = shape == BoxShape.circle
        ? RRect.fromRectAndRadius(rect, Radius.circular(size.shortestSide / 2))
        : RRect.fromRectAndRadius(rect, Radius.circular(radius));

    canvas.drawRRect(rrect, Paint()..color = base);

    canvas.save();
    canvas.clipRRect(rrect);

    final blurFilter = MaskFilter.blur(BlurStyle.normal, blur);

    // 右下方向にずらした暗い影 → クリップにより左上の内側に暗さが残る
    final darkPaint = Paint()
      ..color = darkShadow
      ..style = PaintingStyle.stroke
      ..strokeWidth = distance * 2
      ..maskFilter = blurFilter;
    canvas.drawRRect(rrect.shift(Offset(distance, distance)), darkPaint);

    // 左上方向にずらした明るい影 → 右下の内側に明るさが残る
    final lightPaint = Paint()
      ..color = lightShadow
      ..style = PaintingStyle.stroke
      ..strokeWidth = distance * 2
      ..maskFilter = blurFilter;
    canvas.drawRRect(rrect.shift(Offset(-distance, -distance)), lightPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(_InsetShadowPainter old) =>
      old.base != base ||
      old.lightShadow != lightShadow ||
      old.darkShadow != darkShadow ||
      old.radius != radius ||
      old.distance != distance ||
      old.blur != blur ||
      old.shape != shape;
}
