import 'package:devcollab/Screens/project_detailscreen.dart';
import 'package:devcollab/widgets/projectcard.dart';
import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

class Allproject extends StatefulWidget {
  const Allproject({super.key});

  @override
  State<Allproject> createState() => _AllprojectState();
}

class _AllprojectState extends State<Allproject> {
  final List<Map<String, dynamic>> _allProjects = [
    {
      "title": "AI Resume Builder",
      "owner": "Ayush Kumar",
      "description":
      "Looking for a Flutter developer to build an AI-powered resume builder.",
      "type": "Hackathon",
      "members": "3/5",
      "days": "5 Days Left",
      "tech": ["Flutter", "Firebase", "AI"],
    },
    {
      "title": "Expense Tracker",
      "owner": "Rahul Sharma",
      "description": "Need a backend developer for Node.js APIs.",
      "type": "Freelance",
      "members": "2/4",
      "days": "10 Days Left",
      "tech": ["Node", "MongoDB", "Express"],
    },
    {
      "title": "Open Source Chat App",
      "owner": "Ankit",
      "description": "Looking for contributors to improve chat features.",
      "type": "Open Source",
      "members": "6/10",
      "days": "Ongoing",
      "tech": ["Flutter", "Socket", "Firebase"],
    },
  ];

  final TextEditingController _searchController = TextEditingController();
  String _query = "";
  String _activeFilter = "All";

  final List<String> _filters = const [
    "All",
    "Hackathon",
    "Freelance",
    "Open Source",
  ];

  List<Map<String, dynamic>> get _filteredProjects {
    return _allProjects.where((p) {
      final matchesFilter =
          _activeFilter == "All" || p['type'] == _activeFilter;
      final matchesQuery = _query.isEmpty ||
          (p['title'] as String).toLowerCase().contains(_query.toLowerCase()) ||
          (p['owner'] as String).toLowerCase().contains(_query.toLowerCase());
      return matchesFilter && matchesQuery;
    }).toList();
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 700));
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = _filteredProjects;

    return Scaffold(
      backgroundColor: DC.bg2,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: _buildSearchBar()),
              SliverToBoxAdapter(child: _buildFilterChips()),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 4, 20, 8),
                  child: Text(
                    "${results.length} project${results.length == 1 ? '' : 's'} found",
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: DC.textSecondary,
                    ),
                  ),
                ),
              ),
              if (results.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildEmptyState(),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(10, 4, 10, 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        final project = results[index];
                        return TweenAnimationBuilder<double>(
                          key: ValueKey(project['title']),
                          tween: Tween(begin: 0, end: 1),
                          duration: Duration(milliseconds: 300 + index * 70),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, (1 - value) * 20),
                                child: child,
                              ),
                            );
                          },
                          child: CardUI(
                            project: project,
                            onTap: () => Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: const Duration(milliseconds: 350),
                                pageBuilder: (context, anim, __) => FadeTransition(
                                  opacity: anim,
                                  child: ProjectDetailsScreen(project: project),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: results.length,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/postproject');
        },
        backgroundColor: Colors.deepPurple,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text("New Project",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "All Projects",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
              color: DC.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Explore innovative ideas and join teams creating the future.",
            style: TextStyle(
              fontSize: 13.5,
              height: 1.5,
              color: DC.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 14, 10, 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (v) => setState(() => _query = v),
          decoration: InputDecoration(
            hintText: "Search by title or owner...",
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            prefixIcon: Icon(Icons.search_rounded, color: Colors.grey[400]),
            suffixIcon: _query.isNotEmpty
                ? IconButton(
              icon: Icon(Icons.close_rounded, color: Colors.grey[400]),
              onPressed: () {
                _searchController.clear();
                setState(() => _query = "");
              },
            )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 54,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 6),
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isActive = filter == _activeFilter;
          return GestureDetector(
            onTap: () => setState(() => _activeFilter = filter),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isActive ? Colors.deepPurple : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isActive ? Colors.deepPurple : Colors.grey[200]!,
                ),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : Colors.grey[700],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 56, color: Colors.grey[300]),
            const SizedBox(height: 14),
            Text(
              "No projects found",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Try a different search term or filter.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey[400]),
            ),
          ],
        ),
      ),
    );
  }

  void _showProjectDetails(Map<String, dynamic> project) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                Text(project['title'],
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text("by ${project['owner']}",
                    style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                const SizedBox(height: 16),
                Text(project['description'],
                    style: const TextStyle(fontSize: 14.5, height: 1.5)),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (project['tech'] as List)
                      .map((t) => Chip(label: Text(t.toString())))
                      .toList(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text("Request to Join",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}