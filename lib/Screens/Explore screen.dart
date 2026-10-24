import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/explore_provider.dart';
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
  late final AnimationController _entryCtrl;
  late final Animation<double> _entryFade;
  late final Animation<Offset> _entrySlide;
  final ScrollController _scrollCtrl = ScrollController();
  int _navIndex = 1;

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
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutCubic));

    _scrollCtrl.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _entryCtrl.forward();
    });
  }

  void _onScroll() {
    final provider = Provider.of<ExploreProvider>(context, listen: false);
    if (_scrollCtrl.position.pixels >= _scrollCtrl.position.maxScrollExtent - 300) {
      provider.loadMoreUsers();
    }
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    HapticFeedback.mediumImpact();
    setState(() => _navIndex = index);

    switch (index) {
      case 0:
        Navigator.of(context).pushNamed('/home');
        break;
      case 2:
        _showPostSheet();
        break;
      case 3:
        Navigator.of(context).pushNamed('/chat');
        break;
      case 4:
        Navigator.of(context).pushNamed('/Profile');
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

    return ChangeNotifierProvider(
      create: (_) => ExploreProvider(),
      child: Scaffold(
        backgroundColor: DC.bg1,
        body: SafeArea(
          bottom: false,
          child: Consumer<ExploreProvider>(
            builder: (context, provider, _) {
              return FadeTransition(
                opacity: _entryFade,
                child: SlideTransition(
                  position: _entrySlide,
                  child: RefreshIndicator(
                    color: DC.bg0,
                    onRefresh: provider.refresh,
                    child: CustomScrollView(
                      controller: _scrollCtrl,
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Explore",style: DCText.h1,),
                                    Text("Discover.Connect.Collaborate",style: TextStyle(fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xff4B2DC5),
                                        letterSpacing: -0.5),),
                                    
                                    Text("One place to find the right \n people for your next big idea.",style: DCText.caption,)


                                  ],
                                ),
                                const Spacer(),
                                CircleAvatar(
                                  child: IconButton(onPressed: (){
                                    provider.searchclick();
                                  }, icon: Icon(Icons.search)),
                                )
                              ],
                            ),
                          ),
                        ),

                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 280),
                                curve: Curves.easeInOut,
                                height: provider.showsearch ? 56 : 0, // adjust height based on your search bar
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: AnimatedOpacity(
                                  duration: const Duration(milliseconds: 250),
                                  opacity: provider.showsearch ? 1.0 : 0.0,
                                  child: HomeSearchBar(
                                    query: provider.searchQuery,
                                    onChanged: provider.onSearchChanged,
                                    onClear: provider.clearSearch,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  elevation: 2,
                                  shadowColor: Colors.black.withOpacity(0.1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: Stack(
                                    children: [
                                      // Image
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.asset(
                                          "assets/images/Explore_poster.png",
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 250, // Adjust height as needed
                                        ),
                                      ),

                                      // Optional subtle overlay for better aesthetics
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                Colors.transparent,
                                                Colors.black.withOpacity(0.15),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),



                              Container(
                                color: DC.bg1,
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: FilterChipsRow(
                                  active: provider.activeFilter,
                                  onSelect: provider.setFilter,
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(9),
                                child: Row(
                                  children: [
                                    Text(
                                      "Developers for you",
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const Spacer(),
                                    _buildAvailabilityBadge(),
                                  ],
                                ),
                              ),

                              if (provider.isLoading && provider.filteredUsers.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.all(2),
                                  child: CircularProgressIndicator(),
                                )
                              else if (provider.filteredUsers.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.all(2),
                                  child: Text(
                                    "No developers found",
                                    style: TextStyle(fontSize: 16, color: Colors.grey),
                                  ),
                                )
                              else
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: provider.filteredUsers.length,
                                  itemBuilder: (context, index) {
                                    final user = provider.filteredUsers[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(0),
                                      child: ExploreCard(
                                        id: user.id,
                                        name: user.name,
                                        role: user.role,
                                        location: user.location,
                                        experience: user.experience,
                                        skills: user.skills,
                                        avatarUrl: user.avatarUrl,
                                        isAvailable: user.isAvailable,
                                      ),
                                    );
                                  },
                                ),

                              if (provider.isLoadingMore)
                                const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Center(child: CircularProgressIndicator()),
                                ),

                              const SizedBox(height: 100),
                            ],
                          ),
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
      ),
    );
  }

  Widget _buildAvailabilityBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: DC.bg0.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified_rounded, size: 16, color: Colors.green),
          SizedBox(width: 4),
          Text("Available Now", style: TextStyle(color: DC.textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
        ],
      ),
    );
  }

  void _showAdvancedFilter(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Advanced filters coming soon")),
    );
  }
}