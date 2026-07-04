import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/profileprovider.dart';

class DC1 {
  static const primary = Color(0xFF6C5CE7);
  static const primaryDark = Color(0xFF4834D4);
  static const borderLight = Color(0xFFE8E8EC);
  static const textMuted = Color(0xFF8A8A9A);
}

const Map<String, List<String>> kBannerCatalogue = {
  'Nature': [
    'https://picsum.photos/id/1015/800/450',
    'https://picsum.photos/id/1018/800/450',
    'https://picsum.photos/id/1043/800/450',
    'https://picsum.photos/id/1039/800/450',
  ],
  'Abstract': [
    'https://picsum.photos/id/1062/800/450',
    'https://picsum.photos/id/1067/800/450',
    'https://picsum.photos/id/1074/800/450',
    'https://picsum.photos/id/1080/800/450',
  ],
  'Business': [
    'https://picsum.photos/id/180/800/450',
    'https://picsum.photos/id/201/800/450',
    'https://picsum.photos/id/225/800/450',
    'https://picsum.photos/id/239/800/450',
  ],
  'Minimal': [
    'https://picsum.photos/id/1048/800/450',
    'https://picsum.photos/id/1050/800/450',
    'https://picsum.photos/id/1053/800/450',
    'https://picsum.photos/id/1056/800/450',
  ],
};

class BannerSelectionScreen extends StatefulWidget {
  const BannerSelectionScreen({super.key});

  @override
  State<BannerSelectionScreen> createState() => _BannerSelectionScreenState();
}

class _BannerSelectionScreenState extends State<BannerSelectionScreen> {
  late String _selecteDC1ategory;
  String? _selectedImageUrl;

  @override
  void initState() {
    super.initState();
    _selecteDC1ategory = kBannerCatalogue.keys.first;
    // Preselect whatever the user already has, if it matches the catalogue.
    final current = context.read<ProfileProvider>().bannerimage;
    if (current != null && current.isNotEmpty) {
      _selectedImageUrl = current;
      for (final entry in kBannerCatalogue.entries) {
        if (entry.value.contains(current)) {
          _selecteDC1ategory = entry.key;
          break;
        }
      }
    }
  }

  void _continue() {
    if (_selectedImageUrl == null) return;
    context.read<ProfileProvider>().setBannerImage(_selectedImageUrl!);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final images = kBannerCatalogue[_selecteDC1ategory]!;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F7FA),
        elevation: 0,
        centerTitle: false,
        titleSpacing: 20,
        title: const Text(
          'Choose banner',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // ---- Category chips ------------------------------------------------
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: kBannerCatalogue.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, i) {
                final category = kBannerCatalogue.keys.elementAt(i);
                final selected = category == _selecteDC1ategory;
                return GestureDetector(
                  onTap: () => setState(() => _selecteDC1ategory = category),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected ? DC1.primary : Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: selected ? DC1.primary : DC1.borderLight,
                      ),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.5,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 18),

          // ---- Image grid -------------------------------------------------
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              itemCount: images.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 16 / 10,
              ),
              itemBuilder: (context, i) {
                final url = images[i];
                final selected = url == _selectedImageUrl;
                return GestureDetector(
                  onTap: () => setState(() => _selectedImageUrl = url),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selected ? DC1.primary : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(selected ? 0.14 : 0.06),
                          blurRadius: selected ? 14 : 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            url,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                color: const Color(0xFFEDEDF2),
                                child: const Center(
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stack) => Container(
                              color: const Color(0xFFEDEDF2),
                              child: const Icon(Icons.broken_image_outlined,
                                  color: DC1.textMuted),
                            ),
                          ),
                          if (selected)
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: DC1.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.check_rounded,
                                    color: Colors.white, size: 14),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // ---- Continue button ---------------------------------------------
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _selectedImageUrl == null ? null : _continue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DC1.primary,
                    disabledBackgroundColor: DC1.primary.withOpacity(0.35),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}