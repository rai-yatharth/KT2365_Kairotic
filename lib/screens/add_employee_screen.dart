import 'package:flutter/material.dart';
import '../models/employee_input.dart';
import '../models/employee_record.dart';

class AddEmployeeScreen extends StatefulWidget {
  const AddEmployeeScreen({super.key});

  @override
  State<AddEmployeeScreen> createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _ownedController = TextEditingController(text: '0');
  final _completedController = TextEditingController(text: '0');
  final _teamSizeController = TextEditingController(text: '0');
  final _selfInitiatedController = TextEditingController(text: '0');
  final _q1Controller = TextEditingController(text: '0');
  final _q2Controller = TextEditingController(text: '0');
  final _q3Controller = TextEditingController(text: '0');

  String _gender = 'Male';
  String _impact = 'Only me';
  bool _promoted = false;

  @override
  void dispose() {
    _ownedController.dispose();
    _completedController.dispose();
    _teamSizeController.dispose();
    _selfInitiatedController.dispose();
    _q1Controller.dispose();
    _q2Controller.dispose();
    _q3Controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_ownedController.text.isEmpty ||
        _completedController.text.isEmpty ||
        _teamSizeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    final merit = EmployeeInput(
      projectsOwned: int.tryParse(_ownedController.text) ?? 0,
      projectsCompleted: int.tryParse(_completedController.text) ?? 0,
      avgTeamSize: int.tryParse(_teamSizeController.text) ?? 0,
      projectsPerQuarter: [
        int.tryParse(_q1Controller.text) ?? 0,
        int.tryParse(_q2Controller.text) ?? 0,
        int.tryParse(_q3Controller.text) ?? 0,
      ],
      selfInitiatedProjects: int.tryParse(_selfInitiatedController.text) ?? 0,
      impactBucket: _impact,
    );

    final record = EmployeeRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      gender: _gender,
      merit: merit,
      promoted: _promoted,
    );

    Navigator.pop(context, record);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Employee')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              value: _gender,
              decoration: const InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Male', child: Text('Male')),
                DropdownMenuItem(value: 'Female', child: Text('Female')),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
              onChanged: (v) => setState(() => _gender = v!),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Promoted'),
              value: _promoted,
              onChanged: (v) => setState(() => _promoted = v),
            ),
            const SizedBox(height: 12),
            _numberField('Projects Owned', _ownedController),
            _numberField('Projects Completed', _completedController),
            _numberField('Average Team Size', _teamSizeController),
            const SizedBox(height: 8),
            const Text('Projects per Quarter', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(child: _numberField('Q1', _q1Controller)),
                const SizedBox(width: 8),
                Expanded(child: _numberField('Q2', _q2Controller)),
                const SizedBox(width: 8),
                Expanded(child: _numberField('Q3', _q3Controller)),
              ],
            ),
            _numberField('Self-Initiated Projects', _selfInitiatedController),
            DropdownButtonFormField<String>(
              value: _impact,
              decoration: const InputDecoration(
                labelText: 'Impact Scope',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Only me', child: Text('Only me')),
                DropdownMenuItem(value: 'My team', child: Text('My team')),
                DropdownMenuItem(value: 'Multiple teams', child: Text('Multiple teams')),
                DropdownMenuItem(value: 'External users', child: Text('External users')),
              ],
              onChanged: (v) => setState(() => _impact = v!),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Add Employee'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _numberField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
