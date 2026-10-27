import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../widgets/hero_slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const _items = [
    (Icons.people, 'Personajes', '/characters'),
    (Icons.movie, 'Momentos Destacados', '/moments'),
    (Icons.info_outline, 'Acerca de', '/about'),
    (Icons.sports_esports, 'Juega Conmigo', '/game'),
    (Icons.badge, 'Contrátame', '/hire'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RE:ZERO')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const HeroSlider(),
          const SizedBox(height: 16),
          for (final (icon, label, route) in _items)
            Card(
              color: AppColors.surface,
              child: ListTile(
                leading: Icon(icon, color: AppColors.purple),
                title: Text(label),
                trailing:
                    const Icon(Icons.chevron_right, color: AppColors.blood),
                onTap: () => context.push(route),
              ),
            ),
        ],
      ),
    );
  }
}
