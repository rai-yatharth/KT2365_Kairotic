import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/employee_input.dart';

class FirebaseService {
  final _db = FirebaseFirestore.instance;

  Future<void> saveInput(EmployeeInput input) async {
    await _db.collection('inputs').add(input.toMap());
  }

  Future<EmployeeInput?> fetchEmployeeById(String id) async {
    final doc = await _db.collection('employees').doc(id).get();
    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      return EmployeeInput(
        projectsOwned: data['projectsOwned'] ?? 0,
        projectsCompleted: data['projectsCompleted'] ?? 0,
        avgTeamSize: data['avgTeamSize'] ?? 0,
        projectsPerQuarter: List<int>.from(data['projectsPerQuarter'] ?? [0, 0, 0]),
        selfInitiatedProjects: data['selfInitiatedProjects'] ?? 0,
        impactBucket: data['impactBucket'] ?? 'Only me',
        monthsSinceLastPromotion: data['monthsSinceLastPromotion'] ?? 0,
        monthsSinceLastGrowth: data['monthsSinceLastGrowth'] ?? 0,
        opportunitiesReceived: data['opportunitiesReceived'] ?? 0,
      );
    }
    return null;
  }

  Future<void> saveEmployeeData(String id, Map<String, dynamic> data) async {
    await _db.collection('employees').doc(id).set(data, SetOptions(merge: true));
  }

  Future<void> saveFeedback(String id, String message) async {
    await _db.collection('employees').doc(id).set({
      'feedback': message,
      'feedbackTimestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
