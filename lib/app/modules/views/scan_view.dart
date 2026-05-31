import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../services/scan_service.dart';

class ScanView extends StatefulWidget {
  const ScanView({super.key});

  @override
  State<ScanView> createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  // ── Kamera ───────────────────────────────────────────────────────
  CameraController? _cameraController;
  bool _isCameraReady = false;
  final ScanService _scanService = ScanService();

  // ── Firestore ─────────────────────────────────────────────────────
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ── State hasil scan ──────────────────────────────────────────────
  // Menyimpan data batik yang ditemukan dari Firestore
  Map<String, dynamic>? _batikDitemukan;
  String _resultLabel = '';
  double _confidence = 0.0;
  XFile? _capturedImage;
  bool _isAnalyzing = false;
  bool _showResult = false;

  final Color coklat = const Color(0xFF6B5744);
  final Color kuning = const Color(0xFFC9A961);
  static const Color _hijauTua = Color(0xFF2D6A4F);

  static const Map<String, String> _labelToRoute = {
    'kawung': '/hasil-kawung',
    'parang': '/hasil-parang',
    'batik-megamendung': '/hasil-megamendung',
    'batik-sogan': '/hasil-sogan',
    'batik-sekar': '/hasil-sekar-jagad',
  };

  // ── initState ─────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      final controller = CameraController(
        cameras[0],
        ResolutionPreset.high,
        enableAudio: false,
      );
      await controller.initialize();
      if (!mounted) return;

      setState(() {
        _cameraController = controller;
        _isCameraReady = true;
      });
    } catch (e) {
      debugPrint('initCamera error: $e');
      if (mounted) setState(() => _isCameraReady = false);
    }
  }

  Future<Map<String, dynamic>?> _fetchBatikByLabel(String label) async {
    try {
      debugPrint('Query labelModel: "$label"');
      final snap = await _db
          .collection('batik')
          .where('labelModel', isEqualTo: '$label')
          .limit(1)
          .get();

      if (snap.docs.isEmpty) return null;

      final doc = snap.docs.first;
      final data = doc.data();

      return {
        'docId': doc.id, // "btk2"
        'nama': data['nama'] as String? ?? '',
        'asal': data['asal'] as String? ?? '',
        'daerah': data['daerah'] as String? ?? '',
        'imagePath': data['imagePath'] as String? ?? '',
        'route': _labelToRoute[label] ?? '/hasil-kawung',
      };
    } catch (e) {
      debugPrint('_fetchBatikByLabel error: $e');
      return null;
    }
  }

  Future<void> _simpanRiwayatScan(String batikDocId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      await _db.collection('users').doc(uid).collection('riwayat_scan').add({
        'userId': uid,
        'batikId': batikDocId,
        'scannedAt': FieldValue.serverTimestamp(),
      });
      debugPrint('Riwayat scan tersimpan: $batikDocId');
    } catch (e) {
      debugPrint('_simpanRiwayatScan error: $e');
    }
  }

  Future<void> _captureAndAnalyze() async {
    if (!_isCameraReady) return;
    if (_cameraController == null) return;
    if (!_cameraController!.value.isInitialized) return;
    if (_isAnalyzing) return;

    setState(() {
      _isAnalyzing = true;
      _showResult = false;
      _batikDitemukan = null;
    });

    try {
      final XFile photo = await _cameraController!.takePicture();
      if (!mounted) return;
      setState(() => _capturedImage = photo);

      final result = await _scanService.classifyImage(photo.path);
      if (!mounted) return;

      Map<String, dynamic>? batikData;
      if (result.terdeteksi) {
        batikData = await _fetchBatikByLabel(result.label);
        if (batikData != null) {
          await _simpanRiwayatScan(batikData['docId'] as String);
        }
      }

      if (!mounted) return;
      setState(() {
        _resultLabel = result.label;
        _confidence = result.confidence;
        _batikDitemukan = batikData;
        _isAnalyzing = false;
        _showResult = true;
      });

      debugPrint('=== DEBUG SCAN ===');
      debugPrint('result.label    : "${result.label}"');
      debugPrint('result.terdeteksi: ${result.terdeteksi}');
      debugPrint('result.confidence: ${result.confidence}');
    } catch (e) {
      debugPrint('captureAndAnalyze error: $e');
      if (mounted) setState(() => _isAnalyzing = false);
    }
  }

  void _resetScan() {
    setState(() {
      _capturedImage = null;
      _resultLabel = '';
      _confidence = 0.0;
      _batikDitemukan = null;
      _showResult = false;
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCameraReady || _cameraController == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 16),
              Text(
                'Mempersiapkan kamera...',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          if (_capturedImage == null)
            SizedBox.expand(child: CameraPreview(_cameraController!))
          else
            SizedBox.expand(
              child: Image.file(File(_capturedImage!.path), fit: BoxFit.cover),
            ),
          if (_capturedImage == null && !_isAnalyzing) ...[
            _buildVignette(),
            _buildScanFrame(),
          ],
          if (_isAnalyzing)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Menganalisis batik...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          _buildTopBar(),
          if (_showResult && _batikDitemukan != null) _buildVerifiedBadge(),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _capturedImage == null
                ? _buildCaptureButton()
                : _buildResultCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildVignette() {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.80,
            colors: [Colors.transparent, Colors.black.withOpacity(0.60)],
          ),
        ),
      ),
    );
  }

  Widget _buildScanFrame() {
    const double frameSize = 280;
    return Center(
      child: SizedBox(
        width: frameSize,
        height: frameSize,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: _CornerWidget(isTop: true, isLeft: true, color: _hijauTua),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: _CornerWidget(
                isTop: true,
                isLeft: false,
                color: _hijauTua,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: _CornerWidget(
                isTop: false,
                isLeft: true,
                color: _hijauTua,
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: _CornerWidget(
                isTop: false,
                isLeft: false,
                color: _hijauTua,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.black38,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerifiedBadge() {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.18,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _hijauTua,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.white, size: 18),
              SizedBox(width: 6),
              Text(
                'Batik Terdeteksi',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCaptureButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 48),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.65),
            Colors.black.withOpacity(0.85),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.black38,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Arahkan kamera ke batik',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
          const SizedBox(height: 28),
          GestureDetector(
            onTap: _isAnalyzing ? null : _captureAndAnalyze,
            child: Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: _hijauTua, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: _hijauTua.withOpacity(0.35),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(Icons.camera_alt, size: 36, color: _hijauTua),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Tap untuk memindai',
            style: TextStyle(color: Colors.white60, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard() {
    // Batik tidak terdeteksi atau tidak ditemukan di Firestore
    if (!_showResult || _batikDitemukan == null) {
      return Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 15,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dragHandle(),
            const Icon(Icons.error_outline, size: 48, color: Colors.orange),
            const SizedBox(height: 12),
            const Text(
              'Batik tidak terdeteksi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Persentase Akurasi: ${(_confidence * 100).toStringAsFixed(1)}%',
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: kuning,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _resetScan,
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text(
                'SCAN ULANG',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final data = _batikDitemukan!;

    // Batik berhasil terdeteksi dan ditemukan di Firestore
    return GestureDetector(
      onTap: () => Get.toNamed(
        data['route'] as String,
        arguments:
            data['docId'] as String, // kirim docId ke HasilScanController
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 15,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _dragHandle(),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    data['imagePath'] as String,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 72,
                      height: 72,
                      color: Colors.grey.shade200,
                      child: const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['nama'] as String,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            data['asal'] as String,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Confidence: ${(_confidence * 100).toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black38,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dragHandle() {
    return Container(
      width: 40,
      height: 4,
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

// ── Corner widget (tidak berubah) ─────────────────────────────────
class _CornerWidget extends StatelessWidget {
  final bool isTop;
  final bool isLeft;
  final Color color;

  const _CornerWidget({
    required this.isTop,
    required this.isLeft,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 30,
      child: CustomPaint(
        painter: _CornerPainter(
          isTop: isTop,
          isLeft: isLeft,
          color: color,
          strokeWidth: 4,
          radius: 10,
        ),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final bool isTop, isLeft;
  final Color color;
  final double strokeWidth, radius;

  _CornerPainter({
    required this.isTop,
    required this.isLeft,
    required this.color,
    required this.strokeWidth,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path();
    final w = size.width, h = size.height;

    if (isTop && isLeft) {
      path.moveTo(0, h);
      path.lineTo(0, radius);
      path.arcToPoint(Offset(radius, 0), radius: Radius.circular(radius));
      path.lineTo(w, 0);
    } else if (isTop && !isLeft) {
      path.moveTo(0, 0);
      path.lineTo(w - radius, 0);
      path.arcToPoint(Offset(w, radius), radius: Radius.circular(radius));
      path.lineTo(w, h);
    } else if (!isTop && isLeft) {
      path.moveTo(0, 0);
      path.lineTo(0, h - radius);
      path.arcToPoint(Offset(radius, h), radius: Radius.circular(radius));
      path.lineTo(w, h);
    } else {
      path.moveTo(0, h);
      path.lineTo(w - radius, h);
      path.arcToPoint(Offset(w, h - radius), radius: Radius.circular(radius));
      path.lineTo(w, 0);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_CornerPainter old) => old.color != color;
}
