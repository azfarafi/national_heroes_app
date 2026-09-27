import 'package:flutter/material.dart';

/// Menampilkan foto pahlawan dari path aset (`assets/...`) atau URL (`http...`).
class HeroImage extends StatelessWidget {
  final String path;
  final String placeholder;
  final double placeholderFontSize;

  const HeroImage({
    super.key,
    required this.path,
    this.placeholder = '[ Foto Pahlawan ]',
    this.placeholderFontSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    Widget errorBuilder(BuildContext context, Object error, StackTrace? stackTrace) {
      return Center(
        child: Text(
          placeholder,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: placeholderFontSize,
            fontFamily: 'Georgia',
            color: const Color(0xFF3E2723),
          ),
        ),
      );
    }

    if (path.trim().isEmpty) {
      return errorBuilder(context, 'empty', null);
    }
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(path, fit: BoxFit.cover, errorBuilder: errorBuilder);
    }
    return Image.asset(path, fit: BoxFit.cover, errorBuilder: errorBuilder);
  }
}
