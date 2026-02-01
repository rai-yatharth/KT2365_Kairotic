import 'employee_input.dart';

/// Represents one employee with merit inputs, gender, and observed outcome.
/// Used for system-level analysis—never for individual blame.
class EmployeeRecord {
  final String id;
  final String gender; // "Male", "Female", "Other"
  final EmployeeInput merit;
  final bool promoted;

  const EmployeeRecord({
    required this.id,
    required this.gender,
    required this.merit,
    required this.promoted,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'gender': gender,
      ...merit.toMap(),
      'promoted': promoted,
    };
  }

  static EmployeeRecord fromMap(Map<String, dynamic> map) {
    return EmployeeRecord(
      id: map['id']?.toString() ?? '',
      gender: map['gender']?.toString() ?? 'Other',
      merit: EmployeeInput(
        projectsOwned: _toInt(map['projectsOwned']),
        projectsCompleted: _toInt(map['projectsCompleted']),
        avgTeamSize: _toInt(map['avgTeamSize']),
        projectsPerQuarter: _toListInt(map['projectsPerQuarter']),
        selfInitiatedProjects: _toInt(map['selfInitiatedProjects']),
        impactBucket: map['impactBucket']?.toString() ?? 'Only me',
        monthsSinceLastPromotion: _toInt(map['monthsSinceLastPromotion']),
        monthsSinceLastGrowth: _toInt(map['monthsSinceLastGrowth']),
        opportunitiesReceived: _toInt(map['opportunitiesReceived']),
      ),
      promoted: map['promoted'] == true,
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static List<int> _toListInt(dynamic value) {
    if (value is List) {
      return value.map((e) => _toInt(e)).toList();
    }
    return [0, 0, 0];
  }
}
