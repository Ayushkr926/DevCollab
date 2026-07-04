import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../state/app_state.dart';
import '../memoji_widget/empty_state.dart';
import '../memoji_widget/filter_sheet.dart';
import '../memoji_widget/memoji_card.dart';
import '../memoji_widget/mood_filter_chips.dart';
import '../memoji_widget/mood_section.dart';
import '../memoji_widget/premium_search_bar.dart';

/// The primary "Choose Your Avatar" screen: a fixed header (title,
/// search, mood chips) above a scroll area that swaps — via
/// AnimatedSwitcher — between sectioned mood rows (default) and a
/// fully virtualized results grid (when searching or filters are
/// active). Each mode owns its own CustomScrollView/SliverGrid so
/// lazy building is preserved even across 3,000+ items.
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<MemojiState>();
      if (state.status == LoadStatus.initial) state.loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MemojiState>();

    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.backgroundTintTop, AppColors.background],
          stops: [0.0, 0.35],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: state.status == LoadStatus.loading ||
                state.status == LoadStatus.initial
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.brandPrimary))
            : state.status == LoadStatus.error
                ? const EmptyState(
                    emoji: '⚠️',
                    title: 'Something went wrong',
                    message: 'We couldn\'t load your Memoji library.',
                  )
                : Column(
                    children: [
                      const _Header(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: PremiumSearchBar(
                          filtersActive: state.selectedGender != null ||
                              state.selectedSkinTone != null,
                          onChanged: (v) =>
                              context.read<MemojiState>().setSearchQuery(v),
                          onFilterTap: () => FilterSheet.show(context),
                        ),
                      ),
                      const SizedBox(height: 18),
                      MoodFilterChips(
                        selected: state.selectedMood,
                        onSelected: (m) =>
                            context.read<MemojiState>().setMoodFilter(m),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 280),
                          child: state.hasActiveFilters
                              ? const _FilteredGrid(key: ValueKey('grid'))
                              : const _SectionedContent(key: ValueKey('sections')),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShaderMask(
            shaderCallback: (bounds) =>
                const LinearGradient(colors: AppColors.brandGradient)
                    .createShader(bounds),
            child: Text('Choose Your Avatar',
                style: AppTextStyles.largeTitle.copyWith(color: Colors.white)),
          ),
          const SizedBox(height: 6),
          Text(
            'Express yourself with thousands of unique Memojis.',
            style: AppTextStyles.subtitle,
          ),
        ],
      ),
    );
  }
}

/// Default view: a lazily-built vertical list of mood sections, each of
/// which contains its own lazily-built horizontal ListView.builder.
class _SectionedContent extends StatelessWidget {
  const _SectionedContent({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = context.watch<MemojiState>().moodSections;
    if (sections.isEmpty) {
      return const EmptyState(title: 'No Memojis yet', message: 'Check back soon.');
    }
    final entries = sections.entries.toList();
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 120, top: 4),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: MoodSection(mood: entry.key, memojis: entry.value),
        );
      },
    );
  }
}

/// Search/filter results: a fully virtualized SliverGrid so performance
/// stays smooth even when matching hundreds or thousands of Memojis.
class _FilteredGrid extends StatelessWidget {
  const _FilteredGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final results = context.watch<MemojiState>().filtered;
    if (results.isEmpty) {
      return const EmptyState(
        title: 'No matches found',
        message: 'Try a different name, mood, or filter combination.',
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
      itemCount: results.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, index) =>
          MemojiCard(memoji: results[index], width: double.infinity),
    );
  }
}
