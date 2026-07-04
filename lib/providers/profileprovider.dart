import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/memoji_model.dart';
import '../services/Auth_service.dart';
import '../utils/Appconstants.dart';

class ProfileProvider extends ChangeNotifier {
  // Profile Data
  String _name = "Unknown";
  String _bio = "";
  String _role = "";
  String _location = "";
  String _profileImage = "";
  String _bannerimage = "";
  List<String> _skills = [];
  int _projects = 0;
  int _collabs = 0;
  int _views = 0;

  // State
  bool _isLoading = false;
  bool _isOffline = false;
  String _errorMessage = "";

  // Cache settings
  static const String _cacheKey = 'user_profile_cache';
  static const Duration _cacheExpiry = Duration(minutes: 30);

  // Getters
  String get name => _name;
  String get bio => _bio;
  String get role => _role;
  String get location => _location;
  String get profileImage => _profileImage;
  String get bannerimage => _bannerimage;
  List<String> get skills => List.unmodifiable(_skills);
  int get projects => _projects;
  int get collabs => _collabs;
  int get views => _views;

  bool get isLoading => _isLoading;
  bool get isOffline => _isOffline;
  String get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }


  Memoji? selectedMemoji;

  void setMemoji(Memoji memoji) {
    selectedMemoji = memoji;
    notifyListeners();
  }

  void setProfileImage(String url) {
    _profileImage = url;
    notifyListeners();
  }


  // Load cached profile
  Future<void> _loadFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_cacheKey);

      if (cachedData == null) return;

      final Map<String, dynamic> data = jsonDecode(cachedData);
      final cacheTime = DateTime.parse(data['cacheTime']);

      // Check if cache is expired
      if (DateTime.now().difference(cacheTime) > _cacheExpiry) {
        await prefs.remove(_cacheKey);
        return;
      }

      _name = data['name'] ?? _name;
      _bio = data['bio'] ?? _bio;
      _role = data['role'] ?? _role;
      _location = data['location'] ?? _location;
      _profileImage = data['profileImage'] ?? _profileImage;
      _skills = List<String>.from(data['skills'] ?? []);
      _projects = data['projects'] ?? _projects;
      _collabs = data['collabs'] ?? _collabs;
      _views = data['views'] ?? _views;

      _isOffline = true;
      notifyListeners();
    } catch (e) {
      debugPrint("Cache load error: $e");
    }
  }

  // Save profile to cache
  Future<void> _saveToCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cacheData = {
        'name': _name,
        'bio': _bio,
        'role': _role,
        'location': _location,
        'profileImage': _profileImage,
        'skills': _skills,
        'projects': _projects,
        'collabs': _collabs,
        'views': _views,
        'cacheTime': DateTime.now().toIso8601String(),
      };

      await prefs.setString(_cacheKey, jsonEncode(cacheData));
    } catch (e) {
      debugPrint("Cache save error: $e");
    }
  }

  // Clear cache (useful on logout)
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
  }

  /// Fetch Profile with Cache-First Strategy
  Future<bool> fetchProfile({bool forceRefresh = false}) async {
    clearError();
    _isLoading = true;
    _isOffline = false;
    notifyListeners();

    debugPrint("========== FETCH PROFILE START ==========");

    try {
      // Try cache first if not forcing refresh
      if (!forceRefresh) {
        await _loadFromCache();
      }

      final dio = Dio();
      final String? token = await AuthService.getToken();

      if (token == null) {
        _errorMessage = "Please login again";
        return false;
      }

      final response = await dio.get(
        '${AppConstants.baseUrl}/api/auth/me',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          connectTimeout: const Duration(seconds: 12),
          receiveTimeout: const Duration(seconds: 12),
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        // Update state
        _name = data['name'] ?? _name;
        _bio = data['bio'] ?? _bio;
        _role = data['role'] ?? _role;
        _location = data['city'] ?? data['location'] ?? _location;
        _profileImage = data['profileImage'] ?? _profileImage;
        _skills = List<String>.from(data['skills'] ?? []);
        _projects = data['projects'] ?? _projects;
        _collabs = data['collabs'] ?? _collabs;
        _views = data['views'] ?? _views;

        await _saveToCache();
        _isOffline = false;

        debugPrint("✅ Profile fetched & cached successfully");
        return true;
      } else {
        _errorMessage = 'Failed to fetch profile';
        return false;
      }
    } on DioException catch (e) {
      _handleDioError(e);
      if (_name != "Unknown") {
        _isOffline = true;
      }
      return false;
    } catch (e, stackTrace) {
      debugPrint("❌ UNKNOWN ERROR: $e");
      debugPrint("StackTrace: $stackTrace");
      _errorMessage = 'An unexpected error occurred.';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final message = e.response?.data?['message'] ?? e.response?.data?['error'];

    if (statusCode == 401) {
      _errorMessage = 'Session expired. Please login again.';
    } else if (statusCode == 403) {
      _errorMessage = 'Access denied.';
    } else if (statusCode == 429) {
      _errorMessage = 'Too many requests. Please try again later.';
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
      _errorMessage = 'No internet connection. Showing cached data if available.';
    } else {
      _errorMessage = message ?? 'Something went wrong.';
    }
  }

  // Local update (for editing before saving to server)
  void updateProfile({
    String? newName,
    String? newRole,
    String? newLocation,
    String? newBio,
    String? newProfileImage,
    List<String>? newSkills,
  }) {
    if (newName != null) _name = newName;
    if (newRole != null) _role = newRole;
    if (newLocation != null) _location = newLocation;
    if (newBio != null) _bio = newBio;
    if (newProfileImage != null) _profileImage = newProfileImage;
    if (newSkills != null) _skills = newSkills;

    notifyListeners();
  }

  Future<void> refreshProfile() async {
    await fetchProfile(forceRefresh: true);
  }

  // Call this on logout
  Future<void> logout() async {
    await clearCache();
    // Reset values
    _name = "Unknown";
    _bio = "";
    _role = "";
    _location = "";
    _profileImage = "";
    _skills = [];
    _projects = 0;
    _collabs = 0;
    _views = 0;
    notifyListeners();
  }

  void setBannerImage(String imageUrl) {
    _bannerimage = imageUrl;
    notifyListeners();
  }
}