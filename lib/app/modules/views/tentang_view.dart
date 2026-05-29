import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Tidak perlu controller karena konten statis
class TentangView extends StatelessWidget {
  const TentangView({super.key});

  static const Color coklat = Color(0xFF6B5744);
  static const Color kuning = Color(0xFFC9A961);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6B5744),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6B5744),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Tentang Kami',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo + nama app
                    Center(
                      child: Column(
                        children: [
                          Image.asset(
                            'lib/assets/home/logo.png',
                            width: 90,
                            height: 90,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Jejak Batik',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: coklat,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Versi 1.0.0',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    _buildSection(
                      'Tentang Aplikasi',
                      'Jejak Batik adalah aplikasi mobile yang dirancang '
                          'untuk membantu masyarakat mengenal dan melestarikan '
                          'warisan budaya batik Indonesia. Dengan teknologi '
                          'kecerdasan buatan, pengguna dapat memindai motif '
                          'batik secara langsung menggunakan kamera dan '
                          'mendapatkan informasi lengkap mengenai asal usul, '
                          'filosofi, dan makna di balik setiap helai kain batik.',
                    ),

                    _buildSection(
                      'Visi',
                      'Menjadi platform digital terdepan dalam pelestarian '
                          'dan pengenalan budaya batik Indonesia kepada generasi '
                          'muda dan masyarakat luas.',
                    ),

                    _buildSection(
                      'Misi',
                      '• Memudahkan masyarakat mengenali motif batik '
                          'melalui teknologi modern\n'
                          '• Menyediakan informasi akurat tentang sejarah '
                          'dan makna batik\n'
                          '• Mendorong kecintaan generasi muda terhadap '
                          'budaya bangsa\n'
                          '• Menjadi jembatan antara tradisi dan teknologi',
                    ),

                    _buildSection(
                      'Tim Pengembang',
                      'Dikembangkan oleh siswa SMK Negeri 4 sebagai'
                          'PJBL (Project Based Learning) ',
                    ),

                    // Kontak
                    _buildHeader('Kontak'),
                    const SizedBox(height: 8),
                    _buildKontakItem(
                      Icons.email_outlined,
                      'jejakbatik@gmail.com',
                    ),
                    const SizedBox(height: 6),
                    _buildKontakItem(Icons.camera_alt_outlined, '@jejakbatik'),

                    const SizedBox(height: 32),

                    // Footer
                    Center(
                      child: Text(
                        '© 2025 Jejak Batik — SMK Negeri 4',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String title) => Text(
    title,
    style: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: coklat,
    ),
  );

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(title),
          const SizedBox(height: 6),
          Text(
            content,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              height: 1.65,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKontakItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: coklat),
        const SizedBox(width: 10),
        Text(text, style: const TextStyle(fontSize: 13, color: Colors.black87)),
      ],
    );
  }
}
