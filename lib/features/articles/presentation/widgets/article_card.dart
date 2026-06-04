import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';
import '../../domain/entities/article.dart';
import '../bloc/save_article/save_article_cubit.dart';
import '../bloc/save_article/save_article_state.dart';

class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SaveArticleCubit>(),
      child: _ArticleCardContent(article: article),
    );
  }
}

class _ArticleCardContent extends StatelessWidget {
  final Article article;

  const _ArticleCardContent({required this.article});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              article.author,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              article.preview,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: BlocBuilder<SaveArticleCubit, SaveArticleState>(
                builder: (context, state) => _SaveButton(
                  state: state,
                  onTap: () =>
                      context.read<SaveArticleCubit>().saveArticle(article.id),
                  onUnsave: () => context
                      .read<SaveArticleCubit>()
                      .unsaveArticle(article.id),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  final SaveArticleState state;
  final VoidCallback onTap;
  final VoidCallback onUnsave;

  const _SaveButton({
    required this.state,
    required this.onTap,
    required this.onUnsave,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (state is SaveArticleLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (state is SaveArticleSuccess) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bookmark, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 4),
          Text('Saved', style: TextStyle(color: theme.colorScheme.primary)),
          const SizedBox(width: 8),
          TextButton.icon(
            onPressed: onUnsave,
            icon: const Icon(Icons.bookmark_remove_outlined, size: 18),
            label: const Text('Unsave'),
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      );
    }

    if (state is SaveArticleFailure) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            (state as SaveArticleFailure).message,
            style: TextStyle(color: theme.colorScheme.error, fontSize: 12),
          ),
          const SizedBox(height: 4),
          TextButton.icon(
            onPressed: onTap,
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Retry'),
            style: TextButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      );
    }

    // SaveArticleInitial
    return TextButton.icon(
      onPressed: onTap,
      icon: const Icon(Icons.bookmark_outline, size: 18),
      label: const Text('Save'),
    );
  }
}
