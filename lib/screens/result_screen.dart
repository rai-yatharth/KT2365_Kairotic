import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/analysis_result.dart';
import '../services/firebase_service.dart';

class ResultScreen extends StatefulWidget {
  final AnalysisResult result;
  final String? employeeId;

  const ResultScreen({super.key, required this.result, this.employeeId});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final _commentController = TextEditingController();
  bool _isSending = false;

  String _pct(double v) => '${(v * 100).toStringAsFixed(1)}%';

  Future<void> _sendFeedback() async {
    if (_commentController.text.trim().isEmpty || widget.employeeId == null) return;
    setState(() => _isSending = true);
    try {
      await FirebaseService().saveFeedback(widget.employeeId!, _commentController.text.trim());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message sent to HR successfully.'), backgroundColor: Colors.green),
      );
      _commentController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send message.'), backgroundColor: Colors.redAccent),
      );
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Analysis Result', style: TextStyle(color: Colors.redAccent)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.redAccent),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildScoreCard(),
            const SizedBox(height: 32),
            const Text(
              'GROWTH TRAJECTORY',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2),
            ),
            const SizedBox(height: 24),
            _buildNeonLineChart(),
            const SizedBox(height: 32),
            _buildPromotionComparison(),
            const SizedBox(height: 32),
            _distortionBox(),
            if (widget.employeeId != null) _buildFeedbackSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard() {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _section('Merit Score', widget.result.merit),
            _section('Structural Friction', widget.result.structuralFriction),
          ],
        ),
      ),
    );
  }

  Widget _section(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
          Text(_pct(value), style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildNeonLineChart() {
    return Container(
      height: 250,
      padding: const EdgeInsets.only(right: 20, top: 10),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(color: Colors.white10, strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value == 0) return const Text('PAST', style: TextStyle(color: Colors.white54, fontSize: 10));
                  if (value == 1) return const Text('PRESENT', style: TextStyle(color: Colors.white54, fontSize: 10));
                  return const SizedBox();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 0.2,
                getTitlesWidget: (value, meta) => Text('${(value * 100).toInt()}%', style: const TextStyle(color: Colors.white54, fontSize: 10)),
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0, maxX: 1, minY: 0, maxY: 1,
          lineBarsData: [
            LineChartBarData(
              spots: [const FlSpot(0, 0), FlSpot(1, widget.result.idealScore)],
              isCurved: true,
              color: Colors.cyanAccent,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(show: true, color: Colors.cyanAccent.withOpacity(0.1)),
            ),
            LineChartBarData(
              spots: [const FlSpot(0, 0), FlSpot(1, widget.result.realScore)],
              isCurved: true,
              color: Colors.redAccent,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(show: true, color: Colors.redAccent.withOpacity(0.1)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromotionComparison() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.grey[900], borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 12, height: 12, color: Colors.cyanAccent),
              const SizedBox(width: 8),
              const Text('IDEAL CONDITION', style: TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(width: 12, height: 12, color: Colors.redAccent),
              const SizedBox(width: 8),
              const Text('REAL CONDITION', style: TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 24),
          const Text('PROMOTION PROBABILITY', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _row('Ideal (Merit-Only)', _pct(widget.result.idealPromotionProbability)),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: widget.result.idealPromotionProbability, backgroundColor: Colors.white10, color: Colors.cyanAccent),
          const SizedBox(height: 16),
          _row('Real (Systemic)', _pct(widget.result.realPromotionProbability)),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: widget.result.realPromotionProbability, backgroundColor: Colors.white10, color: Colors.redAccent),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70)),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _distortionBox() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.1),
        border: Border.all(color: Colors.redAccent, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          const Text('SYSTEM DISTORTION', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(_pct(widget.result.distortion), style: const TextStyle(color: Colors.redAccent, fontSize: 40, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildFeedbackSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 40),
        const Text('CONVEY DISSATISFACTION TO HR', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent)),
        const SizedBox(height: 12),
        TextField(
          controller: _commentController,
          maxLines: 4,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Describe your concerns...',
            hintStyle: const TextStyle(color: Colors.white24),
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: _isSending ? null : _sendFeedback,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.black),
          child: _isSending ? const CircularProgressIndicator(color: Colors.black) : const Text('SEND TO HR', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
