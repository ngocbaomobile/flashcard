import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_signature_pad/flutter_signature_pad.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:math' as math;

class DrawingPad extends StatefulWidget {
  final String title;
  final Function(String imagePath) onSave;

  const DrawingPad({
    Key? key,
    required this.title,
    required this.onSave,
  }) : super(key: key);

  @override
  State<DrawingPad> createState() => _DrawingPadState();
}

class _DrawingPadState extends State<DrawingPad> {
  final GlobalKey<SignatureState> _signatureKey = GlobalKey<SignatureState>();
  Color _currentColor = Colors.black;
  double _currentStrokeWidth = 2.0;
  bool _isEraserMode = false;
  final List<Color> _colors = [
    Colors.black,
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.brown,
  ];

  // Lưu trữ các nét vẽ để có thể xóa
  List<Map<String, dynamic>> _strokes = [];
  List<Map<String, dynamic>> _erasedStrokes = [];

  void _clearPad() {
    _signatureKey.currentState?.clear();
    setState(() {
      _strokes.clear();
      _erasedStrokes.clear();
    });
  }

  void _toggleEraserMode() {
    setState(() {
      _isEraserMode = !_isEraserMode;
    });
  }

  void _onPanStart(DragStartDetails details) {
    if (_isEraserMode) {
      _eraseAtPoint(details.localPosition);
    } else {
      _strokes.add({
        'points': [details.localPosition],
        'color': _currentColor,
        'strokeWidth': _currentStrokeWidth,
      });
      setState(() {});
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_isEraserMode) {
      _eraseAtPoint(details.localPosition);
    } else {
      if (_strokes.isNotEmpty) {
        _strokes.last['points'].add(details.localPosition);
        setState(() {});
      }
    }
  }

  void _onPanEnd(DragEndDetails details) {
    // Không cần làm gì đặc biệt khi kết thúc
  }

  void _eraseAtPoint(Offset point) {
    bool foundErase = false;
    for (int i = 0; i < _strokes.length; i++) {
      final stroke = _strokes[i];
      final points = stroke['points'] as List<Offset>;

      for (int j = 0; j < points.length; j++) {
        final distance = (points[j] - point).distance;
        if (distance <= _currentStrokeWidth * 2) {
          // Tăng phạm vi tẩy
          // Đánh dấu nét này bị xóa
          _erasedStrokes.add({
            'strokeIndex': i,
            'pointIndex': j,
          });
          foundErase = true;
          break;
        }
      }
      if (foundErase) break;
    }
    if (foundErase) {
      setState(() {});
    }
  }

  Future<void> _saveDrawing() async {
    try {
      if (_strokes.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng vẽ gì đó trước khi lưu')),
        );
        return;
      }

      // Tạo một GlobalKey cho RepaintBoundary
      final GlobalKey repaintBoundaryKey = GlobalKey();

      // Tạo một widget tạm thời để render
      final tempWidget = Material(
        child: RepaintBoundary(
          key: repaintBoundaryKey,
          child: Container(
            width: 400,
            height: 300,
            color: Colors.white,
            child: CustomPaint(
              painter: DrawingPainter(
                strokes: _strokes,
                erasedStrokes: _erasedStrokes,
                isEraserMode: false,
                currentColor: _currentColor,
                currentStrokeWidth: _currentStrokeWidth,
              ),
            ),
          ),
        ),
      );

      // Render widget
      final RenderRepaintBoundary boundary = repaintBoundaryKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) return;

      final directory = await getApplicationDocumentsDirectory();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.png';
      final filePath = path.join(directory.path, fileName);
      final file = File(filePath);
      await file.writeAsBytes(byteData.buffer.asUint8List());

