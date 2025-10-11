import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/random_text_entity.dart';
import '../bloc/random_text_bloc.dart';
import '../bloc/random_text_event.dart';
import '../bloc/random_text_state.dart';

class RandomTextPage extends StatefulWidget {
  const RandomTextPage({super.key});

  @override
  State<RandomTextPage> createState() => _RandomTextPageState();
}

class _RandomTextPageState extends State<RandomTextPage> {
  final TextEditingController _textController =
      TextEditingController(text: 'sa,shi,su,se,so,ta,chi,tsu,te,to');
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Request focus khi page được mở
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _startRandomSelection() {
    context.read<RandomTextBloc>().add(ParseTextEvent(_textController.text));

    // Chờ một chút để parse text xong, sau đó bắt đầu shuffle
    Future.delayed(const Duration(milliseconds: 100), () {
      final state = context.read<RandomTextBloc>().state;
      if (state is RandomTextInitial && state.entity.items.isNotEmpty) {
        context
            .read<RandomTextBloc>()
            .add(StartShuffleEvent(state.entity.items));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (KeyEvent event) {
        // Kiểm tra nếu là phím Space và là key down event
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.space) {
          final currentState = context.read<RandomTextBloc>().state;

          // Kiểm tra xem có đang shuffle không
          bool isCurrentlyShuffling = false;
          if (currentState is RandomTextShuffling) {
            isCurrentlyShuffling = currentState.entity.isShuffling;
          }

          // Chỉ start nếu không đang shuffle
          if (!isCurrentlyShuffling) {
            _startRandomSelection();
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Bộ Chọn Ngẫu Nhiên'),
              Text(
                'Nhấn Space hoặc nút BẮT ĐẦU',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
            ],
          ),
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
        ),
        body: BlocConsumer<RandomTextBloc, RandomTextState>(
          listener: (context, state) {
            if (state is RandomTextError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            RandomTextEntity entity;
            if (state is RandomTextInitial) {
              entity = state.entity;
            } else if (state is RandomTextLoading) {
              entity = state.entity;
            } else if (state is RandomTextShuffling) {
              entity = state.entity;
            } else if (state is RandomTextResult) {
              entity = state.entity;
            } else if (state is RandomTextError) {
              entity = state.entity;
            } else {
              entity = const RandomTextEntity(
                items: [],
                selectedItem: '...',
                isShuffling: false,
              );
            }

            final isShuffling = entity.isShuffling;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // 1. Input Text Field
                  TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      labelText: 'Nhập các giá trị (ngăn cách bởi dấu phẩy)',
                      hintText: 'e.g., Cat,Dog,Bird,Fish',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),

                  const Divider(height: 40),

                  // 3. Result Label (với Animation Effects)
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'Kết Quả Ngẫu Nhiên:',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 100),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                              scale: animation,
                              child: FadeTransition(
                                  opacity: animation, child: child),
                            );
                          },
                          child: Text(
                            entity.selectedItem,
                            key: ValueKey<String>(entity.selectedItem),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 100,
                              fontWeight: FontWeight.w900,
                              color:
                                  isShuffling ? Colors.orange : Colors.indigo,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 2. Start Button
                  ElevatedButton.icon(
                    onPressed: isShuffling ? null : _startRandomSelection,
                    icon: const Icon(Icons.casino),
                    label: Text(
                      isShuffling ? 'ĐANG CHẠY...' : 'BẮT ĐẦU',
                      style: const TextStyle(fontSize: 18),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
