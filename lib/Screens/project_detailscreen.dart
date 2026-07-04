import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/app_theme.dart';
import '../providers/project_provider.dart';

class ProjectDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> project;
  const ProjectDetailsScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProjectProvider(project: project),
      child: const _ProjectDetailsView(),
    );
  }
}

class _ProjectDetailsView extends StatefulWidget {
  const _ProjectDetailsView();

  @override
  State<_ProjectDetailsView> createState() => _ProjectDetailsViewState();
}

class _ProjectDetailsViewState extends State<_ProjectDetailsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  double _appBarOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final offset = _scrollController.offset;
    final newOpacity = (offset / 200).clamp(0.0, 1.0);
    if ((newOpacity - _appBarOpacity).abs() > 0.05) {
      setState(() => _appBarOpacity = newOpacity);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProjectProvider>();
    final project = provider.project;

    return Scaffold(
      backgroundColor: DC.bg2,
      body: Stack(
        children: [
          NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              _buildSliverAppBar(project, provider),
              const SliverToBoxAdapter(child: SizedBox(height: 180)),
              SliverPersistentHeader(
                pinned: true,
                delegate: _TabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    labelColor: Colors.deepPurple,
                    unselectedLabelColor: Colors.grey[500],
                    indicatorColor: Colors.deepPurple,
                    indicatorWeight: 3,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                    ),
                    tabs: const [
                      Tab(text: "Overview"),
                      Tab(text: "Team"),
                      Tab(text: "Discussion"),
                    ],
                  ),
                ),
              ),
            ],
            body: TabBarView(
              controller: _tabController,
              children: [
                _OverviewTab(project: project),
                const _TeamTab(),
                const _DiscussionTab(),
              ],
            ),
          ),
          _buildFloatingTopBar(context, provider),
        ],
      ),
      bottomNavigationBar: _buildBottomActionBar(context, provider),
    );
  }

  // ==================== UI BUILDERS ====================

  Widget _buildSliverAppBar(Map<String, dynamic> project, ProjectProvider provider) {
    return SliverAppBar(
      pinned: false,
      stretch: true,
      expandedHeight: 300,
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: 'project-image-${project['title']}',
              child: Image.network(
                "https://i.pinimg.com/736x/74/96/98/749698cbed1f9f7adceb9b4f9c7a21d5.jpg",
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.image_not_supported_rounded,
                      color: Colors.grey, size: 60),
                ),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x80000000),
                    Color(0x40000000),
                    Color(0xB0000000),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: -140,
              child: _buildHeaderCard(project),

            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingTopBar(BuildContext context, ProjectProvider provider) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 8,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _circleIconButton(
            icon: Icons.arrow_back_rounded,
            bgOpacity: _appBarOpacity,
            onTap: () => Navigator.maybePop(context),
          ),
          Row(
            children: [
              _circleIconButton(
                icon: provider.isBookmarked
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                bgOpacity: _appBarOpacity,
                iconColor: provider.isBookmarked ? Colors.amber[700] : null,
                onTap: provider.toggleBookmark,
              ),
              const SizedBox(width: 12),
              _circleIconButton(
                icon: Icons.ios_share_rounded,
                bgOpacity: _appBarOpacity,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Share link copied to clipboard")),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circleIconButton({
    required IconData icon,
    required double bgOpacity,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Color.lerp(
            Colors.black.withOpacity(0.35),
            Colors.white,
            bgOpacity,
          ),
          boxShadow: bgOpacity > 0.4
              ? [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10)]
              : null,
        ),
        child: Icon(
          icon,
          size: 22,
          color: iconColor ?? Color.lerp(Colors.white, Colors.grey[800], bgOpacity),
        ),
      ),
    );
  }

  // ... (rest of your methods like _buildHeaderCard, _buildBottomActionBar, _typeGradient, _daysColor remain mostly same)

  Widget _buildHeaderCard(Map<String, dynamic> project) {
    final membersStr = project['members'] as String? ?? "0/0";
    final parts = membersStr.split('/');
    final filled = int.tryParse(parts[0]) ?? 0;
    final total = parts.length > 1 ? (int.tryParse(parts[1]) ?? 1) : 1;
    final progress = total == 0 ? 0.0 : filled / total;

    return Transform.translate(
      offset: const Offset(0, -30),
      child: Container(
        margin: const EdgeInsets.fromLTRB(8,180,8,0),
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.12),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Type + Days
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: _typeGradient(project['type'])),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    project['type'] ?? 'Project',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(Icons.circle, size: 9, color: _daysColor(project['days'])),
                const SizedBox(width: 6),
                Text(
                  project['days'] ?? '',
                  style: TextStyle(
                    color: _daysColor(project['days']),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              project['title'] ?? 'Untitled Project',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.deepPurple.shade50,
                  child: Text(
                    (project['owner']?[0] ?? '?').toUpperCase(),
                    style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "by ${project['owner'] ?? 'Unknown'}",
                  style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                const Icon(Icons.groups_rounded, size: 20, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  "$filled of $total spots filled",
                  style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600),
                ),
              ],
            ),

            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation(
                  progress >= 1 ? Colors.green : Colors.deepPurple,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActionBar(BuildContext context, ProjectProvider provider) {
    final status = provider.joinStatus;
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 20,
              offset: const Offset(0, -4),
            )
          ],
        ),
        child: Row(
          children: [
            // Chat Button
            GestureDetector(
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Opening chat...")),
              ),
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.chat_bubble_outline_rounded,
                    color: Colors.deepPurple),
              ),
            ),
            const SizedBox(width: 14),

            // Main Action Button
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: SizedBox(
                  key: ValueKey(status),
                  height: 52,
                  child: ElevatedButton(
                    onPressed: status == JoinStatus.none ? provider.requestToJoin : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: status == JoinStatus.joined
                          ? Colors.green
                          : status == JoinStatus.pending
                          ? Colors.grey[400]
                          : Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: status == JoinStatus.pending
                        ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text("Requesting...",
                            style: TextStyle(fontWeight: FontWeight.w700)),
                      ],
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          status == JoinStatus.joined
                              ? Icons.check_circle
                              : Icons.send_rounded,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          status == JoinStatus.joined
                              ? "Request Sent"
                              : "Request to Join",
                          style: const TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Color> _typeGradient(String type) {
    switch (type.toLowerCase()) {
      case 'hackathon':
        return [Colors.purple, Colors.deepPurpleAccent];
      case 'freelance':
        return [Colors.green, Colors.teal];
      case 'open source':
        return [Colors.orange, Colors.deepOrangeAccent];
      default:
        return [Colors.blue, Colors.indigo];
    }
  }

  Color _daysColor(String days) {
    if (days.contains("Left")) return Colors.redAccent;
    if (days.contains("Ongoing")) return Colors.green;
    return Colors.blue;
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  bool shouldRebuild(covariant _TabBarDelegate oldDelegate) => false;
}

// ---------------- OVERVIEW TAB ----------------

class _OverviewTab extends StatelessWidget {
  final Map<String, dynamic> project;
  const _OverviewTab({required this.project});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProjectProvider>();
    final description = project['description'] as String;
    final isLong = description.length > 120;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("About this project",
              style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          AnimatedCrossFade(
            firstChild: Text(description,
                maxLines: 3, overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14, height: 1.55, color: Colors.grey[700])),
            secondChild: Text(description,
                style: TextStyle(fontSize: 14, height: 1.55, color: Colors.grey[700])),
            crossFadeState:
            provider.descriptionExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
          if (isLong)
            GestureDetector(
              onTap: provider.toggleDescription,
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  provider.descriptionExpanded ? "Show less" : "Read more",
                  style: const TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ),
            ),
          const SizedBox(height: 22),
          const Text("Tech Stack", style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (project['tech'] as List)
                .map((t) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Text(t.toString(),
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.grey[700])),
            ))
                .toList(),
          ),
          const SizedBox(height: 22),
          const Text("Project Timeline", style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _buildTimelineTile(
            icon: Icons.flag_rounded,
            color: Colors.deepPurple,
            title: "Project Created",
            subtitle: "Owner posted this opportunity",
            isFirst: true,
          ),
          _buildTimelineTile(
            icon: Icons.groups_2_rounded,
            color: Colors.blue,
            title: "Team Forming",
            subtitle: "${project['members']} members joined so far",
          ),
          _buildTimelineTile(
            icon: Icons.flag_circle_rounded,
            color: Colors.grey,
            title: "Deadline",
            subtitle: project['days'],
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
                child: Icon(icon, size: 16, color: color),
              ),
              if (!isLast) Expanded(child: Container(width: 2, color: Colors.grey[200])),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20, top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 3),
                  Text(subtitle, style: TextStyle(fontSize: 12.5, color: Colors.grey[500])),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------- TEAM TAB ----------------

