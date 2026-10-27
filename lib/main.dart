import 'package:flutter/material.dart';

import 'router.dart';
import 'theme/app_theme.dart';

void main() => runApp(const ReZeroApp());

class ReZeroApp extends StatelessWidget {
  const ReZeroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Re:Zero',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      routerConfig: appRouter,
    );
  }
}
