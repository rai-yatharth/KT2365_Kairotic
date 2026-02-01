import '../models/performance_result.dart';

class SimulationEngine {
  PerformanceResult calculatePerformance({
    required int owned,
    required int completed,
    required int teamSize,
    required List<int> projectsPerQuarter,
    required int selfInitiated,
    required String impactBucket,
  }) {
    // 1. Project Delivery
    final delivery = owned == 0 ? 0.0 : completed / owned;

    // 2. Scope Complexity
    final complexity = (teamSize / 10).clamp(0.0, 1.0);

    // 3. Consistency
    double consistency = 1.0;
    if (projectsPerQuarter.isNotEmpty) {
      final avg = projectsPerQuarter.reduce((a, b) => a + b) /
          projectsPerQuarter.length;
      final variance = projectsPerQuarter
          .map((e) => (e - avg) * (e - avg))
          .reduce((a, b) => a + b) /
          projectsPerQuarter.length;
      consistency = (1 / (1 + variance)).clamp(0.0, 1.0);
    }

    // 4. Initiative
    final initiative = selfInitiated > 0 ? 1.0 : 0.0;

    // 5. Impact
    final impactMap = {
      'Only me': 0.2,
      'My team': 0.4,
      'Multiple teams': 0.7,
      'External users': 1.0,
    };
    final impact = impactMap[impactBucket] ?? 0.2;

    // Final weighted score
    final overallScore = (0.30 * delivery) +
        (0.25 * complexity) +
        (0.20 * consistency) +
        (0.15 * initiative) +
        (0.10 * impact);

    return PerformanceResult(
      overallScore: overallScore.clamp(0.0, 1.0),
      delivery: delivery,
      complexity: complexity,
      consistency: consistency,
      initiative: initiative,
      impact: impact,
    );
  }
}