      widget.onSave(filePath);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi lưu: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue.shade100,
        actions: [
          IconButton(
            onPressed: _toggleEraserMode,
            icon: Icon(_isEraserMode ? Icons.edit : Icons.auto_fix_high),
            tooltip: _isEraserMode ? 'Chế độ vẽ' : 'Chế độ tẩy',
            color: _isEraserMode ? Colors.red : Colors.blue,
          ),
          IconButton(
            onPressed: _clearPad,
            icon: const Icon(Icons.clear),
            tooltip: 'Xóa tất cả',
          ),
          IconButton(
            onPressed: _saveDrawing,
            icon: const Icon(Icons.save),
            tooltip: 'Lưu',
          ),
        ],
      ),
      body: Column(
        children: [
          // Color and stroke width controls
          Container(
            padding: const EdgeInsets.all(16),
            color: _isEraserMode ? Colors.red.shade50 : Colors.grey.shade100,
            child: Column(
              children: [
                // Mode indicator
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _isEraserMode
                        ? Colors.red.shade100
                        : Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _isEraserMode ? Colors.red : Colors.blue,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isEraserMode ? Icons.auto_fix_high : Icons.edit,
                        color: _isEraserMode ? Colors.red : Colors.blue,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isEraserMode ? 'Chế độ tẩy' : 'Chế độ vẽ',
                        style: TextStyle(
                          color: _isEraserMode
                              ? Colors.red.shade700
                              : Colors.blue.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Color picker (only show when not in eraser mode)
                if (!_isEraserMode) ...[
                  Row(
                    children: [
                      const Text('Màu: '),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _colors.map((color) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _currentColor = color;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: _currentColor == color
                                          ? Colors.black
                                          : Colors.grey,
                                      width: _currentColor == color ? 3 : 1,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
                // Stroke width slider
                Row(
                  children: [
                    Text(_isEraserMode ? 'Kích thước tẩy: ' : 'Độ dày: '),
                    Expanded(
                      child: Slider(
                        value: _currentStrokeWidth,
                        min: 1.0,
                        max: 10.0,
                        divisions: 9,
                        activeColor: _isEraserMode ? Colors.red : Colors.blue,
                        onChanged: (value) {
                          setState(() {
                            _currentStrokeWidth = value;
                          });
                        },
                      ),
                    ),
                    Text('${_currentStrokeWidth.toInt()}px'),
                  ],
                ),
              ],
            ),
          ),
          // Drawing area
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: RepaintBoundary(
                  child: GestureDetector(
                    onPanStart: _onPanStart,
                    onPanUpdate: _onPanUpdate,
                    onPanEnd: _onPanEnd,
                    child: CustomPaint(
                      painter: DrawingPainter(
                        strokes: _strokes,
                        erasedStrokes: _erasedStrokes,
                        isEraserMode: _isEraserMode,
                        currentColor: _currentColor,
                        currentStrokeWidth: _currentStrokeWidth,
                      ),
                      size: Size.infinite,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Instructions
          Container(
            padding: const EdgeInsets.all(16),
            color: _isEraserMode ? Colors.red.shade50 : Colors.blue.shade50,
            child: Text(
              _isEraserMode
                  ? 'Chế độ tẩy: Di chuyển ngón tay để xóa các phần đã vẽ. Nhấn nút tẩy để chuyển về chế độ vẽ.'
                  : 'Vẽ nội dung cho flash card. Nhấn nút tẩy để xóa từng phần. Nhấn "Lưu" khi hoàn thành.',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color:
                    _isEraserMode ? Colors.red.shade700 : Colors.blue.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  final List<Map<String, dynamic>> strokes;
  final List<Map<String, dynamic>> erasedStrokes;
  final bool isEraserMode;
  final Color currentColor;
  final double currentStrokeWidth;

  DrawingPainter({
    required this.strokes,
    required this.erasedStrokes,
    required this.isEraserMode,
    required this.currentColor,
    required this.currentStrokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    for (int i = 0; i < strokes.length; i++) {
      final stroke = strokes[i];
      final points = stroke['points'] as List<Offset>;
      final color = stroke['color'] as Color;
      final strokeWidth = stroke['strokeWidth'] as double;

      // Kiểm tra xem nét này có bị xóa không
      bool isErased = erasedStrokes.any((erased) => erased['strokeIndex'] == i);

      if (!isErased && points.length >= 1) {
        paint.color = color;
        paint.strokeWidth = strokeWidth;

        if (points.length == 1) {
          // Vẽ điểm đơn
          paint.style = PaintingStyle.fill;
          canvas.drawCircle(points[0], strokeWidth / 2, paint);
          paint.style = PaintingStyle.stroke;
        } else {
          // Vẽ đường nét
          for (int j = 0; j < points.length - 1; j++) {
            canvas.drawLine(points[j], points[j + 1], paint);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) {
    return strokes != oldDelegate.strokes ||
        erasedStrokes != oldDelegate.erasedStrokes ||
        isEraserMode != oldDelegate.isEraserMode ||
        currentColor != oldDelegate.currentColor ||
        currentStrokeWidth != oldDelegate.currentStrokeWidth;
  }
}
