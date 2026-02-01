/// Holds the overall score and component breakdown for visualization.
class PerformanceResult {
  final double overallScore;
  final double delivery;      // 0-1, weight 30%
  final double complexity;    // 0-1, weight 25%
  final double consistency;   // 0-1, weight 20%
  final double initiative;    // 0-1, weight 15%
  final double impact;        // 0-1, weight 10%

  const PerformanceResult({
    required this.overallScore,
    required this.delivery,
    required this.complexity,
    required this.consistency,
    required this.initiative,
    required this.impact,
  });
}
