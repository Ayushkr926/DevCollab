import 'package:flutter/foundation.dart';
import '../core/constants/moods.dart';
import '../data/models/memoji_model.dart';
import '../data/repositories/memoji_repository.dart';

enum LoadStatus { initial, loading, loaded, error }

/// Single source of truth for the Explore experience: data loading,
/// search, filters, favorites, and recents. Kept as one ChangeNotifier
/// so widgets only rebuild the small pieces they `select`/`watch`.
class MemojiState extends ChangeNotifier {
  final MemojiRepository _repository;

  MemojiState({MemojiRepository? repository})
      : _repository = repository ?? const MemojiRepository();

  LoadStatus status = LoadStatus.initial;
  List<Memoji> _all = [];

  // Filters
  String searchQuery = '';
  String selectedMood = Moods.all;
  String? selectedGender; // null = any
  String? selectedSkinTone; // null = any

  final Set<String> _favoriteIds = {};
  final List<String> _recentIds = []; // most recent first

  List<Memoji> get all => _all;

  Future<void> loadData() async {
    if (status == LoadStatus.loading) return;
    status = LoadStatus.loading;
    notifyListeners();
    try {
      _all = await _repository.loadAll();
      status = LoadStatus.loaded;
    } catch (_) {
      status = LoadStatus.error;
    }
    notifyListeners();
  }

  // ---------------- Filtering ----------------

  bool get hasActiveFilters =>
      searchQuery.trim().isNotEmpty ||
      selectedMood != Moods.all ||
      selectedGender != null ||
      selectedSkinTone != null;

  List<Memoji> get filtered {
    final q = searchQuery.trim().toLowerCase();
    return _all.where((m) {
      if (selectedMood != Moods.all && m.mood != selectedMood) return false;
      if (selectedGender != null && m.gender != selectedGender) return false;
      if (selectedSkinTone != null && m.skinTone != selectedSkinTone) {
        return false;
      }
      if (q.isNotEmpty && !m.person.toLowerCase().contains(q)) return false;
      return true;
    }).toList(growable: false);
  }

  /// Groups memojis by mood, in the canonical mood order, for the
  /// sectioned home layout. Only used when no active filters/search.
  Map<String, List<Memoji>> get moodSections {
    final Map<String, List<Memoji>> map = {
      for (final mood in Moods.dataMoods) mood: <Memoji>[],
    };
    for (final m in _all) {
      map[m.mood]?.add(m);
    }
    map.removeWhere((key, value) => value.isEmpty);
    return map;
  }

  void setSearchQuery(String value) {
    searchQuery = value;
    notifyListeners();
  }

  void setMoodFilter(String mood) {
    selectedMood = mood;
    notifyListeners();
  }

  void setGenderFilter(String? gender) {
    selectedGender = gender;
    notifyListeners();
  }

  void setSkinToneFilter(String? tone) {
    selectedSkinTone = tone;
    notifyListeners();
  }

  void clearFilters() {
    searchQuery = '';
    selectedMood = Moods.all;
    selectedGender = null;
    selectedSkinTone = null;
    notifyListeners();
  }

  // ---------------- Favorites ----------------

  bool isFavorite(String id) => _favoriteIds.contains(id);

  void toggleFavorite(String id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();
  }

  List<Memoji> get favorites =>
      _all.where((m) => _favoriteIds.contains(m.id)).toList(growable: false);

  // ---------------- Recents ----------------

  void addRecent(String id) {
    _recentIds.remove(id);
    _recentIds.insert(0, id);
    if (_recentIds.length > 60) _recentIds.removeLast();
    notifyListeners();
  }

  List<Memoji> get recents {
    final byId = {for (final m in _all) m.id: m};
    return _recentIds
        .map((id) => byId[id])
        .whereType<Memoji>()
        .toList(growable: false);
  }
}
