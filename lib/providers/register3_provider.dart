import 'dart:io';
import 'package:dio/dio.dart' show Dio, Options, DioExceptionType, DioException;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/Auth_service.dart';
import '../utils/Appconstants.dart';

class RegisterStep3Provider extends ChangeNotifier {
  final ImagePicker _picker = ImagePicker();

  // ── State ─────────────────────────────
  File? _avatarFile;
  File? get avatarFile => _avatarFile;

  final TextEditingController bioController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController githubController = TextEditingController();
  final TextEditingController linkinController = TextEditingController();
  final TextEditingController leetcodeController = TextEditingController();

  bool _githubVerified = false;
  bool get githubVerified => _githubVerified;

  bool _cityValid = false;
  bool get cityValid => _cityValid;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  RegisterStep3Provider() {
    _initListeners();
  }

  void _initListeners() {
    githubController.addListener(_onGithubChanged);
    cityController.addListener(_onCityChanged);
  }

  void _onGithubChanged() {
    final v = githubController.text.trim();
    final newValue = v.length >= 3;
    if (newValue != _githubVerified) {
      _githubVerified = newValue;
      notifyListeners();
    }
  }

  void _onCityChanged() {
    final newValue = cityController.text.trim().length > 2;
    if (newValue != _cityValid) {
      _cityValid = newValue;
      notifyListeners();
    }
  }

  // ── Image Picker ──────────────────────
  Future<void> pickImage(ImageSource source, {required BuildContext context}) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 400,
      );

      if (picked != null) {
        _avatarFile = File(picked.path);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = "Failed to pick image";
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
  Future<bool> submitProfile() async {
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
        "bio": bioController.text,
        "city": cityController.text,
        "socialLinks": {
          "github": githubController.text,
          "leetcode":leetcodeController.text,
          "linkedin":linkinController.text,
        }
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

  @override
  void dispose() {
    bioController.dispose();
    cityController.dispose();
    githubController.dispose();
    super.dispose();
  }
}