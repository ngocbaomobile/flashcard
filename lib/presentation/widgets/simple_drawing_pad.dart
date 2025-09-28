import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class SimpleDrawingPad extends StatefulWidget {
  final String title;
  final Function(String imagePath) onSave;

  const SimpleDrawingPad({
    Key? key,
    required this.title,
    required this.onSave,
  }) : super(key: key);

  @override
  State<SimpleDrawingPad> createState() => _SimpleDrawingPadState();
}

class _SimpleDrawingPadState extends State<SimpleDrawingPad> {
  final GlobalKey _repaintBoundaryKey = GlobalKey();
  List<List<Offset>> _strokes = []; // Mỗi stroke là một danh sách điểm
  List<Offset> _currentStroke = []; // Stroke hiện tại đang vẽ
  Color _currentColor = Colors.black;
  double _currentStrokeWidth = 8.0;
  int _repaintCounter = 0; // Để force repaint

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

  void _clearPad() {
    setState(() {
      _strokes.clear();
      _currentStroke.clear();
      _repaintCounter++;
    });
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _currentStroke = [details.localPosition]; // Bắt đầu stroke mới
      _repaintCounter++;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _currentStroke.add(details.localPosition);
      _repaintCounter++;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      if (_currentStroke.isNotEmpty) {
        _strokes.add(List.from(_currentStroke)); // Lưu stroke hoàn chỉnh
        _currentStroke.clear();
      }
      _repaintCounter++;
    });
  }

  Future<void> _saveDrawing() async {
    try {
      if (_strokes.isEmpty && _currentStroke.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng vẽ gì đó trước khi lưu')),
        );
        return;
      }

      final RenderRepaintBoundary boundary = _repaintBoundaryKey.currentContext!
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lưu thành công!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi lưu: $e')),
        );
      }
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
          // Controls
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade100,
            child: Column(
              children: [
                // Color picker
                Row(
                  children: [
                    const Text('Màu: '),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _currentColor,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        _currentColor == Colors.black
                            ? 'Đen'
                            : _currentColor == Colors.red
                                ? 'Đỏ'
                                : _currentColor == Colors.blue
                                    ? 'Xanh dương'
                                    : _currentColor == Colors.green
                                        ? 'Xanh lá'
                                        : _currentColor == Colors.orange
                                            ? 'Cam'
                                            : _currentColor == Colors.purple
                                                ? 'Tím'
                                                : _currentColor == Colors.pink
                                                    ? 'Hồng'
                                                    : 'Nâu',
                        style: TextStyle(
                          color: _currentColor == Colors.black
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
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
                // Stroke width slider
                Row(
                  children: [
                    const Text('Độ dày: '),
                    Expanded(
                      child: Slider(
                        value: _currentStrokeWidth,
                        min: 1.0,
                        max: 10.0,
                        divisions: 9,
                        activeColor: Colors.blue,
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
                color: Colors.grey.shade50, // Nền dịu mắt
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: RepaintBoundary(
                  key: _repaintBoundaryKey,
                  child: GestureDetector(
                    onPanStart: _onPanStart,
                    onPanUpdate: _onPanUpdate,
                    onPanEnd: _onPanEnd,
                    child: CustomPaint(
                      painter: SimpleDrawingPainter(
                        strokes: _strokes,
                        currentStroke: _currentStroke,
                        color: _currentColor,
                        strokeWidth: _currentStrokeWidth,
                        repaintCounter: _repaintCounter,
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
            color: Colors.blue.shade50,
            child: Column(
              children: [
                Text(
                  'Vẽ nội dung cho flash card. Nhấn "Lưu" khi hoàn thành.',
                  style: TextStyle(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: Colors.blue.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  '💡 Mẹo: Trên macOS, bạn có thể sử dụng chuột để vẽ chính xác hơn!',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SimpleDrawingPainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<Offset> currentStroke;
  final Color color;
  final double strokeWidth;
  final int repaintCounter;

  SimpleDrawingPainter({
    required this.strokes,
    required this.currentStroke,
    required this.color,
    required this.strokeWidth,
    required this.repaintCounter,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Vẽ nền dịu mắt trước
    final backgroundPaint = Paint()..color = Colors.grey.shade50;
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..color = color
      ..strokeWidth = strokeWidth;

    // Vẽ tất cả các strokes đã hoàn thành
    for (final stroke in strokes) {
      if (stroke.isNotEmpty) {
        if (stroke.length == 1) {
          // Vẽ điểm đơn
          paint.style = PaintingStyle.fill;
          canvas.drawCircle(stroke[0], strokeWidth / 2, paint);
          paint.style = PaintingStyle.stroke;
        } else {
          // Vẽ đường nối các điểm trong stroke
          for (int i = 0; i < stroke.length - 1; i++) {
            canvas.drawLine(stroke[i], stroke[i + 1], paint);
          }
        }
      }
    }

    // Vẽ stroke hiện tại đang vẽ
    if (currentStroke.isNotEmpty) {
      if (currentStroke.length == 1) {
        // Vẽ điểm đơn
        paint.style = PaintingStyle.fill;
        canvas.drawCircle(currentStroke[0], strokeWidth / 2, paint);
        paint.style = PaintingStyle.stroke;
      } else {
        // Vẽ đường nối các điểm trong stroke hiện tại
        for (int i = 0; i < currentStroke.length - 1; i++) {
          canvas.drawLine(currentStroke[i], currentStroke[i + 1], paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(SimpleDrawingPainter oldDelegate) {
    return strokes.length != oldDelegate.strokes.length ||
        currentStroke.length != oldDelegate.currentStroke.length ||
        color != oldDelegate.color ||
        strokeWidth != oldDelegate.strokeWidth ||
        repaintCounter != oldDelegate.repaintCounter;
  }
}
