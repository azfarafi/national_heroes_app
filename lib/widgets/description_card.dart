import 'package:flutter/material.dart';

class DescriptionCard extends StatelessWidget {
  const DescriptionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8EA),
        border: Border.all(color: const Color(0xFF3E2723), width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 140,
            decoration: BoxDecoration(
              color: const Color(0xFFEFEBE9),
              border: Border.all(color: const Color(0xFF3E2723), width: 2),
            ),
            child: ClipRRect(
              child: Image.asset(
                'assets/images/perang.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Text(
                      '[ Foto Perang ]',
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
          ),
          const SizedBox(width: 28.0),
          const Expanded(
            child: Text(
              'Mengenal sejarah kini lebih mudah dan menarik. '
              'Temukan cerita di balik perjuangan para tokoh bangsa, '
              'kilas balik peristiwa bersejarah, dan bagaimana nilai keberanian mereka '
              'tetap relevan untuk menginspirasi langkah kita hari ini.',
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
                fontWeight: FontWeight.w500,
                fontFamily: 'Georgia',
                color: Color(0xFF2C1D11),
              ),
            ),
          ),
        ],
      ),
    );
  }
}