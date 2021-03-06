import 'package:qr/qr.dart';
import 'package:flutter/widgets.dart';

class QrPainter extends CustomPainter {
  QrPainter(
    String data,
    this.color,
    this.version,
    this.errorCorrectionLevel,
  ) : this._qr = new QrCode(version, errorCorrectionLevel) {
    _p.color = this.color;
    // configure and make the QR code data
    _qr.addData(data);
    _qr.make();
  }

  final QrCode _qr; // our qr code data
  final _p = new Paint()..style = PaintingStyle.fill;

  // properties
  final int version; // the qr code version
  final int errorCorrectionLevel; // the qr code error correction level
  final Color color; // the color of the dark squares

  @override
  void paint(Canvas canvas, Size size) {
    final squareSize = size.shortestSide / _qr.moduleCount;
    for (int x = 0; x < _qr.moduleCount; x++) {
      for (int y = 0; y < _qr.moduleCount; y++) {
        if (_qr.isDark(y, x)) {
          final squareRect = new Rect.fromLTWH(
              x * squareSize, y * squareSize, squareSize, squareSize);
          canvas.drawRect(squareRect, _p);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate is QrPainter) {
      return this.color != oldDelegate.color ||
          this.errorCorrectionLevel != oldDelegate.errorCorrectionLevel ||
          this.version != oldDelegate.version;
    }
    return false;
  }
}

class QrImage extends StatelessWidget {
  QrImage({
    @required String data,
    this.size,
    this.padding = const EdgeInsets.all(10.0),
    this.backgroundColor,
    Color foregroundColor = const Color(0xFF000000),
    int version = 4,
    int errorCorrectionLevel = QrErrorCorrectLevel.L,
  }) : _painter =
            new QrPainter(data, foregroundColor, version, errorCorrectionLevel);

  final QrPainter _painter;
  final Color backgroundColor;
  final EdgeInsets padding;
  final double size;

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: size,
      height: size,
      color: backgroundColor,
      child: new Padding(
        padding: this.padding,
        child: new CustomPaint(
          painter: _painter,
        ),
      ),
    );
  }
}
