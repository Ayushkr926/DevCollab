class ShowcaseImage {
  final String imageUrl;
  final int width;
  final int height;

  ShowcaseImage({
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  double get aspectRatio => width / height;
}