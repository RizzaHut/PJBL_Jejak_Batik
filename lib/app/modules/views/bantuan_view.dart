import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Tidak perlu controller karena konten statis
class BantuanView extends StatelessWidget {
  const BantuanView({super.key});

  static const Color coklat = Color(0xFF6B5744);
  static const Color krem   = Color(0xFFF5EFE6);

  // Data FAQ
  static const List<Map<String, String>> _faq = [
    {
      'icon': 'person',
      'pertanyaan': 'Bagaimana cara mengganti kata sandi?',
      'jawaban':
          'Untuk mengganti kata sandi akun anda, silahkan ikuti langkah berikut :\n\n'
          '1. Pada halaman profil, tekan tombol Logout/Keluar\n'
          '2. Setelah itu, silahkan lanjut pada halaman Login/Masuk\n'
          '3. Tekan Lupa Password\n'
          '4. Ikuti langkah-langkah yang tertera pada halaman',
    },
    {
      'icon': 'person',
      'pertanyaan': 'Bagaimana cara mengganti email?',
      'jawaban':
          'Email tidak dapat diubah secara langsung. Untuk mengganti email, '
          'silahkan hubungi tim kami melalui jejakbatik@gmail.com dengan '
          'menyertakan email lama dan email baru yang diinginkan.',
    },
    {
      'icon': 'scan',
      'pertanyaan': 'Bagaimana cara menghapus riwayat pemindaian?',
      'jawaban':
          'Untuk menghapus riwayat pemindaian, ikuti langkah berikut :\n\n'
          '1. Buka halaman Galeri\n'
          '2. Tekan dan tahan pada riwayat yang ingin dihapus\n'
          '3. Pilih tombol Hapus yang muncul\n'
          '4. Konfirmasi penghapusan',
    },
    {
      'icon': 'scan',
      'pertanyaan': 'Mengapa hasil pemindaian tidak akurat?',
      'jawaban':
          'Hasil pemindaian dapat kurang akurat karena beberapa faktor :\n\n'
          '1. Pencahayaan yang kurang baik — pastikan area terang\n'
          '2. Jarak kamera terlalu jauh atau terlalu dekat\n'
          '3. Gambar buram atau bergerak saat scan\n'
          '4. Motif batik tidak termasuk dalam database kami\n\n'
          'Coba scan ulang dengan kondisi pencahayaan yang lebih baik.',
    },
    {
      'icon': 'person',
      'pertanyaan': 'Bagaimana cara membuat akun baru?',
      'jawaban':
          'Untuk membuat akun baru :\n\n'
          '1. Buka aplikasi Jejak Batik\n'
          '2. Pada halaman selamat datang, tekan Buat Akun\n'
          '3. Isi nama lengkap, email, dan password\n'
          '4. Tekan tombol Daftar\n'
          '5. Akun berhasil dibuat dan langsung masuk ke aplikasi',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Pusat Bantuan',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: _faq.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, index) {
          final item = _faq[index];
          return _FaqItem(
            icon: item['icon'] == 'scan'
                ? Icons.crop_free_outlined
                : Icons.person_outline,
            pertanyaan: item['pertanyaan']!,
            jawaban: item['jawaban']!,
          );
        },
      ),
    );
  }
}

class _FaqItem extends StatefulWidget {
  final IconData icon;
  final String pertanyaan;
  final String jawaban;

  const _FaqItem({
    required this.icon,
    required this.pertanyaan,
    required this.jawaban,
  });

  @override
  State<_FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<_FaqItem>
    with SingleTickerProviderStateMixin {
  bool _isOpen = false;
  late AnimationController _animController;
  late Animation<double> _animation;

  static const Color coklat = Color(0xFF6B5744);
  static const Color krem   = Color(0xFFF5EFE6);

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _isOpen = !_isOpen);
    if (_isOpen) {
      _animController.forward();
    } else {
      _animController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header — bisa diklik
          InkWell(
            onTap: _toggle,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  // Icon dalam kotak krem
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: krem,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(widget.icon, color: coklat, size: 20),
                  ),
                  const SizedBox(width: 14),
                  // Pertanyaan
                  Expanded(
                    child: Text(
                      widget.pertanyaan,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  // Ikon expand/collapse
                  Icon(
                    _isOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.black54,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),

          // Jawaban dengan animasi expand
          SizeTransition(
            sizeFactor: _animation,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: Colors.grey.shade100, height: 1),
                  const SizedBox(height: 12),
                  Text(
                    widget.jawaban,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      height: 1.65,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
