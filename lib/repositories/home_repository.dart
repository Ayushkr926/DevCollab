

import 'package:dio/dio.dart';
import '../models/hackathon.dart';
import '../models/showcase_post.dart';
import '../services/auth_service.dart';
import '../utils/Appconstants.dart';
/// All network calls for the Home screen.
/// The Provider talks to this; this talks to the API.
/// Nothing in the UI layer touches Dio directly.
class HomeRepository {
  HomeRepository() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        // connectTimeout: AppConstants.connectTimeout,
        // receiveTimeout: AppConstants.receiveTimeout,
        contentType: 'application/json',
      ),
    );
    // Request interceptor — attaches JWT automatically
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final headers = await AuthService.getAuthHeader();
          options.headers.addAll(headers);
          handler.next(options);
        },
        onError: (error, handler) {
          // 401 → token expired → force logout handled by provider
          handler.next(error);
        },
      ),
    );
  }

  late final Dio _dio;

  /// Fetch logged-in user's name, avatar, notification count.
  Future<HomeUser> fetchCurrentUser() async {
    final response = await _dio.get('/api/auth/me');
    return HomeUser.fromJson(response.data['user'] as Map<String, dynamic>);
  }

  /// Fetch paginated showcase posts for the masonry grid.
  /// [filter] — 'all' | 'ui-ux' | 'flutter' | 'ai-ml' | 'web' | 'backend'
  /// [page]   — 1-indexed page number
  Future<List<ShowcasePost>> fetchShowcasePosts({
    String filter = 'all',
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _dio.get(
      '/api/showcase',
      queryParameters: {
        'filter': filter,
        'page': page,
        'limit': limit,
      },
    );
    final list = response.data['posts'] as List;
    return list
        .map((e) => ShowcasePost.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetch developer stories (horizontal scroll row).
  Future<List<DeveloperStory>> fetchDeveloperStories() async {
    final response = await _dio.get('/api/users/stories');
    final list = response.data['stories'] as List;
    return list
        .map((e) => DeveloperStory.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Fetch active hackathons that match the user's skills.
  Future<List<Hackathon>> fetchHackathons() async {
    final response = await _dio.get(
      '/api/hackathons',
      queryParameters: {'status': 'open', 'limit': 3},
    );
    final list = response.data['hackathons'] as List;
    return list
        .map((e) => Hackathon.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Toggle like on a showcase post.
  Future<bool> toggleLike(String postId) async {
    final response = await _dio.post('/api/showcase/$postId/like');
    return response.data['liked'] as bool;
  }

  /// Search posts by query.
  Future<List<ShowcasePost>> searchPosts(String query) async {
    final response = await _dio.get(
      '/api/showcase/search',
      queryParameters: {'q': query},
    );
    final list = response.data['posts'] as List;
    return list
        .map((e) => ShowcasePost.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}