import 'package:flutter/material.dart';
import '../models/hero_model.dart';
import '../services/api_service.dart';
import '../widgets/comment_section.dart';
import '../widgets/hero_image.dart';
import 'hero_form_page.dart';

class HeroDetailPage extends StatefulWidget {
  final HeroModel hero;

  const HeroDetailPage({super.key, required this.hero});

  @override
  State<HeroDetailPage> createState() => _HeroDetailPageState();
}

class _HeroDetailPageState extends State<HeroDetailPage> {
  late HeroModel hero = widget.hero;

  Future<void> _edit() async {
    final updated = await Navigator.push<HeroModel>(
      context,
      MaterialPageRoute(builder: (context) => HeroFormPage(hero: hero)),
    );
    if (updated != null) setState(() => hero = updated);
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFFFF8EA),
        title: const Text('Hapus Pahlawan',
            style: TextStyle(fontFamily: 'Georgia')),
        content: Text(
            'Yakin ingin menghapus "${hero.name}"? Semua komentarnya juga akan terhapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child:
                const Text('Hapus', style: TextStyle(color: Color(0xFF8B0000))),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ApiService.instance.deleteHero(hero.id!);
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal menghapus: $e')));
      return;
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${hero.name} berhasil dihapus')),
    );
    Navigator.pop(context);
  }

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
        actions: [
          IconButton(
            tooltip: 'Edit',
            icon: const Icon(Icons.edit),
            onPressed: _edit,
          ),
          IconButton(
            tooltip: 'Hapus',
            icon: const Icon(Icons.delete),
            onPressed: _delete,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Column(
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 900),
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8EA),
                    border:
                        Border.all(color: const Color(0xFF3E2723), width: 3),
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
                          border: Border.all(
                              color: const Color(0xFF3E2723), width: 3),
                        ),
                        child: HeroImage(
                          path: hero.imagePath,
                          placeholder: '[ Foto Tidak Ditemukan ]',
                          placeholderFontSize: 14,
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
                            const Divider(
                                thickness: 1, color: Color(0xFF3E2723)),
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
                const SizedBox(height: 32),
                CommentSection(heroId: hero.id!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
