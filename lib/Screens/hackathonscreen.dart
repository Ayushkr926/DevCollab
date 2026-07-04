import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/hackathonprovider.dart';
import '../utils/app_theme.dart';
import '../widgets/hackathoncard.dart'; // Make sure this matches your file name
import '../widgets/home/home_widgets.dart';
import 'Homescreen.dart';

class HackathonScreen extends StatefulWidget {
  const HackathonScreen({super.key});

  @override
  State<HackathonScreen> createState() => _HackathonScreenState();
}

class _HackathonScreenState extends State<HackathonScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entryCtrl;
  late final Animation<double> _entryFade;
  late final Animation<Offset> _entrySlide;
  final ScrollController _scrollCtrl = ScrollController();
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();

    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _entryFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic),
    );

    _entrySlide = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _entryCtrl.forward();
    });

    _scrollCtrl.addListener(_onScroll);
  }

  void _onScroll() {
    final provider = Provider.of<HackathonProvider>(context, listen: false);
    if (_scrollCtrl.position.pixels >= _scrollCtrl.position.maxScrollExtent - 400) {
      provider.loadMoreHackathons();
    }
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HackathonProvider(),
      child: Scaffold(
        backgroundColor: DC.bg1,
        body: SafeArea(
          child: FadeTransition(
            opacity: _entryFade,
            child: SlideTransition(
              position: _entrySlide,
              child: Consumer<HackathonProvider>(
                builder: (context, provider, _) {
                  return RefreshIndicator(
                    onRefresh: provider.refresh,
                    color: DC.p,
                    child: CustomScrollView(
                      controller: _scrollCtrl,
                      slivers: [
                        SliverAppBar(
                          backgroundColor: DC.bg1,
                          floating: true,
                          snap: true,
                          elevation: 0,
                          title: const Text(
                            "Hackathons",
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          actions: [
                            IconButton(
                              icon: const Icon(Icons.filter_list_rounded, color: Colors.black),
                              onPressed: () {},
                            ),
                          ],
                        ),

                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: HomeSearchBar(
                                  query: provider.searchQuery,
                                  onChanged: provider.onSearchChanged,
                                  onClear: provider.clearSearch,
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Filters (Uncommented & Enhanced)
                              // FilterChipsRow(
                              //   active: provider.selectedFilter,
                              //   onSelect: provider.setFilter,
                              //   filters: const ['All', 'Upcoming', 'Ongoing', 'Past'],
                              // ),
                              //
                              // const SizedBox(height: 8),
                              //
                              // FilterChipsRow(
                              //   active: provider.selectedMode,
                              //   onSelect: provider.setMode,
                              //   filters: const ['All', 'Online', 'Offline'],
                              // ),

                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                                child: Row(
                                  children: [
                                    Text(
                                      "${provider.hackathons.length} Hackathons",
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: DC.p.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: const Text(
                                        "Sort: Soonest",
                                        style: TextStyle(color: DC.p, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                                (context, index) {
                              final hackathon = provider.hackathons[index];
                              return Hackcard(
                                hackathon: hackathon,
                                onBookmark: () => provider.toggleBookmark(hackathon.id),
                                onRegister: () => provider.registerForHackathon(hackathon.id),
                              );
                            },
                            childCount: provider.hackathons.length,
                          ),
                        ),

                        if (provider.isLoadingMore)
                          const SliverToBoxAdapter(
                            child: Padding(
                              padding: EdgeInsets.all(24.0),
                              child: Center(child: CircularProgressIndicator()),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNav(
          currentIndex: _navIndex,
          onTap: (index) => setState(() => _navIndex = index),
        ),
      ),
    );
  }
}