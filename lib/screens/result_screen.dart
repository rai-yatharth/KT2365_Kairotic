import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/performance_result.dart';

class ResultScreen extends StatelessWidget {
  final PerformanceResult result;

  const ResultScreen({super.key, required this.result});

  String get explanation {
    final score = result.overallScore;
    if (score < 0.4) {
      return 'Promotion outcomes closely align with merit-based evaluation. '
          'Low indication of systemic distortion.';
    } else if (score < 0.7) {
      return 'Some divergence detected between merit-based expectations '
          'and observed outcomes. Further review recommended.';
    } else {
      return 'Significant divergence detected. Observed outcomes differ '
          'strongly from merit-based expectations.';
    }
  }

  Color get scoreColor {
    final score = result.overallScore;
    if (score < 0.4) return const Color(0xFF4CAF50);
    if (score < 0.7) return const Color(0xFFFF9800);
    return const Color(0xFFE53935);
  }

  static const _componentColors = [
    Color(0xFF2196F3), // Delivery - blue
    Color(0xFF9C27B0), // Complexity - purple
    Color(0xFF00BCD4), // Consistency - cyan
    Color(0xFFFF5722), // Initiative - deep orange
    Color(0xFF8BC34A), // Impact - light green
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Analysis Result',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildOverallScoreCard(context),
            const SizedBox(height: 24),
            _buildComponentBreakdownCard(context),
            const SizedBox(height: 24),
            _buildExplanationCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallScoreCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Overall Merit Alignment Score',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 180,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      sectionsSpace: 0,
                      centerSpaceRadius: 55,
                      sections: [
                        PieChartSectionData(
                          value: result.overallScore.clamp(0.0, 1.0),
                          color: scoreColor,
                          showTitle: false,
                          radius: 50,
                        ),
                        PieChartSectionData(
                          value: (1 - result.overallScore).clamp(0.0, 1.0),
                          color: Colors.grey.shade200,
                          showTitle: false,
                          radius: 50,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        (result.overallScore * 100).toStringAsFixed(0),
                        style: GoogleFonts.inter(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: scoreColor,
                        ),
                      ),
                      Text(
                        '/ 100',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComponentBreakdownCard(BuildContext context) {
    final components = [
      ('Delivery', result.delivery, '30%'),
      ('Complexity', result.complexity, '25%'),
      ('Consistency', result.consistency, '20%'),
      ('Initiative', result.initiative, '15%'),
      ('Impact', result.impact, '10%'),
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Component Breakdown',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 220,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 1.0,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final labels = [
                            'Delivery',
                            'Complexity',
                            'Consistency',
                            'Initiative',
                            'Impact',
                          ];
                          final idx = value.toInt();
                          if (idx >= 0 && idx < labels.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                labels[idx],
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                        reservedSize: 28,
                        interval: 1,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) => Text(
                          value == 1 ? '1.0' : value.toStringAsFixed(1),
                          style: GoogleFonts.inter(fontSize: 10),
                        ),
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 0.25,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.shade300,
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: components
                      .asMap()
                      .map(
                        (i, c) => MapEntry(
                          i,
                          BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: c.$2,
                                color: _componentColors[i],
                                width: 24,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(6),
                                ),
                                backDrawRodData: BackgroundBarChartRodData(
                                  show: true,
                                  toY: 1.0,
                                  color: Colors.grey.shade200,
                                ),
                              ),
                            ],
                            showingTooltipIndicators: [0],
                          ),
                        ),
                      )
                      .values
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ...components.asMap().entries.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _componentColors[e.key],
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${e.value.$1} ${e.value.$3}',
                            style: GoogleFonts.inter(fontSize: 12),
                          ),
                        ),
                        Text(
                          (e.value.$2 * 100).toStringAsFixed(0) + '%',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
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

  Widget _buildExplanationCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Interpretation',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              explanation,
              style: GoogleFonts.inter(
                fontSize: 14,
                height: 1.5,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              'How this was calculated',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '• Real world outcomes were compared against a merit-only evaluation.\n'
              '• Gender was excluded from scoring and used only for analysis.\n'
              '• The score represents the degree of divergence between the two.',
              style: GoogleFonts.inter(
                fontSize: 13,
                height: 1.5,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
