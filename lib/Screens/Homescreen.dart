// lib/screens/home_screen.dart

import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/Hackathinmodel.dart';
import '../providers/home_provider.dart';
import '../models/showcase_post.dart';
import '../utils/app_theme.dart';
import '../widgets/hackathoncardstack.dart';
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


  //hackathon list
  final List<Hackathon> sampleHackathons = [
    Hackathon(
      id: "1",
      title: "BuildSpace X",
      tagline: "Code the future of Web3",
      description:
      "Join developers worldwide to build the next generation of decentralized applications using blockchain technology.",
      organizer: "BuildSpace",
      organizerLogo: "https://picsum.photos/100?1",
      organizerWebsite: "https://buildspace.so",
      bannerImage: "https://picsum.photos/id/1015/800/400",
      galleryImages: [],
      promoVideo: "",
      themes: ["Web3", "DeFi", "NFT", "DAOs"],
      technologies: ["Solidity", "Flutter", "Node.js", "Ethereum"],
      isOnline: false,
      venue: "BuildSpace HQ",
      city: "San Francisco",
      state: "California",
      country: "USA",
      googleMapLink: "",
      registrationStart: DateTime.now().subtract(const Duration(days: 5)),
      registrationEnd: DateTime.now().add(const Duration(days: 2)),
      hackathonStart: DateTime.now().add(const Duration(days: 3, hours: 8)),
      hackathonEnd: DateTime.now().add(const Duration(days: 5, hours: 8)),
      resultDate: DateTime.now().add(const Duration(days: 7)),
      registrationOpen: true,
      requiresApproval: false,
      registrationFee: 0,
      maxParticipants: 500,
      minTeamSize: 1,
      maxTeamSize: 4,
      totalPrizePool: "\$50,000",
      accentColor: const Color(0xFF6C63FF),
      prizes: [
        Prize(position: "1st", amount: "\$25,000", description: "Grand Prize"),
        Prize(position: "2nd", amount: "\$15,000", description: "Runner Up"),
        Prize(position: "3rd", amount: "\$10,000", description: "Second Runner Up"),
      ],
      judges: [],
      mentors: [],
      sponsors: [],
      faqs: [],
      schedule: [],
      resources: [],
      discordLink: "",
      whatsappLink: "",
      linkedinLink: "",
      instagramLink: "",
      email: "hello@buildspace.so",
      phone: "",
      registeredTeams: 18,
      registeredParticipants: 47,
      views: 1200,
      rating: 4.8,
      eligibility: "Open to all developers",
      rules: ["Maximum 4 members", "Original work only"],
      participationCertificate: true,
      winnerCertificate: true,
      featured: true,
      bookmarked: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(), tracks: [],
    ),

    Hackathon(
      id: "2",
      title: "HackAI 2025",
      tagline: "Build with Large Language Models",
      description:
      "An online AI hackathon focused on LLMs, AI Agents, and Computer Vision.",
      organizer: "OpenAI Community",
      organizerLogo: "https://picsum.photos/100?2",
      organizerWebsite: "https://hackai.dev",
      bannerImage: "https://picsum.photos/id/1025/800/400",
      galleryImages: [],
      promoVideo: "",
      themes: ["LLMs", "Computer Vision", "MLOps", "Agents"],
      technologies: ["Python", "PyTorch", "Flutter", "FastAPI"],
      isOnline: true,
      venue: "Online",
      city: "Global",
      state: "",
      country: "Worldwide",
      googleMapLink: "",
      registrationStart: DateTime.now().subtract(const Duration(days: 3)),
      registrationEnd: DateTime.now().add(const Duration(days: 6)),
      hackathonStart: DateTime.now().add(const Duration(days: 7, hours: 2)),
      hackathonEnd: DateTime.now().add(const Duration(days: 9, hours: 2)),
      resultDate: DateTime.now().add(const Duration(days: 11)),
      registrationOpen: true,
      requiresApproval: false,
      registrationFee: 0,
      maxParticipants: 2000,
      minTeamSize: 1,
      maxTeamSize: 5,
      totalPrizePool: "\$100,000",
      accentColor: const Color(0xFF00C896),
      prizes: [
        Prize(position: "1st", amount: "\$50,000", description: "Champion"),
        Prize(position: "2nd", amount: "\$30,000", description: "Runner Up"),
        Prize(position: "3rd", amount: "\$20,000", description: "Third Place"),
      ],
      judges: [],
      mentors: [],
      sponsors: [],
      faqs: [],
      schedule: [],
      resources: [],
      discordLink: "",
      whatsappLink: "",
      linkedinLink: "",
      instagramLink: "",
      email: "contact@hackai.dev",
      phone: "",
      registeredTeams: 420,
      registeredParticipants: 1188,
      views: 8900,
      rating: 4.9,
      eligibility: "Open Worldwide",
      rules: ["AI-generated code allowed", "Original project only"],
      participationCertificate: true,
      winnerCertificate: true,
      featured: true,
      bookmarked: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(), tracks: [],
    ),

    Hackathon(
      id: "3",
      title: "ClimateTech Hack",
      tagline: "Tech solutions for a sustainable planet",
      description:
      "Innovate solutions addressing climate change, agriculture, and clean energy.",
      organizer: "Climate Foundation",
      organizerLogo: "https://picsum.photos/100?3",
      organizerWebsite: "https://climatetechhack.org",
      bannerImage: "https://picsum.photos/id/1040/800/400",
      galleryImages: [],
      promoVideo: "",
      themes: ["CleanEnergy", "AgriTech", "Mobility", "Climate"],
      technologies: ["Flutter", "IoT", "Python"],
      isOnline: false,
      venue: "Berlin Innovation Hub",
      city: "Berlin",
      state: "",
      country: "Germany",
      googleMapLink: "",
      registrationStart: DateTime.now().subtract(const Duration(days: 2)),
      registrationEnd: DateTime.now().add(const Duration(days: 12)),
      hackathonStart: DateTime.now().add(const Duration(days: 14)),
      hackathonEnd: DateTime.now().add(const Duration(days: 16)),
      resultDate: DateTime.now().add(const Duration(days: 18)),
      registrationOpen: true,
      requiresApproval: true,
      registrationFee: 20,
      maxParticipants: 300,
      minTeamSize: 2,
      maxTeamSize: 4,
      totalPrizePool: "€30,000",
      accentColor: const Color(0xFFFF8A00),
      prizes: [
        Prize(position: "1st", amount: "€15,000", description: "Champion"),
        Prize(position: "2nd", amount: "€10,000", description: "Runner Up"),
        Prize(position: "3rd", amount: "€5,000", description: "Third Place"),
      ],
      judges: [],
      mentors: [],
      sponsors: [],
      faqs: [],
      schedule: [],
      resources: [],
      discordLink: "",
      whatsappLink: "",
      linkedinLink: "",
      instagramLink: "",
      email: "info@climatetechhack.org",
      phone: "",
      registeredTeams: 42,
      registeredParticipants: 166,
      views: 5400,
      rating: 4.7,
      eligibility: "Students & Professionals",
      rules: ["2-4 members", "Prototype required"],
      participationCertificate: true,
      winnerCertificate: true,
      featured: false,
      bookmarked: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(), tracks: [],
    ),

    Hackathon(
      id: "4",
      title: "HealthByte",
      tagline: "Reinvent healthcare with code",
      description:
      "Build innovative healthcare applications powered by AI, cloud, and data science.",
      organizer: "HealthByte Foundation",
      organizerLogo: "https://picsum.photos/100?4",
      organizerWebsite: "https://healthbyte.org",
      bannerImage: "https://picsum.photos/id/1039/800/400",
      galleryImages: [],
      promoVideo: "",
      themes: ["MedTech", "BioInfo", "HealthAI", "Wellness"],
      technologies: ["Flutter", "Firebase", "TensorFlow"],
      isOnline: false,
      venue: "Boston Convention Center",
      city: "Boston",
      state: "Massachusetts",
      country: "USA",
      googleMapLink: "",
      registrationStart: DateTime.now().subtract(const Duration(days: 5)),
      registrationEnd: DateTime.now().add(const Duration(days: 18)),
      hackathonStart: DateTime.now().add(const Duration(days: 21, hours: 6)),
      hackathonEnd: DateTime.now().add(const Duration(days: 22, hours: 18)),
      resultDate: DateTime.now().add(const Duration(days: 24)),
      registrationOpen: true,
      requiresApproval: false,
      registrationFee: 15,
      maxParticipants: 400,
      minTeamSize: 2,
      maxTeamSize: 5,
      totalPrizePool: "\$75,000",
      accentColor: const Color(0xFF6C63FF),

      prizes: [
        Prize(position: "1st", amount: "\$40,000", description: "Champion"),
        Prize(position: "2nd", amount: "\$20,000", description: "Runner Up"),
        Prize(position: "3rd", amount: "\$15,000", description: "Third Place"),
      ],
      judges: [],
      mentors: [],
      sponsors: [],
      faqs: [],
      schedule: [],
      resources: [],
      discordLink: "",
      whatsappLink: "",
      linkedinLink: "",
      instagramLink: "",
      email: "support@healthbyte.org",
      phone: "",
      registeredTeams: 75,
      registeredParticipants: 180,
      views: 6700,
      rating: 4.6,
      eligibility: "Students & Professionals",
      rules: ["Maximum 5 members", "Working demo required"],
      participationCertificate: true,
      winnerCertificate: true,
      featured: false,
      bookmarked: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(), tracks: [],
    ),
  ];

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
      case 4: Navigator.of(context).pushNamed('/Profile'); break;
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
                                    Navigator.of(context).pushNamed('/request'),
                                onAvatarTap: () =>
                                    Navigator.of(context).pushNamed('/Profile'),
                              ),

                            // White card surface for search + filters
                            // Container(
                            //   color: DC.bg0,
                            //   child: Column(
                            //     children: [
                            //       const SizedBox(height: 4),
                            //       HomeSearchBar(
                            //         query: provider.searchQuery,
                            //         onChanged: provider.onSearchChanged,
                            //         onClear: provider.clearSearch,
                            //       ),
                            //
                            // ),
                          ],
                        ),
                      ),

                      // ── Developer stories ─────────────────────────────────
                      SliverToBoxAdapter(
                        child: Container(
                          color: DC.bg1,
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


                      SliverToBoxAdapter(
                        child: Container(
                          color: DC.bg1,
                          child: SectionHeader(
                            title: "Your Hackathons",
                            showDot: !provider.isSearching,
                            onSeeAll: provider.isSearching
                                ? null
                                : () =>
                                Navigator.of(context).pushNamed('/showcase'),
                          ),
                        ),
                      ),

                      // ── Hackathon Card Stack ──────────────────────────────────────────────
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                          child: HackathonCardStack(
                            hackathons: sampleHackathons,
                            cardWidth: MediaQuery.of(context).size.width - 10,

                            onRegister: (h) {
                              Navigator.of(context).pushNamed('/hackathon/${h.id}');
                            },
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

                      SliverToBoxAdapter(
                        child:  FilterChipsRow(
                          active: provider.activeFilter,
                          onSelect: provider.setFilter,
                        ),
                      ),

                      SliverToBoxAdapter(
                        child:
                        const SizedBox(height: 10,),
                      ),
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

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 22),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(
          sigmaX: 100,
          sigmaY: 100,
        ),
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              // Glass background
              color: Colors.transparent,

              borderRadius: BorderRadius.circular(28),

              border: Border.all(
                color: Colors.white.withOpacity(0.25),
                width: 1,
              ),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  _NavItem(
                    icon: Icons.home_rounded,
                    label: 'Home',
                    index: 0,
                    current: currentIndex,
                    onTap: onTap,
                  ),
                  _NavItem(
                    icon: Icons.search_rounded,
                    label: 'Explore',
                    index: 1,
                    current: currentIndex,
                    onTap: onTap,
                  ),
                  _NavPlusButton(
                    onTap: () => onTap(2),
                  ),
                  _NavItem(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: 'Chat',
                    index: 3,
                    current: currentIndex,
                    onTap: onTap,
                    badgeCount: 3,
                  ),
                  _NavItem(
                    icon: Icons.person_outline_rounded,
                    label: 'Profile',
                    index: 4,
                    current: currentIndex,
                    onTap: onTap,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
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

  bool get selected => current == index;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onTap(index),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                height: 35,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: selected
                      ? Color(0xFF6C5CE7).withOpacity(0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      icon,
                      size: 24,
                      color: selected
                          ?  Color(0xFF4834D4)
                          : Colors.black.withOpacity(0.42),
                    ),
                    if (badgeCount > 0)
                      Positioned(
                        right: -6,
                        top: -6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 1,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF6B6B), Color(0xFFEE4444)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white, width: 1.5),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            badgeCount > 9 ? '9+' : '$badgeCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              height: 1.1,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 3),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 220),
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected
                      ?  Color(0xFF4834D4)
                      : Colors.black.withOpacity(0.38),
                  letterSpacing: 0.1,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavPlusButton extends StatelessWidget {
  final VoidCallback onTap;

  const _NavPlusButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 46,
            height: 46,
            margin: const EdgeInsets.only(bottom: 2),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C5CE7),  Color(0xFF4834D4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF6C5CE7).withOpacity(0.45),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                  spreadRadius: -2,
                ),
              ],
            ),
            child: const Icon(
              Icons.add_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
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
            iconColor: DC.p,
            iconBg: DC.p,
            title: 'Post a project',
            subtitle: 'Find teammates for your next build',
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/postproject');
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