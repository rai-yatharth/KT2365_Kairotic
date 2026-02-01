class EmployeeInput {
  final int projectsOwned;
  final int projectsCompleted;
  final int avgTeamSize;
  final List<int> projectsPerQuarter;
  final int selfInitiatedProjects;
  final String impactBucket; // "Only me", "My team", etc.

  EmployeeInput({
    required this.projectsOwned,
    required this.projectsCompleted,
    required this.avgTeamSize,
    required this.projectsPerQuarter,
    required this.selfInitiatedProjects,
    required this.impactBucket,
  });

  Map<String, dynamic> toMap() {
    return {
      'projectsOwned': projectsOwned,
      'projectsCompleted': projectsCompleted,
      'avgTeamSize': avgTeamSize,
      'projectsPerQuarter': projectsPerQuarter,
      'selfInitiatedProjects': selfInitiatedProjects,
      'impactBucket': impactBucket,
    };
  }
}
