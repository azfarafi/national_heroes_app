import 'package:flutter/material.dart';
import '../models/hero_model.dart';
import '../services/api_service.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/description_card.dart';
import '../widgets/hero_grid_card.dart';
import '../widgets/hero_tile.dart';
import 'hero_detail_page.dart';
import 'hero_form_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isGridView = false;

  List<HeroModel> heroes = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadHeroes();
  }

  Future<void> _loadHeroes() async {
    setState(() => isLoading = heroes.isEmpty);
    try {
      final data = await ApiService.instance.getHeroes();
      if (!mounted) return;
      setState(() {
        heroes = data;
        errorMessage = null;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => errorMessage = e.message);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _openDetail(HeroModel hero) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HeroDetailPage(hero: hero)),
    );
    // Data bisa berubah (edit/hapus) di halaman detail, jadi muat ulang.
    _loadHeroes();
  }

  Future<void> _openAddForm() async {
    final created = await Navigator.push<HeroModel>(
      context,
      MaterialPageRoute(builder: (context) => const HeroFormPage()),
    );
    if (created != null) _loadHeroes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4EAE0),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddForm,
        backgroundColor: const Color(0xFF8B0000),
        foregroundColor: const Color(0xFFFFF8EA),
        shape: const RoundedRectangleBorder(
          side: BorderSide(color: Color(0xFF3E2723), width: 2),
        ),
        icon: const Icon(Icons.add),
        label: const Text(
          'Tambah Pahlawan',
          style: TextStyle(fontFamily: 'Georgia', fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const DashboardHeader(),
            Expanded(
              child: SingleChildScrollView(
                // Padding bawah ekstra agar item terakhir tidak tertutup tombol tambah.
                padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 96.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DescriptionCard(),
                    const SizedBox(height: 32.0),

                    // Header List & Tombol Sakelar Lingkaran Belah Ketupat
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.bookmark,
                                color: Color(0xFF8B0000), size: 20),
                            SizedBox(width: 8),
                            Text(
                              'LIST PAHLAWAN NASIONAL INDONESIA',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                fontFamily: 'Georgia',
                                color: Color(0xFF3E2723),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            // Muat ulang data dari database (mis. setelah diedit di phpMyAdmin)
                            IconButton(
                              tooltip: 'Muat ulang data',
                              onPressed: _loadHeroes,
                              icon: const Icon(Icons.refresh,
                                  color: Color(0xFF3E2723)),
                            ),
                            const SizedBox(width: 8),
                            // Tombol Lingkaran Belah Ketupat
                            InkWell(
                              onTap: () {
                                setState(() {
                                  isGridView = !isGridView;
                                });
                              },
                              borderRadius: BorderRadius.circular(24.0),
                              child: Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFFFF8EA),
                                  border: Border.all(
                                      color: const Color(0xFF3E2723), width: 2),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x33000000),
                                      offset: Offset(2, 2),
                                      blurRadius: 0,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.diamond_outlined,
                                  color: Color(0xFF3E2723),
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),

                    // RENDER: Mode Grid (5 per Baris) vs Mode List (Kotak Panjang)
                    if (isLoading)
                      const Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                errorMessage!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'Georgia',
                                  color: Color(0xFF8B0000),
                                ),
                              ),
                              const SizedBox(height: 12),
                              OutlinedButton.icon(
                                onPressed: _loadHeroes,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Coba lagi'),
                              ),
                            ],
                          ),
                        ),
                      )
                    else if (heroes.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Center(
                          child: Text(
                            'Belum ada data pahlawan. Tekan "Tambah Pahlawan" untuk menambahkan.',
                            style: TextStyle(
                              fontFamily: 'Georgia',
                              fontStyle: FontStyle.italic,
                              color: Color(0xFF5D4037),
                            ),
                          ),
                        ),
                      )
                    else if (isGridView)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5, // Tepat 5 pahlawan per baris
                          childAspectRatio:
                              0.65, // Rasio kartu untuk foto + teks biografi
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: heroes.length,
                        itemBuilder: (context, index) {
                          final hero = heroes[index];
                          return HeroGridCard(
                            hero: hero,
                            onTap: () => _openDetail(hero),
                          );
                        },
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: heroes.length,
                        itemBuilder: (context, index) {
                          final hero = heroes[index];
                          return HeroTile(
                            heroName: hero.name,
                            onTap: () => _openDetail(hero),
                          );
                        },
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
