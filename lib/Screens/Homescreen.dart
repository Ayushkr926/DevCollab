// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/home_provider.dart';
import '../models/showcase_post.dart';
import '../utils/app_theme.dart';
import '../widgets/home/common_widgets.dart';
import '../widgets/home/home_widgets.dart';
import '../widgets/home/showcase_grid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  // ── Bottom nav ─────────────────────────────────────────────────────────────
  int _navIndex = 0;

  // ── Entry animation ───────────────────────────────────────────────────────
  late final AnimationController _entryCtrl;
  late final Animation<double> _entryFade;
  late final Animation<double> _entrySlide;

  // ── Scroll for infinite load ───────────────────────────────────────────────
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _entryFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut),
    );
    _entrySlide = Tween<double>(begin: 20.0, end: 0.0).animate(
      CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut),
    );

    _scrollCtrl.addListener(_onScroll);

    // Load data after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().loadAll().then((_) {
        if (mounted) _entryCtrl.forward();
      });
    });
  }

  void _onScroll() {
    // Trigger load-more when 80% scrolled
    if (_scrollCtrl.position.pixels >=
        _scrollCtrl.position.maxScrollExtent * 0.8) {
      context.read<HomeProvider>().loadMorePosts();
    }
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  // ── Navigation ─────────────────────────────────────────────────────────────
  void _onNavTap(int index) {
    HapticFeedback.selectionClick();
    setState(() => _navIndex = index);

    switch (index) {
      case 0: break;
      case 1: Navigator.of(context).pushNamed('/explore'); break;
      case 2: _showPostSheet(); break;
      case 3: Navigator.of(context).pushNamed('/chat'); break;
      case 4: Navigator.of(context).pushNamed('/profile'); break;
    }
  }

  void _showPostSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const PostBottomSheet(),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      backgroundColor: DC.bg1,
      body: SafeArea(
        bottom: false,
        child: Consumer<HomeProvider>(
          builder: (context, provider, _) {
            // ── Loading state ───────────────────────────────────────────────
            if (provider.status == HomeStatus.loading) {
              return const _HomeSkeleton();
            }

            // ── Error state ─────────────────────────────────────────────────
            // if (provider.status == HomeStatus.error) {
            //   return HomeErrorView(
            //     message: provider.errorMessage ?? 'Unknown error',
            //     onRetry: provider.loadAll,
            //   );
            // }

            // ── Loaded ──────────────────────────────────────────────────────
            return FadeTransition(
              opacity: _entryFade,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0, _entrySlide.value / 400),
                  end: Offset.zero,
                ).animate(_entryCtrl),
                child: RefreshIndicator(
                  color: DC.p,
                  onRefresh: provider.refresh,
                  child: CustomScrollView(
                    controller: _scrollCtrl,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      // ── Header ────────────────────────────────────────────
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            if (provider.user != null)
                              HomeHeader(
                                firstName: provider.user!.firstName,
                                initials: provider.user!.initials,
                                colorIndex: provider.user!.colorIndex,
                                unreadNotifications:
                                provider.user!.unreadNotifications,
                                onNotificationsTap: () =>
                                    Navigator.of(context).pushNamed('/notifications'),
                                onAvatarTap: () =>
                                    Navigator.of(context).pushNamed('/profile'),
                              ),

                            // White card surface for search + filters
                            Container(
                              color: DC.bg0,
                              child: Column(
                                children: [
                                  const SizedBox(height: 4),
                                  HomeSearchBar(
                                    query: provider.searchQuery,
                                    onChanged: provider.onSearchChanged,
                                    onClear: provider.clearSearch,
                                  ),
                                  FilterChipsRow(
                                    active: provider.activeFilter,
                                    onSelect: provider.setFilter,
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ── Developer stories ─────────────────────────────────
                      if (!provider.isSearching && provider.stories.isNotEmpty)
                        SliverToBoxAdapter(
                          child: Container(
                            color: DC.bg0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 12),
                                Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: Text('Active developers',
                                      style: DCText.label.copyWith(
                                          color: DC.textSecondary)),
                                ),
                                const SizedBox(height: 8),
                                DeveloperStoriesRow(
                                  stories: provider.stories,
                                  onAddStory: () =>
                                      Navigator.of(context).pushNamed('/add-work'),
                                ),
                                const SizedBox(height: 12),
                                const Divider(height: 0.5, thickness: 0.5, color: DC.borderLight),
                              ],
                            ),
                          ),
                        ),

                      // ── Hackathons section ────────────────────────────────
                      if (!provider.isSearching && provider.hackathons.isNotEmpty)
                        SliverToBoxAdapter(
                          child: Container(
                            color: DC.bg1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SectionHeader(
                                  title: 'Hackathons',
                                  trailing: AiBadge(
                                    label:
                                    '${provider.hackathons.where((h) => h.isMatchingSkills!).length} match your skills',
                                  ),
                                  onSeeAll: () =>
                                      Navigator.of(context).pushNamed('/hackathons'),
                                ),
                                ...provider.hackathons.map((hack) => HackathonCard(
                                  hack: hack,
                                  onFormTeam: () => Navigator.of(context)
                                      .pushNamed('/hackathon-team/${hack?.id}'),
                                  onDetails: () => Navigator.of(context)
                                      .pushNamed('/hackathon/${hack.id}'),
                                )),
                              ],
                            ),
                          ),
                        ),

                      // ── Showcase header ───────────────────────────────────
                      SliverToBoxAdapter(
                        child: Container(
                          color: DC.bg1,
                          child: SectionHeader(
                            title: provider.isSearching
                                ? 'Search results'
                                : 'Developer showcase',
                            showDot: !provider.isSearching,
                            onSeeAll: provider.isSearching
                                ? null
                                : () =>
                                Navigator.of(context).pushNamed('/showcase'),
                          ),
                        ),
                      ),

                      // ── Showcase grid — loading ───────────────────────────
                      if (provider.postsStatus == PostsStatus.loading)
                        const SliverToBoxAdapter(child: ShowcaseGridSkeleton()),

                      // ── Showcase grid — loaded ────────────────────────────
                      if (provider.postsStatus != PostsStatus.loading)
                        SliverToBoxAdapter(
                          child: ShowcaseGrid(
                            posts: provider.posts,
                            onLike: provider.toggleLike,
                            onTap: (post) => _onPostTap(post),
                          ),
                        ),

                      // ── Load more indicator ───────────────────────────────
                      SliverToBoxAdapter(
                        child: _LoadMoreIndicator(
                          status: provider.postsStatus,
                        ),
                      ),

                      // ── Bottom padding for nav bar ────────────────────────
                      const SliverToBoxAdapter(child: SizedBox(height: 88)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),

      // ── Bottom navigation ─────────────────────────────────────────────────
      bottomNavigationBar: BottomNav(
        currentIndex: _navIndex,
        onTap: _onNavTap,
      ),
    );
  }

  void _onPostTap(ShowcasePost post) {
    Navigator.of(context).pushNamed('/post/${post.id}', arguments: post);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom navigation bar
// ─────────────────────────────────────────────────────────────────────────────
class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: DC.borderLight, width: 0.5)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: [
              _NavItem(icon: Icons.home_rounded,                 label: 'Home',     index: 0, current: currentIndex, onTap: onTap),
              _NavItem(icon: Icons.search_rounded,               label: 'Explore',  index: 1, current: currentIndex, onTap: onTap),
              _NavPlusButton(onTap: () => onTap(2)),
              _NavItem(icon: Icons.chat_bubble_outline_rounded,  label: 'Chat',     index: 3, current: currentIndex, onTap: onTap, badgeCount: 3),
              _NavItem(icon: Icons.person_outline_rounded,       label: 'Profile',  index: 4, current: currentIndex, onTap: onTap),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final int index;
  final int current;
  final ValueChanged<int> onTap;
  final int badgeCount;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
    this.badgeCount = 0,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 180));
    _scale = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  void didUpdateWidget(_NavItem old) {
    super.didUpdateWidget(old);
    if (widget.current == widget.index && old.current != widget.index) {
      _ctrl.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isActive = widget.current == widget.index;

    return Expanded(
      child: GestureDetector(
        onTap: () => widget.onTap(widget.index),
        child: Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _scale,
                builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      widget.icon,
                      size: 22,
                      color: isActive ? DC.p : DC.gr,
                    ),
                    if (widget.badgeCount > 0)
                      Positioned(
                        top: -4,
                        right: -6,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: DC.r,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          child: Center(
                            child: Text(
                              '${widget.badgeCount}',
                              style: const TextStyle(
                                fontSize: 7.5,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 3),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: isActive ? FontWeight.w800 : FontWeight.w500,
                  color: isActive ? DC.p : DC.gr,
                ),
                child: Text(widget.label),
              ),
              if (isActive)
                Container(
                  margin: const EdgeInsets.only(top: 3),
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: DC.p,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavPlusButton extends StatefulWidget {
  final VoidCallback onTap;
  const _NavPlusButton({required this.onTap});

  @override
  State<_NavPlusButton> createState() => _NavPlusButtonState();
}

class _NavPlusButtonState extends State<_NavPlusButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _scale = Tween<double>(begin: 1.0, end: 0.9)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTapDown: (_) => _ctrl.forward(),
        onTapUp: (_) { _ctrl.reverse(); widget.onTap(); },
        onTapCancel: () => _ctrl.reverse(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _scale,
              builder: (_, child) => Transform.scale(scale: _scale.value, child: child),
              child: Container(
                width: 42,
                height: 42,
                margin: const EdgeInsets.only(bottom: 2),
                decoration: BoxDecoration(
                  color: DC.p,
                  shape: BoxShape.circle,
                  border: Border.all(color: DC.p3, width: 3),
                ),
                child: const Icon(Icons.add_rounded, color: Colors.white, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Load more indicator
// ─────────────────────────────────────────────────────────────────────────────
class _LoadMoreIndicator extends StatelessWidget {
  final PostsStatus status;
  const _LoadMoreIndicator({required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == PostsStatus.loadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(DC.p),
            ),
          ),
        ),
      );
    }
    if (status == PostsStatus.noMore) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            '— You\'ve seen everything —',
            style: DCText.micro.copyWith(color: DC.gr),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Full-screen skeleton loading state
// ─────────────────────────────────────────────────────────────────────────────
class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header skeleton
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const DcSkeleton(width: 90, height: 12, radius: 6),
                      const SizedBox(height: 6),
                      const DcSkeleton(width: 140, height: 18, radius: 8),
                    ],
                  ),
                ),
                const DcSkeleton.circle(size: 38),
                const SizedBox(width: 10),
                const DcSkeleton.circle(size: 38),
              ],
            ),
          ),

          // Search skeleton
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: DcSkeleton(width: double.infinity, height: 44, radius: 14),
          ),

          // Filter chips skeleton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: List.generate(5, (i) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: DcSkeleton(width: 60 + (i * 8).toDouble(), height: 32, radius: 20),
              )),
            ),
          ),

          // Stories skeleton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: List.generate(5, (i) => const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Column(
                  children: [
                    DcSkeleton.circle(size: 50),
                    SizedBox(height: 5),
                    DcSkeleton(width: 40, height: 10, radius: 5),
                  ],
                ),
              )),
            ),
          ),

          const SizedBox(height: 16),

          // Hackathon card skeleton
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: DcSkeleton(width: double.infinity, height: 160, radius: 16),
          ),

          const SizedBox(height: 20),

          // Grid skeleton
          const ShowcaseGridSkeleton(),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Post bottom sheet — quick actions
// ─────────────────────────────────────────────────────────────────────────────
class PostBottomSheet extends StatelessWidget {
  const PostBottomSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: DC.border,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text('What do you want to post?', style: DCText.h3),
          ),
          _SheetItem(
            icon: Icons.grid_view_rounded,
            iconColor: DC.p,
            iconBg: DC.p3,
            title: 'Showcase work',
            subtitle: 'Share a project, UI, or code snippet',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/add-work');
            },
          ),
          _SheetItem(
            icon: Icons.work_outline_rounded,
            iconColor: DC.co,
            iconBg: DC.co2,
            title: 'Post a project',
            subtitle: 'Find teammates for your next build',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/create-project');
            },
          ),
          _SheetItem(
            icon: Icons.bolt_rounded,
            iconColor: DC.a,
            iconBg: DC.a2,
            title: 'Share a hackathon',
            subtitle: 'Let the community know about it',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/add-hackathon');
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SheetItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SheetItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: DCText.h3.copyWith(fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: DCText.caption),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: DC.gr, size: 20),
          ],
        ),
      ),
    );
  }
}