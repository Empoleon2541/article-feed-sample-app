import 'package:flutter/material.dart';
import 'core/utils/app_constants.dart';
import 'core/utils/app_theme.dart';
import 'features/articles/presentation/pages/feed_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.light,
      home: const FeedPage(),
    );
  }
}
