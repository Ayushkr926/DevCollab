


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/home_provider.dart';
import '../utils/app_theme.dart';
import '../widgets/explore/cardui.dart';
import '../widgets/home/home_widgets.dart';
import 'Homescreen.dart';

class Explorescreen extends StatefulWidget {
  const Explorescreen({super.key});

  @override
  State<Explorescreen> createState() => _ExplorescreenState();
}

class _ExplorescreenState extends State<Explorescreen>
    with SingleTickerProviderStateMixin {
  int _navIndex = 1;

  late final AnimationController _entryCtrl;
  late final Animation<double> _entryFade;
  late final Animation<Offset> _entrySlide; // FIXED

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

    // ✅ FIXED SLIDE ANIMATION
    _entrySlide = Tween<Offset>(
      begin: const Offset(0, 0.1), // slight downward
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut),
    );

    _scrollCtrl.addListener(_onScroll);

    // ✅ START ANIMATION
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _entryCtrl.forward();
    });
  }

  void _onScroll() {
    // Future infinite scroll logic
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    HapticFeedback.selectionClick();
    setState(() => _navIndex = index);

    switch (index) {
      case 0:
        Navigator.of(context).pushNamed('/home');
        break;
      case 1:

        break;
      case 2:
        _showPostSheet();
        break;
      case 3:
        Navigator.of(context).pushNamed('/chat');
        break;
      case 4:
        Navigator.of(context).pushNamed('/profile');
        break;
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

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Scaffold(
      backgroundColor: DC.bg1,
      body: SafeArea(
        bottom: false,
        child: Consumer<HomeProvider>(
          builder: (context, provider, _) {
            return FadeTransition(
              opacity: _entryFade,
              child: SlideTransition(
                position: _entrySlide, // ✅ FIXED
                child: RefreshIndicator(
                  color: DC.p,
                  onRefresh: provider.refresh,
                  child: CustomScrollView(
                    controller: _scrollCtrl,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 13.0,vertical: 8.0),
                              child: const Text(
                                "Find Developers",
                                style: TextStyle(color: Colors.black,fontSize: 19,fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Divider(height: 10),
                            HomeSearchBar(
                              query: provider.searchQuery,
                              onChanged: provider.onSearchChanged,
                              onClear: provider.clearSearch,
                            ),

                            Container(
                              color: DC.bg0,
                              child: Column(
                                children: [
                                  const SizedBox(height: 4),
                                  FilterChipsRow(
                                    active: provider.activeFilter,
                                    onSelect: provider.setFilter,
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 8),
                              child: Row(
                                children: [
                                  const Text(
                                    "248 Developers",
                                    style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),

                                  const Text(
                                    "Available Only",
                                    style: TextStyle(color: DC.textPrimary,fontSize: 14,fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),

                            ExploreCard(
                              name: "Akash",
                              role: "Full Stack",
                              location: "Bangalore",
                            )
                          ],
                        ),
                      ),


                      const SliverToBoxAdapter(
                        child: SizedBox(height: 88),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: _navIndex,
        onTap: _onNavTap,
      ),
    );
  }
}