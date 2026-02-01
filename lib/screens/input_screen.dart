import 'package:flutter/material.dart';
import '../models/employee_input.dart';
import '../services/firebase_service.dart';
import '../services/simulation_engine.dart';
import 'result_screen.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _ownedController = TextEditingController(text: '0');
  final _completedController = TextEditingController(text: '0');
  final _teamSizeController = TextEditingController(text: '0');
  final _selfInitiatedController = TextEditingController(text: '0');

  final _q1Controller = TextEditingController(text: '0');
  final _q2Controller = TextEditingController(text: '0');
  final _q3Controller = TextEditingController(text: '0');

  String _impact = 'Only me';
  bool _isLoading = false;

  void _submit() async {
    // Basic validation
    if (_ownedController.text.isEmpty || 
        _completedController.text.isEmpty || 
        _teamSizeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final input = EmployeeInput(
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

      // Attempt to save to Firebase, but don't let it block navigation if it fails
      try {
        await FirebaseService().saveInput(input).timeout(const Duration(seconds: 3));
      } catch (e) {
        debugPrint('Firebase save failed: $e');
        // We continue anyway so the user can see their results
      }

      // Run calculation
      final result = SimulationEngine().calculatePerformance(
        owned: input.projectsOwned,
        completed: input.projectsCompleted,
        teamSize: input.avgTeamSize,
        projectsPerQuarter: input.projectsPerQuarter,
        selfInitiated: input.selfInitiatedProjects,
        impactBucket: input.impactBucket,
      );

      if (!mounted) return;

      // Go to result screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(result: result),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error running analysis: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Performance Data')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _numberField('Projects Owned', _ownedController),
            _numberField('Projects Completed', _completedController),
            _numberField('Average Team Size', _teamSizeController),

            const SizedBox(height: 12),
            const Text('Projects per Quarter', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
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

            const SizedBox(height: 12),
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
              onChanged: (value) => setState(() => _impact = value!),
            ),

            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading 
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Run Analysis', style: TextStyle(fontSize: 16)),
              ),
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
