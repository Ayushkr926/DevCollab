import 'package:flutter/material.dart';
import '../models/Hackathinmodel.dart';

class HackathonProvider with ChangeNotifier {
  List<Hackathon> _hackathons = [];
  List<Hackathon> _filteredHackathons = [];

  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _isRefreshing = false;
  bool _hasMoreData = true;

  String _searchQuery = '';
  String _selectedFilter = 'All';     // All, Upcoming, Ongoing, Past
  String _selectedMode = 'All';       // All, Online, Offline

  // Getters
  List<Hackathon> get hackathons => _filteredHackathons;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get isRefreshing => _isRefreshing;
  String get searchQuery => _searchQuery;
  String get selectedFilter => _selectedFilter;
  String get selectedMode => _selectedMode;

  HackathonProvider() {
    loadHackathons();
  }

  Future<void> loadHackathons() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 900));

    _hackathons = Hackathon.getDemoHackathons();
    _applyFilters();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    _isRefreshing = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1200));
    await loadHackathons();

    _isRefreshing = false;
    notifyListeners();
  }

  Future<void> loadMoreHackathons() async {
    if (_isLoadingMore || !_hasMoreData) return;

    _isLoadingMore = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    // Simulate more data
    _hasMoreData = false;
    _isLoadingMore = false;
    notifyListeners();
  }

  void onSearchChanged(String query) {
    _searchQuery = query.trim();
    _applyFilters();
  }

  void clearSearch() {
    _searchQuery = '';
    _applyFilters();
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    _applyFilters();
  }

  void setMode(String mode) {
    _selectedMode = mode;
    _applyFilters();
  }

  void _applyFilters() {
    List<Hackathon> temp = List.from(_hackathons);

    // Search
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      temp = temp.where((h) =>
      h.title.toLowerCase().contains(q) ||
          h.organizer.toLowerCase().contains(q) ||
          h.description.toLowerCase().contains(q) ||
          h.themes.any((t) => t.toLowerCase().contains(q))).toList();
    }

    // Status Filter
    if (_selectedFilter != 'All') {
      switch (_selectedFilter) {
        case 'Upcoming':
          temp = temp.where((h) => h.hackathonStart.isAfter(DateTime.now())).toList();
          break;
        case 'Ongoing':
          temp = temp.where((h) =>
          h.hackathonStart.isBefore(DateTime.now()) &&
              h.hackathonEnd.isAfter(DateTime.now())).toList();
          break;
        case 'Past':
          temp = temp.where((h) => h.hackathonEnd.isBefore(DateTime.now())).toList();
          break;
      }
    }

    // Mode Filter
    if (_selectedMode != 'All') {
      final isOnline = _selectedMode == 'Online';
      temp = temp.where((h) => h.isOnline == isOnline).toList();
    }

    _filteredHackathons = temp;
    notifyListeners();
  }

  void toggleBookmark(String id) {
    final index = _hackathons.indexWhere((h) => h.id == id);
    if (index != -1) {
      _hackathons[index] = _hackathons[index].copyWith(bookmarked: !_hackathons[index].bookmarked);
      _applyFilters();
    }
  }

  void registerForHackathon(String id) {
    final index = _hackathons.indexWhere((h) => h.id == id);
    if (index != -1) {
      // In real app, call API
      notifyListeners();
    }
  }
}