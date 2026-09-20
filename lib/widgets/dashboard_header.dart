import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF3E2723),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            width: double.infinity,
            child: const Center(
              child: Text(
                'NATIONAL HEROES OF INDONESIA',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  fontFamily: 'Georgia',
                  color: Color(0xFFFFF8EA),
                ),
              ),
            ),
          ),
          Container(
            height: 4,
            color: const Color(0xFF8B0000),
          ),
          const Divider(
            thickness: 2,
            height: 2,
            color: Color(0xFFD7CCC8),
          ),
        ],
      ),
    );
  }
}