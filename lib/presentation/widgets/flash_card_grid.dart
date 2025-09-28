import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/flash_card.dart';
import '../bloc/flash_card_bloc.dart';
import '../bloc/flash_card_event.dart';
import '../bloc/flash_card_state.dart';
import 'flash_card_widget.dart';

class FlashCardGrid extends StatelessWidget {
  const FlashCardGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlashCardBloc, FlashCardState>(
      builder: (context, state) {
        if (state is FlashCardLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is FlashCardError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  'Có lỗi xảy ra',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<FlashCardBloc>().add(LoadFlashCards());
                  },
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }

        if (state is FlashCardLoaded) {
          if (state.flashCards.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.style,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Chưa có flash card nào',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Nhấn nút + để tạo flash card đầu tiên',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade500,
                        ),
                  ),
                ],
              ),
            );
          }

          return Container(
            color: Colors.grey.shade50,
            child: GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 4 cards per row for macOS
                childAspectRatio: 0.8, // Slightly taller cards
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: state.flashCards.length,
              itemBuilder: (context, index) {
                final flashCard = state.flashCards[index];
                return FlashCardWidget(
                  flashCard: flashCard,
                  onDelete: () => _showDeleteDialog(context, flashCard),
                );
              },
            ),
          );
        }

        return const Center(
          child: Text('Không có dữ liệu'),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, FlashCard flashCard) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Xóa Flash Card'),
          content: const Text('Bạn có chắc chắn muốn xóa flash card này?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                // Sử dụng context gốc thay vì dialogContext
                context
                    .read<FlashCardBloc>()
                    .add(DeleteFlashCard(flashCard.id));
                Navigator.of(dialogContext).pop();
              },
              child: const Text(
                'Xóa',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
