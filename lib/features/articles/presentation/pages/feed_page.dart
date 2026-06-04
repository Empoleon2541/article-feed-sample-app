import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/articles/articles_cubit.dart';
import '../bloc/articles/articles_state.dart';
import '../widgets/article_card.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  static const path = '/feed';
  static const name = 'feed';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ArticlesCubit>(),
      child: const _FeedPageView(),
    );
  }
}

class _FeedPageView extends StatefulWidget {
  const _FeedPageView();

  @override
  State<_FeedPageView> createState() => _FeedPageViewState();
}

class _FeedPageViewState extends State<_FeedPageView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ArticlesCubit>().loadArticles();
      }
    });
  }

  Future<void> _onRefresh() async {
    context.read<ArticlesCubit>().loadArticles();
    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('For You'),
        backgroundColor: theme.colorScheme.inversePrimary,
      ),
      body: BlocBuilder<ArticlesCubit, ArticlesState>(
        builder: (context, state) {
          if (state is ArticlesLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading articles...'),
                ],
              ),
            );
          }

          if (state is ArticlesError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: theme.colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load articles',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: theme.textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => context
                          .read<ArticlesCubit>()
                          .loadArticles(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is ArticlesLoaded) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.article_outlined,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${state.articles.length} Articles',
                            style: theme.textTheme.titleMedium,
                          ),
                          const Spacer(),
                          Chip(
                            label: const Text('Mock API'),
                            avatar: const Icon(Icons.cloud_off, size: 14),
                            backgroundColor:
                                theme.colorScheme.secondary.withValues(alpha: 0.1),
                            labelStyle: TextStyle(
                              color: theme.colorScheme.secondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          ArticleCard(article: state.articles[index]),
                      childCount: state.articles.length,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 16)),
                ],
              ),
            );
          }

          // ArticlesInitial
          return const Center(child: Text('Pull down to refresh'));
        },
      ),
    );
  }
}
