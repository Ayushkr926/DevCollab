import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/memoji_model.dart';

/// Loads Memoji data from the bundled JSON asset.
/// Swap [assetPath] to point at your real 3,000+ entry dataset —
/// the schema (person, gender, skinTone, mood, posture, imagePath)
/// must stay the same.
class MemojiRepository {



  const MemojiRepository();
  Future<List<Memoji>> loadAll() async {
    final assetPath = 'assets/data/male_memoji.json';
    try {
      final manifest = await rootBundle.loadString('AssetManifest.json');
      print("Available assets: $manifest");   // ← Add this
    } catch (e) {
      print("No AssetManifest: $e");
    }
    try {
      debugPrint("Loading JSON from: $assetPath");

      final raw = await rootBundle.loadString(assetPath);
      debugPrint("JSON loaded successfully");
      debugPrint("Raw JSON length: ${raw.length}");

      final List<dynamic> decoded = json.decode(raw) as List<dynamic>;
      debugPrint("Decoded ${decoded.length} memojis");

      final memojis = decoded
          .map((e) => Memoji.fromJson(e as Map<String, dynamic>))
          .toList(growable: false);

      debugPrint("Converted ${memojis.length} Memoji objects");

      if (memojis.isNotEmpty) {
        debugPrint("First memoji: ${memojis.first.toJson()}");
      }

      return memojis;
    } catch (e, stackTrace) {
      debugPrint("Error loading memojis: $e");
      debugPrint(stackTrace.toString());
      rethrow;
    }
  }
}
