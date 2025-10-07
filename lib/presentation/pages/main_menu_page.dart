import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/di/injection.dart' as di;
import '../bloc/flash_card_bloc.dart';
import '../bloc/flash_card_event.dart';
import '../bloc/random_text_bloc.dart';
import 'flash_card_page.dart';
import 'random_text_page.dart';

class MainMenuPage extends StatelessWidget {
  const MainMenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ứng Dụng Học Tập',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.indigo.shade600,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.grey.shade50,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            const Text(
              'Chọn chức năng bạn muốn sử dụng:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            _buildMenuCard(
              context: context,
              title: 'Flash Cards',
              subtitle: 'Học từ vựng với thẻ ghi nhớ',
              icon: Icons.style,
              color: Colors.blue,
              onTap: () => _navigateToFlashCards(context),
            ),
            const SizedBox(height: 20),
            _buildMenuCard(
              context: context,
              title: 'Random Text',
              subtitle: 'Chọn ngẫu nhiên từ danh sách',
              icon: Icons.casino,
              color: Colors.green,
              onTap: () => _navigateToRandomText(context),
            ),
            const SizedBox(height: 20),
            _buildMenuCard(
              context: context,
              title: 'Thêm chức năng',
              subtitle: 'Sẽ được phát triển trong tương lai',
              icon: Icons.add_circle_outline,
              color: Colors.grey,
              onTap: () => _showComingSoon(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade400,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToFlashCards(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => di.sl<FlashCardBloc>()..add(LoadFlashCards()),
          child: const FlashCardPage(),
        ),
      ),
    );
  }

  void _navigateToRandomText(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => di.sl<RandomTextBloc>(),
          child: const RandomTextPage(),
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Tính năng này sẽ được phát triển trong tương lai!'),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
