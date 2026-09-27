import 'package:flutter/material.dart';
import '../models/hero_model.dart';
import 'hero_image.dart';

class HeroGridCard extends StatelessWidget {
  final HeroModel hero;
  final VoidCallback onTap;

  const HeroGridCard({
    super.key,
    required this.hero,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8EA),
          border: Border.all(color: const Color(0xFF3E2723), width: 2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              offset: Offset(3, 3),
              blurRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Area Foto Pahlawan
            Expanded(
              flex: 5,
              child: Container(
                color: const Color(0xFFEFEBE9),
                child: HeroImage(path: hero.imagePath),
              ),
            ),
            const Divider(height: 2, thickness: 2, color: Color(0xFF3E2723)),
            // Area Nama & Biografi Singkat
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                color: const Color(0xFFFFF8EA),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hero.name.toUpperCase(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Georgia',
                        color: Color(0xFF3E2723),
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Expanded(
                      child: Text(
                        hero.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          height: 1.4,
                          fontFamily: 'Georgia',
                          color: Color(0xFF5D4037),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}