import 'package:flutter/material.dart';
class SpeechBubble extends StatelessWidget {
  final Widget child;
  final double triangleWidth;
  final double triangleHeight;
  final double radius;
  //final Color borderColor;
  final Color backgroundColor;
  //final double borderWidth;

  const SpeechBubble({
    super.key,
    required this.child,
    this.triangleWidth = 16,
    this.triangleHeight = 8,
    this.radius = 12,
    //this.borderColor = Colors.black,
    this.backgroundColor = Colors.white,
   // this.borderWidth = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    // Le CustomPaint s'adapte à la taille du child grâce au Child dans CustomPaint.
    return CustomPaint(
      painter: _SpeechBubblePainter(
        triangleWidth: triangleWidth,
        triangleHeight: triangleHeight,
        radius: radius,
        //borderColor: borderColor,
        backgroundColor: backgroundColor,
        //borderWidth: borderWidth,
      ),
      child: Padding(
        // On ajoute un padding inférieur pour laisser de la place à la pointe
        padding: EdgeInsets.fromLTRB(12, 10, 12, 10 + triangleHeight),
        child: child,
      ),
    );
  }
}

class _SpeechBubblePainter extends CustomPainter {
  final double triangleWidth;
  final double triangleHeight;
  final double radius;
  //final Color borderColor;
  final Color backgroundColor;
  //final double borderWidth;

  _SpeechBubblePainter({
    required this.triangleWidth,
    required this.triangleHeight,
    required this.radius,
    //required this.borderColor,
    required this.backgroundColor,
    //required this.borderWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    if (w <= 0 || h <= 0) return;

    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, w, h - triangleHeight),
      Radius.circular(0),
    );

    final Path path = Path()..addRRect(rrect);

    // Pointe à droite
    final double rightOffset = w - 80; // ajuste cette valeur si besoin
    final Path triangle = Path()
      ..moveTo(rightOffset - triangleWidth / 2, h - triangleHeight)
      ..lineTo(rightOffset, h)
      ..lineTo(rightOffset + triangleWidth / 2, h - triangleHeight)
      ..close();

    path.addPath(triangle, Offset.zero);

    // --- Ombre douce ---
    canvas.drawShadow(path, Colors.black.withOpacity(0.25), 4, true);

    // Fond
    final Paint fill = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fill);

    // Bordure
    final Paint stroke = Paint()
      //..color = borderColor
      ..style = PaintingStyle.stroke;
      //..strokeWidth = borderWidth;
    canvas.drawPath(path, stroke);
  }

  @override
  bool shouldRepaint(covariant _SpeechBubblePainter oldDelegate) {
    return oldDelegate.triangleHeight != triangleHeight ||
        oldDelegate.triangleWidth != triangleWidth ||
        oldDelegate.radius != radius ||
        //oldDelegate.borderColor != borderColor ||
        //oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.backgroundColor != backgroundColor ;
        //oldDelegate.borderWidth != borderWidth;
  }
}

