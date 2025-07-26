import 'package:flutter/material.dart';

class CustomImage extends StatelessWidget {
  final String? imageUrl;
  final String? assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;

  const CustomImage({
    super.key,
    this.imageUrl,
    this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildImage(),
    );
  }

  Widget _buildImage() {
    if (assetPath != null) {
      return Image.asset(
        assetPath!,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
      );
    } else if (imageUrl != null) {
      return Image.network(
        imageUrl!,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
      );
    }
    return _buildErrorWidget();
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Icon(Icons.image_not_supported, color: Colors.grey),
    );
  }
}

class CircularAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? assetPath;
  final double size;
  final String? initials;

  const CircularAvatar({
    super.key,
    this.imageUrl,
    this.assetPath,
    this.size = 48,
    this.initials,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[200],
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (imageUrl != null) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    } else if (assetPath != null) {
      return Image.asset(
        assetPath!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    if (initials != null) {
      return Center(
        child: Text(
          initials!.substring(0, 2).toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: size / 2.5,
          ),
        ),
      );
    }
    return Center(
      child: Icon(Icons.person, size: size / 2),
    );
  }
}
