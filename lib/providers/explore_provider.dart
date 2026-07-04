import 'package:flutter/material.dart';
import '../models/user_model.dart';

class ExploreProvider with ChangeNotifier {
  List<UserModel> _allUsers = [];
  List<UserModel> _filteredUsers = [];

  String _searchQuery = '';
  String _activeFilter = 'All'; // All, Flutter, Backend, UI/UX, etc.

  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;

  // Getters
  List<UserModel> get filteredUsers => _filteredUsers;
  String get searchQuery => _searchQuery;
  String get activeFilter => _activeFilter;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;

  ExploreProvider() {
    _loadInitialUsers();
  }

  Future<void> _loadInitialUsers() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    _allUsers = UserModel.getDemoUsers();
    _applyFilters();
    _isLoading = false;
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
    _activeFilter = filter;
    _applyFilters();
  }

  void _applyFilters() {
    List<UserModel> temp = _allUsers;

    // Search filter
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      temp = temp.where((user) =>
      user.name.toLowerCase().contains(q) ||
          user.role.toLowerCase().contains(q) ||
          user.location.toLowerCase().contains(q)).toList();
    }

    // Category filter
    if (_activeFilter != 'All') {
      temp = temp.where((user) =>
      user.role.toLowerCase().contains(_activeFilter.toLowerCase()) ||
          user.skills.any((skill) => skill.toLowerCase().contains(_activeFilter.toLowerCase()))).toList();
    }

    _filteredUsers = temp;
    notifyListeners();
  }

  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1200));
    _allUsers = UserModel.getDemoUsers(); // In real app: fetch from API
    _applyFilters();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadMoreUsers() async {
    if (_isLoadingMore || !_hasMoreData) return;

    _isLoadingMore = true;
    notifyListeners();

    // Simulate loading more
    await Future.delayed(const Duration(seconds: 1));

    // For demo, we'll just stop after first load
    _hasMoreData = false;

    _isLoadingMore = false;
    notifyListeners();
  }

  // Reset everything
  void reset() {
    _searchQuery = '';
    _activeFilter = 'All';
    _applyFilters();
  }
}