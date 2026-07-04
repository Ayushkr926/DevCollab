// lib/providers/home_provider.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/hackathon.dart';
import '../models/showcase_post.dart';
import '../repositories/home_repository.dart';

enum HomeStatus { initial, loading, loaded, error }

enum PostsStatus { initial, loading, loaded, loadingMore, noMore, error }

class HomeProvider extends ChangeNotifier {
  HomeProvider({HomeRepository? repository})
      : _repo = repository ?? HomeRepository();

  final HomeRepository _repo;

  // ── State ─────────────────────────────────────────────────────────────────
  HomeStatus _status = HomeStatus.initial;
  PostsStatus _postsStatus = PostsStatus.initial;

  HomeUser? _user;
  final List<ShowcasePost> demoPosts = [
    ShowcasePost(
      id: "1",
      title: "UnJob AI Mobile App",
      imageUrl:
      "https://images.unsplash.com/photo-1551650975-87deedd944c3",
      techStack: "Flutter • Firebase",
      authorId: "u1",
      authorName: "Ayush Kumar",
      authorInitials: "AK",
      authorColorIndex: 0,
      likes: 128,
      isLikedByMe: true,
      isTrending: true,
      timeAgo: "2h ago",
      viewCount: 1240,
    ),

    ShowcasePost(
      id: "2",
      title: "Expense Tracker Dashboard",
      imageUrl:
      "https://images.unsplash.com/photo-1460925895917-afdab827c52f",
      techStack: "Flutter • SQLite",
      authorId: "u2",
      authorName: "Rohit Sharma",
      authorInitials: "RS",
      authorColorIndex: 1,
      likes: 95,
      isLikedByMe: false,
      isTrending: false,
      timeAgo: "5h ago",
      viewCount: 820,
    ),

    ShowcasePost(
      id: "3",
      title: "Portfolio Website",
      imageUrl:
      "https://images.unsplash.com/photo-1498050108023-c5249f4df085",
      techStack: "React • Node.js",
      authorId: "u3",
      authorName: "Priya Singh",
      authorInitials: "PS",
      authorColorIndex: 2,
      likes: 210,
      isLikedByMe: true,
      isTrending: true,
      timeAgo: "1d ago",
      viewCount: 3200,
    ),

    ShowcasePost(
      id: "4",
      title: "Doctor Appointment App",
      imageUrl:
      "https://images.unsplash.com/photo-1576091160550-2173dba999ef",
      techStack: "Flutter • REST API",
      authorId: "u4",
      authorName: "Aman Verma",
      authorInitials: "AV",
      authorColorIndex: 3,
      likes: 76,
      isLikedByMe: false,
      isTrending: false,
      timeAgo: "3d ago",
      viewCount: 690,
    ),

    ShowcasePost(
      id: "5",
      title: "Movie Streaming UI",
      imageUrl:
      "https://images.unsplash.com/photo-1489599849927-2ee91cede3ba",
      techStack: "Flutter • TMDB API",
      authorId: "u5",
      authorName: "Neha Gupta",
      authorInitials: "NG",
      authorColorIndex: 4,
      likes: 185,
      isLikedByMe: true,
      isTrending: true,
      timeAgo: "6h ago",
      viewCount: 1870,
    ),

    ShowcasePost(
      id: "6",
      title: "Food Delivery App",
      imageUrl:
      "https://images.unsplash.com/photo-1504674900247-0877df9cc836",
      techStack: "Flutter • Firebase",
      authorId: "u6",
      authorName: "Karan Mehta",
      authorInitials: "KM",
      authorColorIndex: 5,
      likes: 142,
      isLikedByMe: false,
      isTrending: false,
      timeAgo: "8h ago",
      viewCount: 1150,
    ),
  ];

