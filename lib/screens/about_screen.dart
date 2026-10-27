import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _facts = [
    (Icons.person, 'Creador', 'Tappei Nagatsuki'),
    (Icons.brush, 'Ilustrador original', 'Shinichirou Otsuka'),
    (Icons.movie_creation, 'Estudio de animación', 'White Fox'),
    (Icons.menu_book, 'Obra original', 'Novela ligera (desde 2014)'),
    (Icons.live_tv, 'Temporadas', '4 (hasta 2026)'),
  ];

  static const _seasons = [
    ('Temporada 1', '2016 · 25 episodios'),
    ('Temporada 2', '2020-2021 · 25 episodios, en dos partes'),
    (
      'Temporada 3',
      '2024-2025 · 16 episodios · "Attack Arc" y "Counterattack Arc"',
    ),
    ('Temporada 4', '2026 · 19 episodios · "Loss Arc" y "Recapture Arc"'),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Cabecera con imagen difuminada abajo
          AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'assets/images/about/cover.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.surface,
                      child: const Icon(
                        Icons.auto_stories,
                        size: 56,
                        color: AppColors.purple,
                      ),
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0, -0.2),
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, AppColors.background],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Re:Zero - Starting Life in Another World',
            style: textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          const Text(
            'Ficha técnica',
            style: TextStyle(
              color: AppColors.blood,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          for (final (icon, label, value) in _facts)
            Card(
              color: AppColors.surface,
              child: ListTile(
                leading: Icon(icon, color: AppColors.purple),
                title: Text(
                  label,
                  style: const TextStyle(fontSize: 13, color: AppColors.blood),
                ),
                subtitle: Text(value, style: textTheme.bodyLarge),
              ),
            ),

          const SizedBox(height: 20),
          Text('Temporadas', style: textTheme.titleMedium),
          const SizedBox(height: 8),

          for (final (name, info) in _seasons)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: const Border(
                  left: BorderSide(color: AppColors.purple, width: 4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(info),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
