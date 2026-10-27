import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import '../data/moments_data.dart';
import '../models/moment.dart';
import '../theme/app_theme.dart';

class MomentDetailScreen extends StatefulWidget {
  final String id;
  const MomentDetailScreen({super.key, required this.id});

  @override
  State<MomentDetailScreen> createState() => _MomentDetailScreenState();
}

class _MomentDetailScreenState extends State<MomentDetailScreen> {
  late final Moment _moment;
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _moment = moments.firstWhere((m) => m.id == widget.id);
    _controller = YoutubePlayerController.fromVideoId(
      videoId: _moment.videoId,
      autoPlay: false,
      params: const YoutubePlayerParams(showFullscreenButton: true),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
      controller: _controller,
      aspectRatio: 16 / 9,
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(title: const Text('Momento')),
          body: ListView(
            children: [
              player,
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _moment.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _moment.subtitle,
                      style: const TextStyle(
                        color: AppColors.blood,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _moment.description,
                      style: Theme.of(context).textTheme.bodyLarge
                          ?.copyWith(height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
