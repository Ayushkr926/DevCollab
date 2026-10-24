import 'package:devcollab/services/Auth_service.dart';
import 'package:devcollab/utils/Appconstants.dart';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/Reqest_model.dart';

enum RequestFilter { all, unread, pending, accepted, rejected }

enum RequestSort { newest, oldest }

class RequestProvider with ChangeNotifier {
  // Separate lists for better UX
  List<RequestModel> _receivedRequests = [];
  List<RequestModel> _sentRequests = [];

  bool _isLoading = false;
  bool _isRefreshing = false;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;

  int _currentTab = 0; // 0 = Received, 1 = Sent
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalRequests = 0;
  int _totalUnreadRequests = 0;

  String _searchQuery = '';
  RequestFilter _filter = RequestFilter.all;
  RequestSort _sort = RequestSort.newest;

  String? _errorMessage;

  // ---- Existing getters (unchanged) ----
  List<RequestModel> get receivedRequests => _receivedRequests;
  List<RequestModel> get sentRequests => _sentRequests;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMoreData => _hasMoreData;
  int get currentTab => _currentTab;
  String? get errorMessage => _errorMessage;
  int get totalUnreadRequests => _totalUnreadRequests;

  // ---- New additive getters for the redesigned UI ----
  String get searchQuery => _searchQuery;
  RequestFilter get filter => _filter;
  RequestSort get sort => _sort;

  int get pendingCount => _receivedRequests
      .where((r) => (r.status).toLowerCase() == 'pending')
      .length;

  int get acceptedTodayCount {
    final now = DateTime.now();
    return _receivedRequests.where((r) {
      if (r.status.toLowerCase() != 'accepted' || r.respondedAt == null) {
        return false;
      }
      final d = r.respondedAt!;
      return d.year == now.year && d.month == now.month && d.day == now.day;
    }).length;
  }

  /// Received requests after search + filter + sort are applied.
  List<RequestModel> get filteredReceivedRequests {
    Iterable<RequestModel> list = _receivedRequests;

    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      list = list.where((r) =>
      r.requesterName.toLowerCase().contains(q) ||
          r.recipientHeadline.toLowerCase().contains(q));
    }

    switch (_filter) {
      case RequestFilter.pending:
        list = list.where((r) => r.status.toLowerCase() == 'pending');
        break;
      case RequestFilter.accepted:
        list = list.where((r) => r.status.toLowerCase() == 'accepted');
        break;
      case RequestFilter.rejected:
        list = list.where((r) => r.status.toLowerCase() == 'rejected');
        break;
      case RequestFilter.all:
        break;
      case RequestFilter.unread:
        // TODO: Handle this case.
        throw UnimplementedError();
    }