  late List<ShowcasePost> _posts = demoPosts;
  List<DeveloperStory> _stories = [
    const DeveloperStory(
      userId: "1",
      name: "Ayush Kumar",
      initials: "AK",
      profileImage: "https://i.pravatar.cc/150?img=1",
      storyUrl:"https://images.unsplash.com/photo-1500648767791-00dcc994a43b",
      isVideo: false,
      hasSeen: false,
      seenBorderColor: "#BDBDBD",
      unseenBorderColor: "#FF0069",
    ),
    const DeveloperStory(
      userId: "2",
      name: "Priya Sharma",
      initials: "PS",
      profileImage: "https://i.pravatar.cc/150?img=5",
      storyUrl: "https://images.unsplash.com/photo-1494790108377-be9c29b29330",
      isVideo: false,
      hasSeen: true,
      seenBorderColor: "#BDBDBD",
      unseenBorderColor: "#FF0069",
    ),
    const DeveloperStory(
      userId: "3",
      name: "Rahul Verma",
      initials: "RV",
      profileImage:
      "https://i.pravatar.cc/150?img=12",
      storyUrl:
      "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4",
      isVideo: true,
      hasSeen: false,
      seenBorderColor: "#BDBDBD",
      unseenBorderColor: "#FF0069",
    ),
    const DeveloperStory(
      userId: "4",
      name: "Ananya Singh",
      initials: "AS",
      profileImage:
      "https://i.pravatar.cc/150?img=20",
      storyUrl:
      "https://images.unsplash.com/photo-1517841905240-472988babdf9",
      isVideo: false,
      hasSeen: true,
      seenBorderColor: "#BDBDBD",
      unseenBorderColor: "#FF0069",
    ),
    const DeveloperStory(
      userId: "5",
      name: "Rohan Gupta",
      initials: "RG",
      profileImage:
      "https://i.pravatar.cc/150?img=15",
      storyUrl:
      "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d",
      isVideo: false,
      hasSeen: false,
      seenBorderColor: "#BDBDBD",
      unseenBorderColor: "#FF0069",
    ),
    const DeveloperStory(
      userId: "6",
      name: "Neha Kapoor",
      initials: "NK",
      profileImage:
      "https://i.pravatar.cc/150?img=32",
      storyUrl:
      "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4",
      isVideo: true,
      hasSeen: false,
      seenBorderColor: "#BDBDBD",
      unseenBorderColor: "#FF0069",
    ),
    const DeveloperStory(
      userId: "7",
      name: "Vikram Patel",
      initials: "VP",
      profileImage:
      "https://i.pravatar.cc/150?img=55",
      storyUrl:
      "https://images.unsplash.com/photo-1502767089025-6572583495b4",
      isVideo: false,
      hasSeen: true,
      seenBorderColor: "#BDBDBD",
      unseenBorderColor: "#FF0069",
    ),
    const DeveloperStory(
      userId: "8",
      name: "Sneha Jain",
      initials: "SJ",
      profileImage:
      "https://i.pravatar.cc/150?img=47",
      storyUrl:
      "https://images.unsplash.com/photo-1544005313-94ddf0286df2",
      isVideo: false,
      hasSeen: false,
      seenBorderColor: "#BDBDBD",
      unseenBorderColor: "#FF0069",
    ),
  ];

  List<Hackathon> _hackathons = [];

  String _activeFilter = 'all';
  int _currentPage = 1;
  String? _errorMessage;

  // Search
  bool _isSearching = false;
  String _searchQuery = '';
  List<ShowcasePost> _searchResults = [];
  Timer? _searchDebounce;

  // Countdown timer for hackathons
  Timer? _countdownTimer;

  // ── Getters ───────────────────────────────────────────────────────────────
  HomeStatus get status => _status;
  PostsStatus get postsStatus => _postsStatus;
  HomeUser? get user => _user;
  List<ShowcasePost> get posts => _posts;
  List<DeveloperStory> get stories => _stories;
  List<Hackathon> get hackathons => _hackathons;
  String get activeFilter => _activeFilter;
  String? get errorMessage => _errorMessage;
  bool get isSearching => _isSearching;
  String get searchQuery => _searchQuery;
  bool get hasMorePosts => _postsStatus != PostsStatus.noMore;

