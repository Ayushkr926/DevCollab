import 'package:devcollab/utils/Appconstants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterProvider extends ChangeNotifier {
  // ── Skills ────────────────────────────
  final List<String> _allSkills = [
    'Flutter', 'Node.js', 'React', 'Vue.js',
    'MongoDB', 'Python', 'Swift', 'Kotlin',
    'Figma', 'Firebase', 'Docker', 'AWS',
    'ML/AI', 'GraphQL', 'Go',
  ];

  List<String> _selectedSkills = [];
  List<String> get allSkills => _allSkills;
  List<String> get selectedSkills => _selectedSkills;

  // ── Experience ────────────────────────
  String _experience = 'Junior';
  String get experience => _experience;
  final List<String> experienceLevels = ['Student', 'Junior', 'Mid', 'Senior', 'Lead'];

  // ── Open To ───────────────────────────
  List<String> _openTo = ['Hackathons', 'Freelance'];
  List<String> get openTo => _openTo;
  final List<String> openToOptions = ['Hackathons', 'Freelance', 'Full-time', 'Open source'];

  // ── Availability ──────────────────────
  String _availability = 'Available';
  String get availability => _availability;
  final List<String> availabilityOptions = ['Available', 'Part-time', 'Busy'];

  static const Color purple = Color(0xFF6C63FF);

  // ── UI State ──────────────────────────
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool get canContinue => _selectedSkills.isNotEmpty;

  // ── Methods ───────────────────────────

  void toggleSkill(String skill) {
    if (_selectedSkills.contains(skill)) {
      _selectedSkills.remove(skill);
    } else {
      _selectedSkills.add(skill);
    }
    notifyListeners();
  }

  void selectExperience(String level) {
    _experience = level;
    notifyListeners();
  }

  void toggleOpenTo(String option) {
    if (_openTo.contains(option)) {
      _openTo.remove(option);
    } else {
      _openTo.add(option);
    }
    notifyListeners();
  }

  void selectAvailability(String value) {
    _availability = value;
    notifyListeners();
  }

  void addNewSkill(String skill) {
    final trimmed = skill.trim();
    if (trimmed.isEmpty) return;

    if (!_allSkills.contains(trimmed)) {
      _allSkills.add(trimmed);
    }
    if (!_selectedSkills.contains(trimmed)) {
      _selectedSkills.add(trimmed);
    }
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ====================== REGISTER API CALL ======================

  Future<bool> register() async {
    clearError();
    _isLoading = true;
    notifyListeners();

    debugPrint("========== REGISTER START ==========");

    try {
      // final api = ApiService();

      final dio = Dio();
      final String? token = await AuthService.getToken();

      if (token == null) {
        _errorMessage = "Please login again";
        return false;
      }

      final requestData = {
        'skills': _selectedSkills,
        'experience': _experience,
        'availability': _availability,
        // Add other fields if needed (name, email, etc.)
      };

      debugPrint("Request Body: $requestData");

      final response = await dio.put(
        '${AppConstants.baseUrl}/api/auth/profile',
        data: requestData,
        options: Options(
          headers: {'Content-Type': 'application/json','Authorization': 'Bearer $token'},
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
        ),
      );

      debugPrint("✅ Registration Successful");
      debugPrint("Response: $response");
      final data = response.data as Map<String, dynamic>;
      if (data['message'] == 'Profile updated successfully') {
        debugPrint("Data saved successfully");
        return true;
      } else {
        _errorMessage = data['message'] ?? 'Registration failed';
        return false;
      }
    } on DioException catch (e) {
      debugPrint("❌ DIO EXCEPTION");
      debugPrint("Type: ${e.type}");
      debugPrint("Message: ${e.message}");

      final statusCode = e.response?.statusCode;
      final message = e.response?.data?['message'] ?? e.response?.data?['error'];

      if (statusCode == 401) {
        _errorMessage = 'Session expired. Please login again.';
      } else if (statusCode == 403) {
        _errorMessage = 'Access denied. Please verify your email.';
      } else if (statusCode == 429) {
        _errorMessage = 'Too many attempts. Please try again later.';
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        _errorMessage = 'Connection timeout. Please check your internet.';
      } else if (e.type == DioExceptionType.connectionError) {
        _errorMessage = 'No internet connection.';
      } else {
        _errorMessage = message ?? 'Something went wrong. Please try again.';
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
      debugPrint("========== REGISTER END ==========");
    }
  }
}