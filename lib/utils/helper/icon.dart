import 'package:flutter/material.dart';


// Custom Icon Widget untuk PNG
class PngIcon extends StatelessWidget {
  final double size;
  final Color color;
  
  const PngIcon({
    Key? key,
    this.size = 24,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: CustomPaint(
        painter: PngIconPainter(color: color),
      ),
    );
  }
}

class PngIconPainter extends CustomPainter {
  final Color color;
  
  PngIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Background dokumen
    final path = Path();
    path.moveTo(size.width * 0.2, 0);
    path.lineTo(size.width * 0.7, 0);
    path.lineTo(size.width * 0.9, size.height * 0.2);
    path.lineTo(size.width * 0.9, size.height * 0.9);
    path.lineTo(size.width * 0.1, size.height * 0.9);
    path.lineTo(size.width * 0.1, 0);
    path.close();

    canvas.drawPath(path, strokePaint);
    
    // Corner fold
    final cornerPath = Path();
    cornerPath.moveTo(size.width * 0.7, 0);
    cornerPath.lineTo(size.width * 0.9, size.height * 0.2);
    cornerPath.lineTo(size.width * 0.7, size.height * 0.2);
    cornerPath.close();
    
    canvas.drawPath(cornerPath, paint);

    // PNG text
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'PNG',
        style: TextStyle(
          color: color,
          fontSize: size.width * 0.25,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        size.height * 0.4,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom Icon Widget untuk JPG
class JpgIcon extends StatelessWidget {
  final double size;
  final Color color;
  
  const JpgIcon({
    Key? key,
    this.size = 24,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: CustomPaint(
        painter: JpgIconPainter(color: color),
      ),
    );
  }
}

class JpgIconPainter extends CustomPainter {
  final Color color;
  
  JpgIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Background dokumen dengan rounded corners
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.1, 0, size.width * 0.8, size.height * 0.9),
      Radius.circular(size.width * 0.05),
    );
    
    canvas.drawRRect(rect, strokePaint);
    
    // Image placeholder icon
    final imageRect = Rect.fromLTWH(
      size.width * 0.2, 
      size.height * 0.15, 
      size.width * 0.6, 
      size.height * 0.35
    );
    canvas.drawRect(imageRect, strokePaint);
    
    // Small circle for image icon
    canvas.drawCircle(
      Offset(size.width * 0.3, size.height * 0.25),
      size.width * 0.05,
      paint,
    );

    // JPG text
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'JPG',
        style: TextStyle(
          color: color,
          fontSize: size.width * 0.22,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        size.height * 0.6,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom Icon Widget untuk JPEG
class JpegIcon extends StatelessWidget {
  final double size;
  final Color color;
  
  const JpegIcon({
    Key? key,
    this.size = 24,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: CustomPaint(
        painter: JpegIconPainter(color: color),
      ),
    );
  }
}

class JpegIconPainter extends CustomPainter {
  final Color color;
  
  JpegIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Background dokumen dengan style yang beda
    final path = Path();
    path.addRRect(RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.15, 0, size.width * 0.7, size.height * 0.85),
      Radius.circular(size.width * 0.08),
    ));
    
    canvas.drawPath(path, strokePaint);
    
    // Mountain/landscape icon untuk represent image
    final mountainPath = Path();
    mountainPath.moveTo(size.width * 0.25, size.height * 0.45);
    mountainPath.lineTo(size.width * 0.35, size.height * 0.25);
    mountainPath.lineTo(size.width * 0.45, size.height * 0.35);
    mountainPath.lineTo(size.width * 0.55, size.height * 0.2);
    mountainPath.lineTo(size.width * 0.75, size.height * 0.45);
    mountainPath.lineTo(size.width * 0.25, size.height * 0.45);
    
    canvas.drawPath(mountainPath, strokePaint);

