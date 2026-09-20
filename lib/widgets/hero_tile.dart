import 'package:flutter/material.dart';

class HeroTile extends StatelessWidget {
  final String heroName;
  final VoidCallback onTap;

  const HeroTile({
    super.key,
    required this.heroName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18.0),
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
          child: Center(
            child: Text(
              heroName.toUpperCase(),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                fontFamily: 'Georgia',
                color: Color(0xFF3E2723),
              ),
            ),
          ),
        ),
      ),
    );
  }
}