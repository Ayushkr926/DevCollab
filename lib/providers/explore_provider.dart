import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/Auth_service.dart';
import '../utils/Appconstants.dart';

class ExploreProvider with ChangeNotifier {
  List<UserModel> _allUsers = [];
  List<UserModel> _filteredUsers = [];

  String _searchQuery = '';
  String _activeFilter = 'All';

  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  int _currentPage = 1;
  final int _limit = 20; // Users per page

  bool _showserach = false;

  String? _errorMessage;

  // Getters
  List<UserModel> get filteredUsers => _filteredUsers;
  List<UserModel> get allusers => _allUsers;
  String get searchQuery => _searchQuery;
  String get activeFilter => _activeFilter;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMoreData => _hasMoreData;
  String? get errorMessage => _errorMessage;
  bool get showsearch => _showserach;

  ExploreProvider() {
    _fetchUsers(reset: true);
  }

  Future<void> searchclick() async{
    _showserach = !_showserach;
    notifyListeners();
  }

  Future<void> _fetchUsers({bool reset = false}) async {
    if (reset) {
      _currentPage = 1;
      _allUsers.clear();
      _hasMoreData = true;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    debugPrint("========== FETCH USERS PAGE $_currentPage START ==========");

    try {
      final dio = Dio();
      final String? token = await AuthService.getToken();

      if (token == null) {
        _errorMessage = "Please login again";
        return;
      }

      final response = await dio.get(
        '${AppConstants.baseUrl}/api/social/users',
        queryParameters: {
          'page': _currentPage,
          'limit': _limit,
          // Add other filters if your backend supports:
          // 'search': _searchQuery,
          // 'role': _activeFilter != 'All' ? _activeFilter : null,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
          receiveTimeout: const Duration(seconds: 12),
          sendTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final List<dynamic> usersJson = data['users'] ?? [];

        final newUsers = usersJson
            .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
            .toList();

        if (reset) {
          _allUsers = newUsers;
        } else {
          _allUsers.addAll(newUsers);
        }
        _allUsers.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        _hasMoreData = newUsers.length == _limit; // If less than limit, no more data

        _applyFilters();

        debugPrint("Fetched ${newUsers.length} users | Total: ${_allUsers.length}");
      } else {
        _errorMessage = "Failed to fetch users";
      }
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      _errorMessage = "An unexpected error occurred";
      debugPrint("Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
      debugPrint("========== FETCH USERS END ==========");
    }
  }


  Future<bool> sendConnection({required String userId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    debugPrint("========== SEND CONNECTION TO USER ID: $userId ==========");

    try {
      final dio = Dio();
      final String? token = await AuthService.getToken();

      if (token == null) {
        _errorMessage = "Please login again";
        return false;
      }

      final response = await dio.post(
        '${AppConstants.baseUrl}/api/social/connections/request',
        data: {
          "recipientId": userId,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
          receiveTimeout: const Duration(seconds: 12),
          sendTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Connection request sent successfully");
        debugPrint("Response: ${response.data}");
        final index = _allUsers.indexWhere((e) => e.id == userId);

        if (index != -1) {
          _allUsers[index].connectionStatus = "pending";
          notifyListeners();
        }

        return true;
      } else {
        _errorMessage = response.data["message"] ?? "Failed to send connection request";
        return false;
      }
    } on DioException catch (e) {
      _handleDioError(e);
      return false;
    } catch (e) {
      _errorMessage = "An unexpected error occurred";
      debugPrint("Error: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
      debugPrint("========== SEND CONNECTION END ==========");
    }
  }

  void _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;

    if (statusCode == 401) {
      _errorMessage = "Session expired. Please login again.";
    } else if (statusCode == 403) {
      _errorMessage = "Access denied.";
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      _errorMessage = "Connection timeout. Please try again.";
    } else if (e.type == DioExceptionType.connectionError) {
      _errorMessage = "No internet connection.";
    } else {
      _errorMessage = e.response?.data?['message'] ?? "Something went wrong.";
    }
  }

  // ====================== Public Methods ======================

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

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      temp = temp.where((user) =>
      user.name.toLowerCase().contains(q) ||
          user.role.toLowerCase().contains(q) ||
          user.location.toLowerCase().contains(q)).toList();
    }

    if (_activeFilter != 'All') {
      final filterLower = _activeFilter.toLowerCase();
      temp = temp.where((user) =>
      user.role.toLowerCase().contains(filterLower) ||
          user.skills.any((skill) =>
              skill.toLowerCase().contains(filterLower))).toList();
    }

    _filteredUsers = temp;
    notifyListeners();
  }

  Future<void> refresh() async {
    await _fetchUsers(reset: true);
  }

  Future<void> loadMoreUsers() async {
    if (_isLoadingMore || !_hasMoreData || _isLoading) return;

    _isLoadingMore = true;
    notifyListeners();

    _currentPage++;
    await _fetchUsers(reset: false);

    _isLoadingMore = false;
    notifyListeners();
  }

  void reset() {
    _searchQuery = '';
    _activeFilter = 'All';
    _fetchUsers(reset: true); // Full refresh
  }

  void clearAll() {
    _allUsers.clear();
    _filteredUsers.clear();
    _searchQuery = '';
    _activeFilter = 'All';
    _currentPage = 1;
    _hasMoreData = true;
    _errorMessage = null;
    notifyListeners();
  }
}