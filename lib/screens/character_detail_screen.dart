import 'package:flutter/material.dart';

import '../data/characters_data.dart';
import '../theme/app_theme.dart';

class CharacterDetailScreen extends StatelessWidget {
  final String id;
  const CharacterDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final c = characters.firstWhere((ch) => ch.id == id);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 380,
            pinned: true,
            backgroundColor: AppColors.background,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
              title: Text(c.name),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'char-${c.id}',
                    child: Image.asset(
                      c.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.surface,
                        child: const Icon(
                          Icons.person,
                          size: 64,
                          color: AppColors.purple,
                        ),
                      ),
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.center,
                        colors: [Color(0xAA000000), Colors.transparent],
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
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        radius: 1.1,
                        colors: [Colors.transparent, Color(0x66000000)],
                        stops: [0.65, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.title,
                    style: const TextStyle(
                      color: AppColors.blood,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: [
                      for (final t in c.traits)
                        Chip(
                          label: Text(t),
                          backgroundColor: AppColors.surface,
                          side: const BorderSide(color: AppColors.purple),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    c.bio,
                    style: Theme.of(context).textTheme.bodyLarge
                        ?.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
