import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class RoboflowResult {
  final String label;      
  final double confidence;
  final bool terdeteksi;

  const RoboflowResult({
    required this.label,
    required this.confidence,
    required this.terdeteksi,
  });
}

class ScanService {
  static const String _apiKey = 'VycL1nf0RwhI2mPyMy0i';
  static const String _workspaceId = 'rizzas-workspace';
  static const String _workflowId = 'detect-and-classify-2';

  static const String _modelUrl =
      'https://detect.roboflow.com/infer/workflows/$_workspaceId/$_workflowId';

  static const double _threshold = 0.2;

  Future<RoboflowResult> classifyImage(String imagePath) async {
    try {
      final bytes = await File(imagePath).readAsBytes();
      final base64Image = base64Encode(bytes);

      final requestBody = jsonEncode({
        'api_key': _apiKey,
        'inputs': {
          'image': {'type': 'base64', 'value': base64Image},
        },
      });

      final response = await http
          .post(
            Uri.parse(_modelUrl),
            headers: {'Content-Type': 'application/json'},
            body: requestBody,
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('Request timeout'),
          );

      debugPrint('Response status: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }

      final result = jsonDecode(response.body) as Map<String, dynamic>;
      final outputs = result['outputs'] as List<dynamic>;
      final modelOutput =
          outputs[0]['classification_model_output'] as Map<String, dynamic>;

      final rawLabel = (modelOutput['top'] as String).toLowerCase().trim();
      final label = rawLabel;

      final confidence = (modelOutput['confidence'] as num).toDouble();

      debugPrint(
        'Roboflow: $rawLabel → label: "$label" '
        '(${(confidence * 100).toStringAsFixed(1)}%)',
      );

      return RoboflowResult(
        label: label,
        confidence: confidence,
        terdeteksi: confidence >= _threshold,
      );
    } catch (e) {
      debugPrint('ScanService error: $e');
      return const RoboflowResult(
        label: '',
        confidence: 0.0,
        terdeteksi: false,
      );
    }
  }
}
