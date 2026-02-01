import '../models/employee_record.dart';
import '../models/system_analysis_result.dart';
import 'simulation_engine.dart';

/// Performs system-level analysis: compares observed outcomes to merit-only
/// expected outcomes across gender groups. Deterministic, rule-based.
class SystemAnalyzer {
  final _simulation = SimulationEngine();

  /// Analyzes a set of employees and produces a system distortion index.
  /// Does not evaluate individuals—detects group-level patterns.
  SystemAnalysisResult analyze(List<EmployeeRecord> employees) {
    if (employees.isEmpty) {
      return const SystemAnalysisResult(
        distortionIndex: 0,
        statusLabel: 'Insufficient data',
        genderStats: [],
        totalEmployees: 0,
        totalPromotions: 0,
      );
    }

    // 1. Compute merit score for each employee
    final scored = employees.map((e) {
      final perf = _simulation.calculatePerformance(
        owned: e.merit.projectsOwned,
        completed: e.merit.projectsCompleted,
        teamSize: e.merit.avgTeamSize,
        projectsPerQuarter: e.merit.projectsPerQuarter,
        selfInitiated: e.merit.selfInitiatedProjects,
        impactBucket: e.merit.impactBucket,
      );
      return (record: e, meritScore: perf.overallScore);
    }).toList();

    final totalPromotions = employees.where((e) => e.promoted).length;

    // 2. Merit-only simulation: rank by merit, award promotions to top K
    scored.sort((a, b) => b.meritScore.compareTo(a.meritScore));
    final promotionSlots = totalPromotions.clamp(0, scored.length);
    final wouldBePromoted = <EmployeeRecord>{};
    for (var i = 0; i < promotionSlots; i++) {
      wouldBePromoted.add(scored[i].record);
    }

    // 3. Group by gender
    final genderGroups = <String, List<({EmployeeRecord record, double merit})>>{};
    for (final s in scored) {
      genderGroups.putIfAbsent(s.record.gender, () => []).add((record: s.record, merit: s.meritScore));
    }

    // 4. Compute stats per gender
    final genderStats = <GenderStats>[];
    for (final entry in genderGroups.entries) {
      final list = entry.value;
      final count = list.length;
      final avgMerit = list.map((s) => s.merit).reduce((a, b) => a + b) / count;
      final observed = list.where((s) => s.record.promoted).length / count;
      final expected = list.where((s) => wouldBePromoted.contains(s.record)).length / count;
      genderStats.add(GenderStats(
        gender: entry.key,
        count: count,
        avgMeritScore: avgMerit,
        observedOutcomeRate: observed,
        expectedOutcomeRate: expected,
      ));
    }

    // 5. System distortion index: average absolute gap across genders
    final avgAbsGap = genderStats.isEmpty
        ? 0.0
        : genderStats.map((g) => (g.observedOutcomeRate - g.expectedOutcomeRate).abs()).reduce((a, b) => a + b) / genderStats.length;
    final distortionIndex = (avgAbsGap * 100).clamp(0.0, 100.0);

    // 6. Status label
    final statusLabel = distortionIndex < 15
        ? 'Low distortion'
        : distortionIndex < 40
            ? 'Moderate distortion'
            : 'High distortion';

    return SystemAnalysisResult(
      distortionIndex: distortionIndex,
      statusLabel: statusLabel,
      genderStats: genderStats,
      totalEmployees: employees.length,
      totalPromotions: totalPromotions,
    );
  }
}