class _TeamTab extends StatelessWidget {
  const _TeamTab();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProjectProvider>();
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      itemCount: provider.team.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final member = provider.team[index];
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3))],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Colors.deepPurple.withOpacity(0.1),
                child: Text(member.name[0].toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(member.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5)),
                        if (member.isOwner) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text("OWNER",
                                style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: Colors.amber)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(member.role, style: TextStyle(fontSize: 12.5, color: Colors.grey[500])),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
            ],
          ),
        );
      },
    );
  }
}

// ---------------- DISCUSSION TAB ----------------

class _DiscussionTab extends StatefulWidget {
  const _DiscussionTab();

  @override
  State<_DiscussionTab> createState() => _DiscussionTabState();
}

class _DiscussionTabState extends State<_DiscussionTab> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProjectProvider>();
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            itemCount: provider.comments.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final c = provider.comments[index];
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.deepPurple.withOpacity(0.1),
                    child: Text(c.author[0].toUpperCase(),
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(c.author, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                              const SizedBox(width: 8),
                              Text(c.time, style: TextStyle(fontSize: 11, color: Colors.grey[400])),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(c.text, style: TextStyle(fontSize: 13.5, color: Colors.grey[700], height: 1.4)),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey[200]!)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Write a comment...",
                    hintStyle: TextStyle(fontSize: 13.5, color: Colors.grey[400]),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  provider.addComment(_controller.text);
                  _controller.clear();
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(color: Colors.deepPurple, shape: BoxShape.circle),
                  child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}