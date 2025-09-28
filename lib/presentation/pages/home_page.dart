import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/injection.dart' as di;
import '../bloc/flash_card_bloc.dart';
import '../bloc/flash_card_event.dart';
import '../widgets/flash_card_grid.dart';
import 'add_flash_card_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flash Cards',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade600,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey.shade50,
        child: const FlashCardGrid(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _navigateToAddFlashCard(context);
          context.read<FlashCardBloc>().add(LoadFlashCards());
        },
        backgroundColor: Colors.blue.shade600,
        shape: CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 24),
      ),
    );
  }

  Future<void> _navigateToAddFlashCard(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => di.sl<FlashCardBloc>()..add(LoadFlashCards()),
          child: const AddFlashCardPage(),
        ),
      ),
    );
  }
}
