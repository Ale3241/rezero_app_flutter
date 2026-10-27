import 'dart:async';

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class HeroSlider extends StatefulWidget {
  const HeroSlider({super.key});

  @override
  State<HeroSlider> createState() => _HeroSliderState();
}

class _HeroSliderState extends State<HeroSlider> {
  final _controller = PageController();
  Timer? _timer;
  int _current = 0;

  static const _slides = [
    ('assets/images/slider/slide1.jpg', 'Retorno por Muerte'),
    ('assets/images/slider/slide2.jpg', 'Un mundo nuevo'),
    ('assets/images/slider/slide1_2.jpg', 'Nunca te rindas'),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      final next = (_current + 1) % _slides.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: _slides.length,
              onPageChanged: (i) => setState(() => _current = i),
              itemBuilder: (context, i) {
                final (path, caption) = _slides[i];
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      path,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.surface,
                        child: const Icon(
                          Icons.image_not_supported,
                          color: AppColors.purple,
                          size: 48,
                        ),
                      ),
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Color(0xCC0A0A0F)],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      bottom: 32,
                      child: Text(
                        caption,
                        style: Theme.of(context).appBarTheme.titleTextStyle,
                      ),
                    ),
                  ],
                );
              },
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < _slides.length; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: i == _current ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: i == _current
                            ? AppColors.blood
                            : AppColors.text.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
