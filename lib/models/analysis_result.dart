/// Result of merit + structural friction analysis.
class AnalysisResult {
  final double merit;
  final double structuralFriction;
  final double idealScore;
  final double realScore;
  final double distortion;
  final double idealPromotionProbability;
  final double realPromotionProbability;

  const AnalysisResult({
    required this.merit,
    required this.structuralFriction,
    required this.idealScore,
    required this.realScore,
    required this.distortion,
    required this.idealPromotionProbability,
    required this.realPromotionProbability,
  });
}
