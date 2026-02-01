import 'package:flutter/material.dart';
import '../models/analysis_result.dart';

class ResultScreen extends StatelessWidget {
  final AnalysisResult result;

  const ResultScreen({super.key, required this.result});

  String _pct(double v) => '${(v * 100).toStringAsFixed(1)}%';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analysis Result')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _section('Merit Score', result.merit),
            _section('Structural Friction', result.structuralFriction),
            const Divider(height: 32),
            const Text('Ideal vs Real Score', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _row('Ideal Score', _pct(result.idealScore)),
            _row('Real Score', _pct(result.realScore)),
            const SizedBox(height: 16),
            _section('Distortion', result.distortion),
            const Divider(height: 32),
            const Text('Promotion Probability', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _row('Ideal', _pct(result.idealPromotionProbability)),
            _row('Real', _pct(result.realPromotionProbability)),
          ],
        ),
      ),
    );
  }

  Widget _section(String label, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(_pct(value), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text(value, style: const TextStyle(fontWeight: FontWeight.w600))],
      ),
    );
  }
}
