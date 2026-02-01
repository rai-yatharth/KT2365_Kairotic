import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/employee_input.dart';

class FirebaseService {
  final _db = FirebaseFirestore.instance;

  Future<void> saveInput(EmployeeInput input) async {
    await _db.collection('inputs').add(input.toMap());
  }
}