    final result = list.toList();
    result.sort((a, b) => _sort == RequestSort.newest
        ? b.createdAt.compareTo(a.createdAt)
        : a.createdAt.compareTo(b.createdAt));
    return result;
  }

  RequestProvider() {
    _loadInitialData();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setFilter(RequestFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  void setSort(RequestSort sort) {
    _sort = sort;
    notifyListeners();
  }
  Future<void> _loadInitialData() async {
    clearError();

    _isLoading = true;
    notifyListeners();

    try {
      // ===========================
      // Get Authentication Token
      // ===========================
      final String? token = await AuthService.getToken();

      if (kDebugMode) {
        debugPrint("========== CONNECTION REQUEST API ==========");
        debugPrint("Token: $token");
      }

      if (token == null || token.isEmpty) {
        throw Exception("Authentication token not found. Please login again.");
      }

      final dio = Dio();

      final url = "${AppConstants.baseUrl}/api/social/connections/requests";

      if (kDebugMode) {
        debugPrint("Request URL: $url");
        debugPrint("Headers:");
        debugPrint("Content-Type: application/json");
        debugPrint("Authorization: Bearer $token");
      }

      // ===========================
      // API Request
      // ===========================
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          sendTimeout: const Duration(seconds: 10),
        ),
      );

      if (kDebugMode) {
        debugPrint("Status Code: ${response.statusCode}");
        debugPrint("Response:");
        debugPrint(response.data.toString());
      }

      if (response.statusCode != 200) {
        throw Exception("Failed to load requests.");
      }

      final Map<String, dynamic> json = response.data;

      if (kDebugMode) {
        debugPrint("Parsed JSON:");
        debugPrint(json.toString());
      }

      // ===========================
      // Received Requests
      // ===========================
      final List<dynamic> requestJson =
          json["requests"] as List<dynamic>? ?? [];

      if (kDebugMode) {
        debugPrint("Received Requests Count: ${requestJson.length}");
      }

      _receivedRequests = requestJson
          .map((e) => RequestModel.fromJson(e as Map<String, dynamic>))
          .toList();

      // ===========================
      // Sent Requests
      // ===========================
      final List<dynamic> sentJson =
          json["sentRequests"] as List<dynamic>? ?? [];

      if (kDebugMode) {
        debugPrint("Sent Requests Count: ${sentJson.length}");
      }

      _sentRequests = sentJson
          .map((e) => RequestModel.fromJson(e as Map<String, dynamic>))
          .toList();

      // ===========================
      // Statistics
      // ===========================
      _totalRequests = _receivedRequests.length + _sentRequests.length;


      if (kDebugMode) {
        debugPrint("Total Received: ${_receivedRequests.length}");
        debugPrint("Total Sent: ${_sentRequests.length}");
        debugPrint("Total Requests: $_totalRequests");
        debugPrint("Unread Requests: $_totalUnreadRequests");
        debugPrint("========== API COMPLETED SUCCESSFULLY ==========");
      }

      clearError();
    } on DioException catch (e) {
      if (kDebugMode) {
        debugPrint("========== DIO ERROR ==========");
        debugPrint("Type: ${e.type}");
        debugPrint("Message: ${e.message}");
        debugPrint("Status Code: ${e.response?.statusCode}");
        debugPrint("Response: ${e.response?.data}");
        debugPrint("Request URL: ${e.requestOptions.uri}");
        debugPrint("Headers: ${e.requestOptions.headers}");
        debugPrint("================================");
      }

      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          _errorMessage = "Connection timed out. Please try again.";
          break;

        case DioExceptionType.badResponse:
          _errorMessage =
              e.response?.data["message"]?.toString() ??
                  "Server error occurred.";
          break;

        case DioExceptionType.connectionError:
          _errorMessage = "No internet connection.";
          break;

        default:
          _errorMessage = "Something went wrong.";
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint("========== GENERAL ERROR ==========");
        debugPrint("Error: $e");
        debugPrintStack(stackTrace: stackTrace);
        debugPrint("===================================");
      }

      _errorMessage = e.toString();
    } finally {
      _isLoading = false;

      if (kDebugMode) {
        debugPrint("Loading Finished: $_isLoading");
      }

      notifyListeners();
    }
  }

  void switchTab(int tab) {
    if (_currentTab == tab) return;
    _currentTab = tab;
    notifyListeners();
  }

  Future<void> refresh() async {
    _isRefreshing = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 1200));

    // In real app: refetch from API
    await _loadInitialData();

    _isRefreshing = false;
    notifyListeners();
  }

  Future<void> loadMoreRequests() async {
    if (_isLoadingMore || !_hasMoreData) return;

    _isLoadingMore = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    // Simulate loading more (demo: stop after first load)
    _hasMoreData = false;

    _isLoadingMore = false;
    notifyListeners();
  }

  // Accept Request
  Future<void> acceptRequest(String requestId) async {
    final index = _receivedRequests.indexWhere((req) => req.id == requestId);

    if (index == -1) return;

    try {
      // final response = await _requestService.acceptRequest(requestId);

      _receivedRequests[index] = _receivedRequests[index].copyWith(
        status: "Accepted",
        respondedAt: DateTime.now(),
      );


      notifyListeners();
    } catch (e) {
      debugPrint("Accept request failed: $e");
      rethrow;
    }
  }

  // Reject Request
  Future<void> rejectRequest(String requestId) async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    _receivedRequests.removeWhere((req) => req.id == requestId);
    // _totalUnreadRequests = _receivedRequests.where((r) => r.isUnread).length;

    notifyListeners();
  }

  // Optional: Cancel Sent Request
  Future<void> cancelSentRequest(String requestId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    _sentRequests.removeWhere((req) => req.id == requestId);
    notifyListeners();
  }

  void markAsRead(String requestId) {
    final index = _receivedRequests.indexWhere((r) => r.id == requestId);


  }
}

// Extension for safety
extension ListExtension<T> on List<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}