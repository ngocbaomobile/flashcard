import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/flash_card.dart';
import '../bloc/flash_card_bloc.dart';
import '../bloc/flash_card_event.dart';
import '../widgets/simple_drawing_pad.dart';

class AddFlashCardPage extends StatefulWidget {
  const AddFlashCardPage({super.key});

  @override
  State<AddFlashCardPage> createState() => _AddFlashCardPageState();
}

class _AddFlashCardPageState extends State<AddFlashCardPage> {
  String? _frontImagePath;
  String? _backImagePath;
  bool _isCreating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo Flash Card'),
        backgroundColor: Colors.blue.shade100,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Container(
        color: Colors.grey.shade50,
        child: _isCreating
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Tạo Flash Card Mới',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Front side
                    _buildCardSide(
                      title: 'Mặt Trước',
                      imagePath: _frontImagePath,
                      onTap: () => _navigateToDrawingPad(
                        'Vẽ Mặt Trước',
                        (path) => setState(() => _frontImagePath = path),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Back side
                    _buildCardSide(
                      title: 'Mặt Sau',
                      imagePath: _backImagePath,
                      onTap: () => _navigateToDrawingPad(
                        'Vẽ Mặt Sau',
                        (path) => setState(() => _backImagePath = path),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Create button
                    ElevatedButton(
                      onPressed: _canCreate() ? _createFlashCard : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Tạo Flash Card',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildCardSide({
    required String title,
    required String? imagePath,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: onTap,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade50,
                ),
                child: imagePath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.file(
                          File(imagePath),
                          fit: BoxFit.cover,
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit,
                            size: 48,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Nhấn để vẽ',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            if (imagePath != null) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Đã vẽ xong',
                    style: TextStyle(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        if (title == 'Mặt Trước') {
                          _frontImagePath = null;
                        } else {
                          _backImagePath = null;
                        }
                      });
                    },
                    child: const Text('Vẽ lại'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _navigateToDrawingPad(String title, Function(String) onSave) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SimpleDrawingPad(
          title: title,
          onSave: onSave,
        ),
      ),
    );
  }

  bool _canCreate() {
    return _frontImagePath != null && _backImagePath != null;
  }

  Future<void> _createFlashCard() async {
    if (!_canCreate()) return;

    setState(() {
      _isCreating = true;
    });

    try {
      final flashCard = FlashCard(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        frontImagePath: _frontImagePath!,
        backImagePath: _backImagePath!,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      context.read<FlashCardBloc>().add(AddFlashCard(flashCard));

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tạo flash card thành công!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }
}
