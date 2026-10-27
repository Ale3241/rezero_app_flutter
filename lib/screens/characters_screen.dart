import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/characters_data.dart';
import '../theme/app_theme.dart';

class CharactersScreen extends StatelessWidget {
  const CharactersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personajes')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: characters.length,
        itemBuilder: (context, i) {
          final c = characters[i];
          return Card(
            color: AppColors.surface,
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () => context.push('/characters/${c.id}'),
              child: Row(
                children: [
                  Hero(
                    tag: 'char-${c.id}',
                    child: Image.asset(
                      c.image,
                      width: 100,
                      height: 130,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox(
                        width: 100,
                        height: 130,
                        child: Icon(Icons.person, color: AppColors.purple),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.name,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            c.title,
                            style: const TextStyle(color: AppColors.blood),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Icon(Icons.chevron_right, color: AppColors.blood),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
