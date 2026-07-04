import 'package:cached_network_image/cached_network_image.dart';
import 'package:devcollab/widgets/Profile/pinterestcard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/showcase_image.dart';

class ShowcaseGrid extends StatelessWidget {
  const ShowcaseGrid({
    super.key,
    required this.images,
  });

  final List<ShowcaseImage> images;

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      gridDelegate:
      const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        final item = images[index];

        return PinterestCard(item: item);
      },
    );
  }
}