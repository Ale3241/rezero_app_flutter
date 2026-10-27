import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/characters_screen.dart';
import 'screens/character_detail_screen.dart';
import 'screens/moments_screen.dart';
import 'screens/moment_detail_screen.dart';
import 'screens/about_screen.dart';
import 'screens/game_screen.dart';
import 'screens/hire_screen.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/characters',
      builder: (context, state) => const CharactersScreen(),
      routes: [
        GoRoute(
          path: ':id',
          builder: (context, state) =>
              CharacterDetailScreen(id: state.pathParameters['id']!),
        ),
      ],
    ),
    GoRoute(
      path: '/moments',
      builder: (context, state) => const MomentsScreen(),
      routes: [
        GoRoute(
          path: ':id',
          builder: (context, state) =>
              MomentDetailScreen(id: state.pathParameters['id']!),
        ),
      ],
    ),
    GoRoute(path: '/about', builder: (context, state) => const AboutScreen()),
    GoRoute(path: '/game', builder: (context, state) => const GameScreen()),
    GoRoute(path: '/hire', builder: (context, state) => const HireScreen()),
  ],
);
