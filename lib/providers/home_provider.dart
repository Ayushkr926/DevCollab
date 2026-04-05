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
  List<ShowcasePost> _posts = [];
  List<DeveloperStory> _stories = [];
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
  List<ShowcasePost> get posts => _isSearching ? _searchResults : _posts;
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
    _errorMessage = null;
    notifyListeners();

    try {
      // Fire all 4 requests concurrently
      final results = await Future.wait([
        _repo.fetchCurrentUser(),
        _repo.fetchShowcasePosts(filter: _activeFilter, page: 1),
        _repo.fetchDeveloperStories(),
        _repo.fetchHackathons(),
      ]);

      _user = results[0] as HomeUser;
      _posts = results[1] as List<ShowcasePost>;
      _stories = results[2] as List<DeveloperStory>;
      _hackathons = results[3] as List<Hackathon>;
      _currentPage = 1;
      _postsStatus = _posts.length < 10
          ? PostsStatus.noMore
          : PostsStatus.loaded;
      _status = HomeStatus.loaded;

      _startCountdownTimer();
    } catch (e) {
      _status = HomeStatus.error;
      _errorMessage = _friendlyError(e);
    }

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