    // JPEG text (smaller font since it's longer)
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'JPEG',
        style: TextStyle(
          color: color,
          fontSize: size.width * 0.18,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        size.height * 0.55,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom Icon Widget untuk PDF
class PdfIcon extends StatelessWidget {
  final double size;
  final Color color;
  
  const PdfIcon({
    Key? key,
    this.size = 24,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: CustomPaint(
        painter: PdfIconPainter(color: color),
      ),
    );
  }
}

class PdfIconPainter extends CustomPainter {
  final Color color;
  
  PdfIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Background dokumen dengan shadow
    final docPath = Path();
    docPath.moveTo(size.width * 0.15, size.height * 0.05);
    docPath.lineTo(size.width * 0.7, size.height * 0.05);
    docPath.lineTo(size.width * 0.85, size.height * 0.2);
    docPath.lineTo(size.width * 0.85, size.height * 0.9);
    docPath.lineTo(size.width * 0.15, size.height * 0.9);
    docPath.close();

    canvas.drawPath(docPath, strokePaint);
    
    // Corner fold untuk PDF style
    final cornerPath = Path();
    cornerPath.moveTo(size.width * 0.7, size.height * 0.05);
    cornerPath.lineTo(size.width * 0.85, size.height * 0.2);
    cornerPath.lineTo(size.width * 0.7, size.height * 0.2);
    cornerPath.close();
    
    canvas.drawPath(cornerPath, paint);

    // Lines untuk represent text content
    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Text lines
    canvas.drawLine(
      Offset(size.width * 0.25, size.height * 0.35),
      Offset(size.width * 0.75, size.height * 0.35),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.25, size.height * 0.45),
      Offset(size.width * 0.65, size.height * 0.45),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.25, size.height * 0.55),
      Offset(size.width * 0.7, size.height * 0.55),
      linePaint,
    );

    // PDF text
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'PDF',
        style: TextStyle(
          color: color,
          fontSize: size.width * 0.22,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        size.height * 0.65,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom Icon Widget untuk Docs
class DocsIcon extends StatelessWidget {
  final double size;
  final Color color;
  
  const DocsIcon({
    Key? key,
    this.size = 24,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: CustomPaint(
        painter: DocsIconPainter(color: color),
      ),
    );
  }
}

class DocsIconPainter extends CustomPainter {
  final Color color;
  
  DocsIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Multiple documents effect (stack of papers)
    // Background document (slightly offset)
    final bgDocRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.2, size.height * 0.1, size.width * 0.65, size.height * 0.75),
      Radius.circular(size.width * 0.04),
    );
    canvas.drawRRect(bgDocRect, strokePaint);
    
    // Main document
    final mainDocRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(size.width * 0.15, size.height * 0.05, size.width * 0.65, size.height * 0.75),
      Radius.circular(size.width * 0.04),
    );
    canvas.drawRRect(mainDocRect, strokePaint);

    // Document header bar
    final headerRect = Rect.fromLTWH(
      size.width * 0.15, 
      size.height * 0.05, 
      size.width * 0.65, 
      size.height * 0.15
    );
    final headerPath = Path()
      ..addRRect(RRect.fromRectAndCorners(
        headerRect,
        topLeft: Radius.circular(size.width * 0.04),
        topRight: Radius.circular(size.width * 0.04),
      ));
    canvas.drawPath(headerPath, paint);

    // Text lines dalam dokumen
    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Content lines
    canvas.drawLine(
      Offset(size.width * 0.25, size.height * 0.35),
      Offset(size.width * 0.7, size.height * 0.35),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.25, size.height * 0.45),
      Offset(size.width * 0.6, size.height * 0.45),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.25, size.height * 0.55),
      Offset(size.width * 0.65, size.height * 0.55),
      linePaint,
    );

    // DOCS text
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'DOC',
        style: TextStyle(
          color: color,
          fontSize: size.width * 0.18,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        (size.width - textPainter.width) / 2,
        size.height * 0.65,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}