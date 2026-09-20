import 'package:flutter/material.dart';
import '../models/hero_model.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/description_card.dart';
import '../widgets/hero_grid_card.dart';
import '../widgets/hero_tile.dart';
import 'hero_detail_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isGridView = false;

  final List<HeroModel> heroes = [
    HeroModel(
      id: '1',
      name: 'Ir. Soekarno',
      origin: 'Blitar, Jawa Timur',
      lifeTime: '6 Juni 1901 – 21 Juni 1970',
      description:
          'Presiden pertama Republik Indonesia yang proklamator kemerdekaan bangsa bersama Mohammad Hatta. Beliau memimpin Indonesia pada masa awal kemerdekaan dan mencetuskan konsep Pancasila.',
      imagePath: 'assets/images/soekarno.jpg',
    ),
    HeroModel(
      id: '2',
      name: 'Raden Ajeng Kartini',
      origin: 'Jepara, Jawa Tengah',
      lifeTime: '21 April 1879 – 17 September 1904',
      description:
          'Pelopor emansipasi wanita Indonesia. Kumpulan surat-surat yang dikirimkannya kepada teman-temannya di Eropa dibukukan dengan judul "Habis Gelap Terbitlah Terang".',
      imagePath: 'assets/images/kartini.jpg',
    ),
    HeroModel(
      id: '3',
      name: 'Jendral Sudirman',
      origin: 'Purbalingga, Jawa Tengah',
      lifeTime: '24 Januari 1916 – 29 Januari 1950',
      description:
          'Panglima Besar Tentara Nasional Indonesia pertama. Beliau memimpin perlawanan gerilya melawan pasukan Belanda meskipun dalam keadaan sakit parah.',
      imagePath: 'assets/images/sudirman.jpg',
    ),
    HeroModel(
      id: '4',
      name: 'Mohammad Hatta',
      origin: 'Bukittinggi, Sumatra Barat',
      lifeTime: '12 Agustus 1902 – 14 Maret 1980',
      description:
          'Wakil Presiden Indonesia pertama dan Wakil Proklamator. Beliau dikenal sebagai Bapak Koperasi Indonesia karena perannya memajukan ekonomi kerakyatan.',
      imagePath: 'assets/images/hatta.jpg',
    ),
    HeroModel(
      id: '5',
      name: 'Pangeran Diponegoro',
      origin: 'Yogyakarta',
      lifeTime: '11 November 1785 – 8 Januari 1855',
      description:
          'Pemimpin Perang Jawa (1825–1830) melawan penjajahan Hindia Belanda. Perang ini merupakan salah satu pertempuran paling sengit dalam sejarah Nusantara.',
      imagePath: 'assets/images/diponegoro.jpg',
    ),
    HeroModel(
      id: '6',
      name: 'Cut Nyak Dhien',
      origin: 'Aceh Besar, Aceh',
      lifeTime: '1848 – 6 November 1908',
      description:
          'Pahlawan wanita asal Aceh yang memimpin perang gerilya melawan Belanda setelah kematian suaminya, Teuku Umar. Beliau berjuang gigih hingga masa tuanya.',
      imagePath: 'assets/images/cut_nyak_dhien.jpg',
    ),
    HeroModel(
      id: '7',
      name: 'Ki Hajar Dewantara',
      origin: 'Yogyakarta',
      lifeTime: '2 Mei 1889 – 26 April 1959',
      description:
          'Bapak Pendidikan Nasional Indonesia dan pendiri Taman Siswa. Tanggal kelahirannya diperingati sebagai Hari Pendidikan Nasional.',
      imagePath: 'assets/images/ki_hajar_dewantara.jpg',
    ),
    HeroModel(
      id: '8',
      name: 'Bung Tomo (Sutomo)',
      origin: 'Surabaya, Jawa Timur',
      lifeTime: '3 Oktober 1920 – 7 Oktober 1981',
      description:
          'Tokoh pemuda yang membakar semangat rakyat Surabaya melalui siaran radio untuk melawan pasukan Sekutu dalam Pertempuran 10 November 1945.',
      imagePath: 'assets/images/bung_tomo.jpg',
    ),
    HeroModel(
      id: '9',
      name: 'Tuanku Imam Bonjol',
      origin: 'Pasaman, Sumatra Barat',
      lifeTime: '1772 – 6 November 1864',
      description:
          'Pemimpin ulama dan pejuang dalam Perang Padri melawan pemerintah kolonial Belanda di Sumatra Barat.',
      imagePath: 'assets/images/imam_bonjol.jpg',
    ),
    HeroModel(
      id: '10',
      name: 'Pattimura (Thomas Matulessy)',
      origin: 'Saparua, Maluku',
      lifeTime: '8 Juni 1783 – 16 Desember 1817',
      description:
          'Pemimpin perlawanan rakyat Maluku melawan monopoli perdagangan dan penindasan benteng VOC Belanda di Saparua.',
      imagePath: 'assets/images/pattimura.jpg',
    ),
    HeroModel(
      id: '11',
      name: 'Sultan Hasanuddin',
      origin: 'Gowa, Sulawesi Selatan',
      lifeTime: '12 Januari 1631 – 12 Juni 1670',
      description:
          'Raja Gowa ke-16 yang dijuluki "Ayam Jantan dari Timur" oleh Belanda karena keberaniannya menentang monopoli VOC di Indonesia timur.',
      imagePath: 'assets/images/hasanuddin.jpg',
    ),
    HeroModel(
      id: '12',
      name: 'I Gusti Ngurah Rai',
      origin: 'Badung, Bali',
      lifeTime: '30 Januari 1917 – 20 November 1946',
      description:
          'Pahlawan asal Bali yang memimpin pasukan Ciung Wanara dalam pertempuran Puputan Margarana melawan pasukan Belanda hingga titik darah penghabisan.',
      imagePath: 'assets/images/ngurah_rai.jpg',
    ),
    HeroModel(
      id: '13',
      name: 'Dewi Sartika',
      origin: 'Bandung, Jawa Barat',
      lifeTime: '4 Desember 1884 – 11 September 1947',
      description:
          'Tokoh perintis pendidikan wanita dari Sunda yang mendirikan Sakola Istri (Sakola Kautamaan Istri) untuk membekali kaum perempuan dengan ilmu pengetahuan.',
      imagePath: 'assets/images/dewi_sartika.jpg',
    ),
    HeroModel(
      id: '14',
      name: 'Tan Malaka',
      origin: 'Limapuluh Kota, Sumatra Barat',
      lifeTime: '2 Juni 1897 – 21 Februari 1949',
      description:
          'Filsuf dan pejuang kemerdekaan yang menulis buku "Naar de Republiek Indonesia", gagasan tertulis pertama mengenai Republik Indonesia.',
      imagePath: 'assets/images/tan_malaka.jpg',
    ),
    HeroModel(
      id: '15',
      name: 'R.A. Ageng Serang',
      origin: 'Purwodadi, Jawa Tengah',
      lifeTime: '1752 – 1828',
      description:
          'Pahlawan wanita dan panglima perang yang mendampingi perjuangan Pangeran Diponegoro menentang penjajah Belanda.',
      imagePath: 'assets/images/ageng_serang.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4EAE0),
      body: SafeArea(
        child: Column(
          children: [
            const DashboardHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
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
                            Icon(Icons.bookmark, color: Color(0xFF8B0000), size: 20),
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
                              border: Border.all(color: const Color(0xFF3E2723), width: 2),
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
                    const SizedBox(height: 16.0),

                    // RENDER: Mode Grid (5 per Baris) vs Mode List (Kotak Panjang)
                    if (isGridView)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 5, // Tepat 5 pahlawan per baris
                          childAspectRatio: 0.65, // Rasio kartu untuk foto + teks biografi
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: heroes.length,
                        itemBuilder: (context, index) {
                          final hero = heroes[index];
                          return HeroGridCard(
                            hero: hero,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HeroDetailPage(hero: hero),
                                ),
                              );
                            },
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
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HeroDetailPage(hero: hero),
                                ),
                              );
                            },
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