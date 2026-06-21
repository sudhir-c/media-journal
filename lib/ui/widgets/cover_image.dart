import 'package:flutter/material.dart';

/// Cover image with graceful fallbacks: a placeholder when there's no URL and
/// the same placeholder if the image fails to load.
class CoverImage extends StatelessWidget {
  const CoverImage({super.key, required this.url, this.iconSize = 32});

  final String? url;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Icon(
        Icons.image_outlined,
        size: iconSize,
        color: Theme.of(context).colorScheme.outline,
      ),
    );

    if (url == null || url!.isEmpty) return placeholder;

    return Image.network(
      url!,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => placeholder,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          alignment: Alignment.center,
          child: const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
    );
  }
}
