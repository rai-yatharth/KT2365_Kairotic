import '../models/analysis_result.dart';
import '../models/employee_input.dart';
import '../models/performance_result.dart';

class _Baselines {
  static const double eP = 24;
  static const double eG = 12;
  static const double eO = 5;
  static const double basePromotionRate = 0.20;
  static const double minPromotionProb = 0.05;
  static const double maxPromotionProb = 0.60;
}

class SimulationEngine {
  /// Merit from original formula. Reused everywhere.
  double _computeMerit(EmployeeInput input) {
    final delivery = input.projectsOwned == 0 ? 0.0 : input.projectsCompleted / input.projectsOwned;
    final complexity = (input.avgTeamSize / 10).clamp(0.0, 1.0);
    double consistency = 1.0;
    if (input.projectsPerQuarter.isNotEmpty) {
      final avg = input.projectsPerQuarter.reduce((a, b) => a + b) / input.projectsPerQuarter.length;
      final variance = input.projectsPerQuarter
          .map((e) => (e - avg) * (e - avg))
          .reduce((a, b) => a + b) /
          input.projectsPerQuarter.length;
      consistency = (1 / (1 + variance)).clamp(0.0, 1.0);
    }
    final initiative = input.selfInitiatedProjects > 0 ? 1.0 : 0.0;
    const impactMap = {'Only me': 0.2, 'My team': 0.4, 'Multiple teams': 0.7, 'External users': 1.0};
    final impact = impactMap[input.impactBucket] ?? 0.2;
    return (0.30 * delivery + 0.25 * complexity + 0.20 * consistency + 0.15 * initiative + 0.10 * impact).clamp(0.0, 1.0);
  }

  /// Full analysis: merit (original formula) + structural friction + ideal/real/distortion.
  AnalysisResult analyze(EmployeeInput input) {
    final merit = _computeMerit(input);

    final tP = input.monthsSinceLastPromotion.toDouble();
    final tG = input.monthsSinceLastGrowth.toDouble();
    final oR = input.opportunitiesReceived.toDouble();

    final promotionDelay = ((tP / _Baselines.eP) / 1.5).clamp(0.0, 1.0);
    final growthDelay = ((tG / _Baselines.eG) / 1.5).clamp(0.0, 1.0);
    final opportunityGap = (1 - (oR / _Baselines.eO).clamp(0.0, 1.0)).clamp(0.0, 1.0);

    final structuralFriction = (0.4 * promotionDelay + 0.4 * growthDelay + 0.2 * opportunityGap).clamp(0.0, 1.0);

    final idealScore = merit;
    final realScore = (merit * (1 - structuralFriction)).clamp(0.0, 1.0);
    final distortion = (idealScore - realScore).clamp(0.0, 1.0);

    var idealPromoProb = _Baselines.basePromotionRate * (0.5 + merit);
    idealPromoProb = idealPromoProb.clamp(_Baselines.minPromotionProb, _Baselines.maxPromotionProb);
    var realPromoProb = idealPromoProb * (1 - structuralFriction);
    realPromoProb = realPromoProb.clamp(_Baselines.minPromotionProb, _Baselines.maxPromotionProb);

    return AnalysisResult(
      merit: merit,
      structuralFriction: structuralFriction,
      idealScore: idealScore,
      realScore: realScore,
      distortion: distortion,
      idealPromotionProbability: idealPromoProb,
      realPromotionProbability: realPromoProb,
    );
  }

  PerformanceResult calculatePerformance({
    required int owned,
    required int completed,
    required int teamSize,
    required List<int> projectsPerQuarter,
    required int selfInitiated,
    required String impactBucket,
  }) {
    final input = EmployeeInput(
      projectsOwned: owned,
      projectsCompleted: completed,
      avgTeamSize: teamSize,
      projectsPerQuarter: projectsPerQuarter,
      selfInitiatedProjects: selfInitiated,
      impactBucket: impactBucket,
    );
    final merit = _computeMerit(input);
    final delivery = owned == 0 ? 0.0 : completed / owned;
    final complexity = (teamSize / 10).clamp(0.0, 1.0);
    double consistency = 1.0;
    if (projectsPerQuarter.isNotEmpty) {
      final avg = projectsPerQuarter.reduce((a, b) => a + b) / projectsPerQuarter.length;
      final variance = projectsPerQuarter.map((e) => (e - avg) * (e - avg)).reduce((a, b) => a + b) / projectsPerQuarter.length;
      consistency = (1 / (1 + variance)).clamp(0.0, 1.0);
    }
    final initiative = selfInitiated > 0 ? 1.0 : 0.0;
    const impactMap = {'Only me': 0.2, 'My team': 0.4, 'Multiple teams': 0.7, 'External users': 1.0};
    final impact = impactMap[impactBucket] ?? 0.2;
    return PerformanceResult(
      overallScore: merit,
      delivery: delivery,
      complexity: complexity,
      consistency: consistency,
      initiative: initiative,
      impact: impact,
    );
  }
}
