import 'package:cached_network_image/cached_network_image.dart';
import 'package:devcollab/widgets/Profile/pinterestskeleton.dart';
import 'package:flutter/material.dart';

import '../../models/showcase_image.dart';

class _PinterestCard extends StatelessWidget {
  const _PinterestCard({
    required this.item,
  });

  final ShowcaseImage item;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: AspectRatio(
        aspectRatio: item.aspectRatio,
        child: CachedNetworkImage(
          imageUrl: item.imageUrl,
          fit: BoxFit.cover,
          placeholder: (_, __) => const PinterestSkeleton(),
          errorWidget: (_, __, ___) => Container(
            color: Colors.grey.shade200,
            child: const Icon(Icons.broken_image),
          ),
        ),
      ),
    );
  }
}