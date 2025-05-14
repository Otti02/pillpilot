import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A custom image widget that can be styled in different ways.
class CustomImage extends StatelessWidget {
  final String? imageUrl;
  final String? assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final bool showBorder;
  final IconData? placeholderIcon;
  final String? errorText;

  const CustomImage({
    Key? key,
    this.imageUrl,
    this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.backgroundColor,
    this.showBorder = false,
    this.placeholderIcon,
    this.errorText,
  })  : assert(imageUrl != null || assetPath != null, 'Either imageUrl or assetPath must be provided'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadiusValue = borderRadius ?? BorderRadius.circular(12);
    
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.secondaryColor.withOpacity(0.1),
        borderRadius: borderRadiusValue,
        border: showBorder ? Border.all(color: AppTheme.borderColor) : null,
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
          return _buildLoadingWidget(loadingProgress);
        },
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
      );
    } else {
      return _buildErrorWidget();
    }
  }

  Widget _buildLoadingWidget(ImageChunkEvent loadingProgress) {
    return Center(
      child: CircularProgressIndicator(
        value: loadingProgress.expectedTotalBytes != null
            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
            : null,
        color: AppTheme.primaryColor,
        strokeWidth: 2,
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            placeholderIcon ?? Icons.image_not_supported_outlined,
            color: AppTheme.secondaryTextColor,
            size: 32,
          ),
          if (errorText != null) ...[
            const SizedBox(height: 8),
            Text(
              errorText!,
              style: AppTheme.bodyStyle.copyWith(
                color: AppTheme.secondaryTextColor,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// A circular avatar image widget.
class CircularAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? assetPath;
  final double size;
  final Color? backgroundColor;
  final IconData? placeholderIcon;
  final String? initials;
  final Color? textColor;

  const CircularAvatar({
    Key? key,
    this.imageUrl,
    this.assetPath,
    this.size = 48,
    this.backgroundColor,
    this.placeholderIcon,
    this.initials,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppTheme.secondaryColor.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (imageUrl != null) {
      return Image.network(
        imageUrl!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    } else if (assetPath != null) {
      return Image.asset(
        assetPath!,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    } else {
      return _buildPlaceholder();
    }
  }

  Widget _buildPlaceholder() {
    if (initials != null) {
      return Center(
        child: Text(
          initials!.length > 2 ? initials!.substring(0, 2).toUpperCase() : initials!.toUpperCase(),
          style: TextStyle(
            color: textColor ?? AppTheme.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: size / 2.5,
          ),
        ),
      );
    } else {
      return Center(
        child: Icon(
          placeholderIcon ?? Icons.person,
          color: AppTheme.primaryColor,
          size: size / 2,
        ),
      );
    }
  }
}