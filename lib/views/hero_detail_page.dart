import 'package:flutter/material.dart';
import '../models/hero_model.dart';

class HeroDetailPage extends StatelessWidget {
  final HeroModel hero;

  const HeroDetailPage({super.key, required this.hero});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4EAE0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3E2723),
        foregroundColor: const Color(0xFFFFF8EA),
        title: Text(
          hero.name,
          style: const TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 900),
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8EA),
                border: Border.all(color: const Color(0xFF3E2723), width: 3),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x33000000),
                    offset: Offset(6, 6),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 220,
                    height: 300,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFEBE9),
                      border: Border.all(color: const Color(0xFF3E2723), width: 3),
                    ),
                    child: Image.asset(
                      hero.imagePath,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Text(
                            '[ Foto Tidak Ditemukan ]',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              color: Color(0xFF3E2723),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 32.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hero.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Georgia',
                            color: Color(0xFF3E2723),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Daerah: ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Georgia',
                                color: Color(0xFF8B0000),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                hero.origin,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Georgia',
                                  color: Color(0xFF2C1D11),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Masa Hidup: ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Georgia',
                                color: Color(0xFF8B0000),
                              ),
                            ),
                            Expanded(
                              child: Text(
                                hero.lifeTime,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'Georgia',
                                  color: Color(0xFF2C1D11),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Divider(thickness: 1, color: Color(0xFF3E2723)),
                        const SizedBox(height: 12),
                        const Text(
                          'Biografi:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Georgia',
                            color: Color(0xFF3E2723),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          hero.description,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            fontFamily: 'Georgia',
                            color: Color(0xFF2C1D11),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}