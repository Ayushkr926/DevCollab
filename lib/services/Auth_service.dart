import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Handles all JWT storage, retrieval, and validation.
/// Used by SplashScreen and all authenticated screens.
class AuthService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  static const _keyToken = 'devcollab_jwt';
  static const _keyUser = 'devcollab_user';

  // ── Save token after login / register / verify ───────────────────────────
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  // ── Save user JSON after login ────────────────────────────────────────────
  static Future<void> saveUser(Map<String, dynamic> user) async {
    await _storage.write(key: _keyUser, value: jsonEncode(user));
  }

  // ── Read token ────────────────────────────────────────────────────────────
  static Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  // ── Read saved user ───────────────────────────────────────────────────────
  static Future<Map<String, dynamic>?> getUser() async {
    final raw = await _storage.read(key: _keyUser);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  // ── Check if logged in (token exists + not expired) ───────────────────────
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    if (token == null || token.isEmpty) return false;
    return _isTokenValid(token);
  }

  // ── Logout — clear all stored data ───────────────────────────────────────
  static Future<void> logout() async {
    await _storage.deleteAll();
  }

  // ── JWT expiry check (no network call) ───────────────────────────────────
  static bool _isTokenValid(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return false;

      String payload = parts[1];
      // Pad base64 string
      switch (payload.length % 4) {
        case 2:
          payload += '==';
          break;
        case 3:
          payload += '=';
          break;
      }

      final decoded = utf8.decode(
        base64Decode(payload.replaceAll('-', '+').replaceAll('_', '/')),
      );

      final data = jsonDecode(decoded) as Map<String, dynamic>;
      final exp = data['exp'] as int?;
      if (exp == null) return true;

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      // Add 30 second buffer so we don't use an almost-expired token
      return exp > (now + 30);
    } catch (_) {
      return false;
    }
  }

  // ── Get auth header for API calls ─────────────────────────────────────────
  static Future<Map<String, String>> getAuthHeader() async {
    final token = await getToken();
    if (token == null) return {};
    return {'Authorization': 'Bearer $token'};
  }
}