import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/Reqest_model.dart';
import '../providers/request_provider.dart';
import '../utils/AppColors.dart';
import '../utils/app_theme.dart';
import '../widgets/animated_list_item.dart';
import '../widgets/empty_state.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/home/home_widgets.dart';
import '../widgets/loading_skeleton.dart';
import '../widgets/request_card.dart';
import '../widgets/request_detail_sheet.dart';
import '../widgets/request_search_bar.dart';
import '../widgets/segmented_tab_bar.dart';
import '../widgets/stats_header.dart';
import 'Homescreen.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final ScrollController _scrollCtrl = ScrollController();
  final TextEditingController _searchCtrl = TextEditingController();
  int _navIndex = 2;
  bool _searchOpen = false;

  final Map<String, bool> _exiting = {}; // id -> isAccept
  final Set<String> _dismissed = {};

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    HapticFeedback.selectionClick();
    setState(() => _navIndex = index);
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.of(context).pushNamed('/explore');
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

  void _startExit(String id, bool isAccept, RequestProvider provider) {
    HapticFeedback.mediumImpact();
    setState(() => _exiting[id] = isAccept);
    if (isAccept) {
      provider.acceptRequest(id);
    } else {
      provider.rejectRequest(id);
    }
  }

  void _onExitCompleted(String id) {
    setState(() {
      _exiting.remove(id);
      _dismissed.add(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    final accent = AppColors.primary;

    return ChangeNotifierProvider(
      create: (_) => RequestProvider(),
      child: Scaffold(
        backgroundColor: DC.bg1,
        bottomNavigationBar: BottomNav(currentIndex: _navIndex, onTap: _onNavTap),
        body: SafeArea(
          child: Consumer<RequestProvider>(
            builder: (context, provider, _) {
              final isReceivedTab = provider.currentTab == 0;

              return NestedScrollView(
                controller: _scrollCtrl,
                headerSliverBuilder: (context, innerBoxScrolled) => [
                  _buildSliverAppBar(context, provider, accent),
                  SliverToBoxAdapter(
                    child: SegmentedTabBar(
                      currentIndex: provider.currentTab,
                      unreadCount: provider.totalUnreadRequests,
                      accent: accent,
                      onChanged: provider.switchTab,
                    ),
                  ),
                  if (_searchOpen)
                    SliverToBoxAdapter(
                      child: RequestSearchBar(
                        controller: _searchCtrl,
                        accent: accent,
                        onChanged: provider.setSearchQuery,
                        onClose: () {
                          setState(() => _searchOpen = false);
                          _searchCtrl.clear();
                          provider.setSearchQuery('');
                        },
                      ),
                    ),
                  // if (isReceivedTab)
                  //   SliverToBoxAdapter(
                  //     child: StatsHeader(
                  //       incoming: provider.receivedRequests.length,
                  //       pending: 2,
                  //       acceptedToday: 3,
                  //       unread: provider.totalUnreadRequests,
                  //     ),
                  //   ),
                ],
                body: RefreshIndicator(
                  color: accent,
                  onRefresh: provider.refresh,
                  child: provider.isLoading
                      ? const LoadingSkeleton()
                      : isReceivedTab
                      ? _buildRequestList(
                    context,
                    provider,
                    provider.receivedRequests,
                    isReceived: true,
                    accent: accent,
                  )
                      : _buildRequestList(
                    context,
                    provider,
                    provider.sentRequests,
                    isReceived: false,
                    accent: accent,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(
      BuildContext context, RequestProvider provider, Color accent) {
    return SliverAppBar(
      backgroundColor: DC.bg1,
      elevation: 0,
      pinned: true,
      floating: true,
      expandedHeight: 92,
      leadingWidth: 44,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: _RoundIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () => Navigator.of(context).maybePop(),
        ),
      ),
      actions: [
        // _RoundIconButton(
        //   icon: Icons.tune_rounded,
        //   onTap: () => FilterBottomSheet.show(
        //     context,
        //     currentFilter: provider.filter,
        //     currentSort: provider.sort,
        //     accent: accent,
        //     onFilterChanged: (f) {
        //       provider.setFilter(f);
        //       Navigator.pop(context);
        //     },
        //     onSortChanged: (s) {
        //       provider.setSort(s);
        //       Navigator.pop(context);
        //     },
        //   ),
        // ),
        const SizedBox(width: 8),
        Stack(
          clipBehavior: Clip.none,
          children: [
            _RoundIconButton(
              icon: _searchOpen ? Icons.search_off_rounded : Icons.search_rounded,
              onTap: () => setState(() => _searchOpen = !_searchOpen),
            ),
            if (provider.totalUnreadRequests > 0)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: Text(
                    provider.totalUnreadRequests > 9 ? '9+' : '${provider.totalUnreadRequests}',
                    style: const TextStyle(
                        color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(width: 12),
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        title: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Connection Requests',
                    style: TextStyle(
                        color: DC.textPrimary, fontWeight: FontWeight.w800, fontSize: 15)),
              ],
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment:  MainAxisAlignment.center,
              children: [
                Text('Manage incoming and outgoing requests',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 10.5)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequestList(
      BuildContext context,
      RequestProvider provider,
      List<RequestModel> requests, {
        required bool isReceived,
        required Color accent,
      }) {
    final visible = requests.where((r) => !_dismissed.contains(r.id)).toList();

    if (visible.isEmpty) {
      return EmptyState(
        icon: isReceived ? Icons.inbox_outlined : Icons.send_outlined,
        title: isReceived ? 'No requests yet' : 'No sent requests',
        subtitle: isReceived
            ? 'Incoming connection requests will appear here'
            : 'Your outgoing requests will show here',
        accent: accent,
        onCta: () => Navigator.of(context).pushNamed('/explore'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 4, bottom: 24),
      itemCount: visible.length,
      itemBuilder: (context, index) {
        final request = visible[index];
        final exitingAccept = _exiting[request.id];

        final card = RequestCard(
          key: ValueKey(request.id),
          request: request,
          isReceived: isReceived,
          accent: accent,
          onAccept: () => _startExit(request.id, true, provider),
          onReject: () => _startExit(request.id, false, provider),
          onTap: () {
            provider.markAsRead(request.id);
            RequestDetailSheet.show(
              context,
              request: request,
              isReceived: isReceived,
              accent: accent,
              onAccept: () => _startExit(request.id, true, provider),
              onReject: () => _startExit(request.id, false, provider),
            );
          },
          onViewProfile: () {},
          onReport: () {},
          onBlock: () {},
        );

        final wrapped = exitingAccept == null
            ? card
            : RequestExitAnimation(
          isAccept: exitingAccept,
          onCompleted: () => _onExitCompleted(request.id),
          child: card,
        );

        return AnimatedListItem(index: index, child: wrapped);
      },
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark ? Colors.white.withOpacity(0.06) : Colors.grey.shade100,
        ),
        child: Icon(icon, size: 19, color: DC.textPrimary),
      ),
    );
  }
}