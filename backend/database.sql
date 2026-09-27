-- Skema & data awal database Pahlawan Nasional Indonesia.
-- Import lewat phpMyAdmin (tab Import) atau lewat terminal:
--   D:\xampp\mysql\bin\mysql.exe -u root --default-character-set=utf8mb4 < backend\database.sql
-- PERINGATAN: menjalankan ulang file ini akan menghapus data yang sudah ada.

CREATE DATABASE IF NOT EXISTS national_heroes
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE national_heroes;

DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS heroes;

CREATE TABLE heroes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  origin VARCHAR(150) NOT NULL,
  life_time VARCHAR(100) NOT NULL,
  description TEXT NOT NULL,
  image_path VARCHAR(500) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE comments (
  id INT AUTO_INCREMENT PRIMARY KEY,
  hero_id INT NOT NULL,
  author VARCHAR(100) NOT NULL,
  content TEXT NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_comments_hero FOREIGN KEY (hero_id)
    REFERENCES heroes (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO heroes (name, origin, life_time, description, image_path) VALUES
  ('Ir. Soekarno', 'Blitar, Jawa Timur', '6 Juni 1901 – 21 Juni 1970', 'Presiden pertama Republik Indonesia yang proklamator kemerdekaan bangsa bersama Mohammad Hatta. Beliau memimpin Indonesia pada masa awal kemerdekaan dan mencetuskan konsep Pancasila.', 'assets/images/soekarno.jpg'),
  ('Raden Ajeng Kartini', 'Jepara, Jawa Tengah', '21 April 1879 – 17 September 1904', 'Pelopor emansipasi wanita Indonesia. Kumpulan surat-surat yang dikirimkannya kepada teman-temannya di Eropa dibukukan dengan judul "Habis Gelap Terbitlah Terang".', 'assets/images/kartini.jpg'),
  ('Jendral Sudirman', 'Purbalingga, Jawa Tengah', '24 Januari 1916 – 29 Januari 1950', 'Panglima Besar Tentara Nasional Indonesia pertama. Beliau memimpin perlawanan gerilya melawan pasukan Belanda meskipun dalam keadaan sakit parah.', 'assets/images/sudirman.jpg'),
  ('Mohammad Hatta', 'Bukittinggi, Sumatra Barat', '12 Agustus 1902 – 14 Maret 1980', 'Wakil Presiden Indonesia pertama dan Wakil Proklamator. Beliau dikenal sebagai Bapak Koperasi Indonesia karena perannya memajukan ekonomi kerakyatan.', 'assets/images/hatta.jpg'),
  ('Pangeran Diponegoro', 'Yogyakarta', '11 November 1785 – 8 Januari 1855', 'Pemimpin Perang Jawa (1825–1830) melawan penjajahan Hindia Belanda. Perang ini merupakan salah satu pertempuran paling sengit dalam sejarah Nusantara.', 'assets/images/diponegoro.jpg'),
  ('Cut Nyak Dhien', 'Aceh Besar, Aceh', '1848 – 6 November 1908', 'Pahlawan wanita asal Aceh yang memimpin perang gerilya melawan Belanda setelah kematian suaminya, Teuku Umar. Beliau berjuang gigih hingga masa tuanya.', 'assets/images/cut_nyak_dhien.jpg'),
  ('Ki Hajar Dewantara', 'Yogyakarta', '2 Mei 1889 – 26 April 1959', 'Bapak Pendidikan Nasional Indonesia dan pendiri Taman Siswa. Tanggal kelahirannya diperingati sebagai Hari Pendidikan Nasional.', 'assets/images/ki_hajar_dewantara.jpg'),
  ('Bung Tomo (Sutomo)', 'Surabaya, Jawa Timur', '3 Oktober 1920 – 7 Oktober 1981', 'Tokoh pemuda yang membakar semangat rakyat Surabaya melalui siaran radio untuk melawan pasukan Sekutu dalam Pertempuran 10 November 1945.', 'assets/images/bung_tomo.jpg'),
  ('Tuanku Imam Bonjol', 'Pasaman, Sumatra Barat', '1772 – 6 November 1864', 'Pemimpin ulama dan pejuang dalam Perang Padri melawan pemerintah kolonial Belanda di Sumatra Barat.', 'assets/images/imam_bonjol.jpg'),
  ('Pattimura (Thomas Matulessy)', 'Saparua, Maluku', '8 Juni 1783 – 16 Desember 1817', 'Pemimpin perlawanan rakyat Maluku melawan monopoli perdagangan dan penindasan benteng VOC Belanda di Saparua.', 'assets/images/pattimura.jpg'),
  ('Sultan Hasanuddin', 'Gowa, Sulawesi Selatan', '12 Januari 1631 – 12 Juni 1670', 'Raja Gowa ke-16 yang dijuluki "Ayam Jantan dari Timur" oleh Belanda karena keberaniannya menentang monopoli VOC di Indonesia timur.', 'assets/images/hasanuddin.jpg'),
  ('I Gusti Ngurah Rai', 'Badung, Bali', '30 Januari 1917 – 20 November 1946', 'Pahlawan asal Bali yang memimpin pasukan Ciung Wanara dalam pertempuran Puputan Margarana melawan pasukan Belanda hingga titik darah penghabisan.', 'assets/images/ngurah_rai.jpg'),
  ('Dewi Sartika', 'Bandung, Jawa Barat', '4 Desember 1884 – 11 September 1947', 'Tokoh perintis pendidikan wanita dari Sunda yang mendirikan Sakola Istri (Sakola Kautamaan Istri) untuk membekali kaum perempuan dengan ilmu pengetahuan.', 'assets/images/dewi_sartika.jpg'),
  ('Tan Malaka', 'Limapuluh Kota, Sumatra Barat', '2 Juni 1897 – 21 Februari 1949', 'Filsuf dan pejuang kemerdekaan yang menulis buku "Naar de Republiek Indonesia", gagasan tertulis pertama mengenai Republik Indonesia.', 'assets/images/tan_malaka.jpg'),
  ('R.A. Ageng Serang', 'Purwodadi, Jawa Tengah', '1752 – 1828', 'Pahlawan wanita dan panglima perang yang mendampingi perjuangan Pangeran Diponegoro menentang penjajah Belanda.', 'assets/images/ageng_serang.jpg');
