/// Per-gender statistics from system-level analysis.
class GenderStats {
  final String gender;
  final int count;
  final double avgMeritScore;
  final double observedOutcomeRate; // % promoted
  final double expectedOutcomeRate;  // % that would be promoted under merit-only

  const GenderStats({
    required this.gender,
    required this.count,
    required this.avgMeritScore,
    required this.observedOutcomeRate,
    required this.expectedOutcomeRate,
  });
}

/// System-level analysis output. Diagnostic signal, not individual verdict.
class SystemAnalysisResult {
  final double distortionIndex; // 0-100%
  final String statusLabel; // Low / Moderate / High distortion
  final List<GenderStats> genderStats;
  final int totalEmployees;
  final int totalPromotions;

  const SystemAnalysisResult({
    required this.distortionIndex,
    required this.statusLabel,
    required this.genderStats,
    required this.totalEmployees,
    required this.totalPromotions,
  });
}