  // ── Init load ─────────────────────────────────────────────────────────────
  Future<void> loadAll() async {
    _status = HomeStatus.loading;
    notifyListeners();

    await Future.delayed(
      const Duration(milliseconds: 800),
    );

    // Demo user
    _user = HomeUser(
      id: "user_1",
      name: "Ayush Kumar",
      initials: "AK",
      colorIndex: 0,
      unreadNotifications: 5,
      unreadMessages: 2,
    );

    // Demo showcase posts
    _posts = demoPosts;

    // Empty for now
    // _stories = [];
    // _hackathons = [];

    _currentPage = 1;

    _status = HomeStatus.loaded;
    _postsStatus = PostsStatus.loaded;

    notifyListeners();
  }

  // ── Pull to refresh ───────────────────────────────────────────────────────
  Future<void> refresh() async {
    _currentPage = 1;
    _postsStatus = PostsStatus.initial;
    await loadAll();
  }

  // ── Filter change ─────────────────────────────────────────────────────────
  Future<void> setFilter(String filter) async {
    if (_activeFilter == filter) return;
    _activeFilter = filter;
    _currentPage = 1;
    _posts = [];
    _postsStatus = PostsStatus.loading;
    notifyListeners();

    try {
      _posts = await _repo.fetchShowcasePosts(
        filter: filter,
        page: 1,
      );
      _currentPage = 1;
      _postsStatus =
      _posts.length < 10 ? PostsStatus.noMore : PostsStatus.loaded;
    } catch (e) {
      _postsStatus = PostsStatus.error;
      _errorMessage = _friendlyError(e);
    }
    notifyListeners();
  }

  // ── Load more (infinite scroll) ───────────────────────────────────────────
  Future<void> loadMorePosts() async {
    if (_postsStatus == PostsStatus.loadingMore ||
        _postsStatus == PostsStatus.noMore ||
        _isSearching) return;

    _postsStatus = PostsStatus.loadingMore;
    notifyListeners();

    try {
      final newPosts = await _repo.fetchShowcasePosts(
        filter: _activeFilter,
        page: _currentPage + 1,
      );

      if (newPosts.isEmpty) {
        _postsStatus = PostsStatus.noMore;
      } else {
        _posts.addAll(newPosts);
        _currentPage++;
        _postsStatus =
        newPosts.length < 10 ? PostsStatus.noMore : PostsStatus.loaded;
      }
    } catch (e) {
      _postsStatus = PostsStatus.error;
    }
    notifyListeners();
  }

  // ── Like toggle (optimistic update) ──────────────────────────────────────
  Future<void> toggleLike(String postId) async {
    final index = _posts.indexWhere((p) => p.id == postId);
    if (index == -1) return;

    final post = _posts[index];
    // Optimistic update immediately
    _posts[index] = post.copyWith(
      isLikedByMe: !post.isLikedByMe,
      likes: post.isLikedByMe ? post.likes - 1 : post.likes + 1,
    );
    notifyListeners();

    try {
      await _repo.toggleLike(postId);
      // Server confirmed — already updated optimistically, nothing to do
    } catch (_) {
      // Rollback on failure
      _posts[index] = post;
      notifyListeners();
    }
  }

  // ── Search ────────────────────────────────────────────────────────────────
  void onSearchChanged(String query) {
    _searchQuery = query;

    if (query.trim().isEmpty) {
      _isSearching = false;
      _searchResults = [];
      _searchDebounce?.cancel();
      notifyListeners();
      return;
    }

    _isSearching = true;
    notifyListeners();

    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        _searchResults = await _repo.searchPosts(query.trim());
      } catch (_) {
        _searchResults = [];
      }
      notifyListeners();
    });
  }

  void clearSearch() {
    _isSearching = false;
    _searchQuery = '';
    _searchResults = [];
    _searchDebounce?.cancel();
    notifyListeners();
  }

  // ── Countdown timer ───────────────────────────────────────────────────────
  void _startCountdownTimer() {
    _countdownTimer?.cancel();
    if (_hackathons.isNotEmpty) {
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        notifyListeners(); // Forces rebuild of countdown widgets
      });
    }
  }

  // ── Error helper ──────────────────────────────────────────────────────────
  String _friendlyError(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('timeout')) return 'Connection timed out. Check your internet.';
    if (msg.contains('connection')) return 'Cannot reach server. Check your connection.';
    if (msg.contains('401')) return 'Session expired. Please log in again.';
    return 'Something went wrong. Pull down to retry.';
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }
}