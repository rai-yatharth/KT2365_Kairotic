import 'package:flutter/material.dart';
import '../models/employee_input.dart';
import '../services/firebase_service.dart';
import '../services/simulation_engine.dart';
import 'result_screen.dart';

class InputScreen extends StatefulWidget {
  final String employeeId;

  const InputScreen({super.key, required this.employeeId});

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
  final _monthsPromoController = TextEditingController(text: '0');
  final _monthsGrowthController = TextEditingController(text: '0');
  final _opportunitiesController = TextEditingController(text: '0');

  String _impact = 'Only me';
  bool _isLoading = false;

  void _submit() async {
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
        monthsSinceLastPromotion: int.tryParse(_monthsPromoController.text) ?? 0,
        monthsSinceLastGrowth: int.tryParse(_monthsGrowthController.text) ?? 0,
        opportunitiesReceived: int.tryParse(_opportunitiesController.text) ?? 0,
      );

      try {
        await FirebaseService().saveEmployeeData(widget.employeeId, input.toMap()).timeout(const Duration(seconds: 3));
      } catch (e) {
        debugPrint('Firebase save failed: $e');
      }

      final result = SimulationEngine().analyze(input);

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultScreen(result: result, employeeId: widget.employeeId),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Enter Performance Data', style: TextStyle(color: Colors.redAccent)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.redAccent),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: Colors.redAccent,
            colorScheme: const ColorScheme.dark(primary: Colors.redAccent),
            inputDecorationTheme: const InputDecorationTheme(
              labelStyle: TextStyle(color: Colors.redAccent),
              enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
              focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
            ),
          ),
          child: Column(
            children: [
              _numberField('Projects Owned', _ownedController),
              _numberField('Projects Completed', _completedController),
              _numberField('Average Team Size', _teamSizeController),
              const SizedBox(height: 12),
              const Text('Projects per Quarter', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
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
                dropdownColor: Colors.grey[900],
                style: const TextStyle(color: Colors.white),
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
              const SizedBox(height: 20),
              const Text('Promotion & growth', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 8),
              _numberField('Months since last promotion', _monthsPromoController),
              _numberField('Months since last growth / raise', _monthsGrowthController),
              _numberField('Opportunities received', _opportunitiesController),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, foregroundColor: Colors.black),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text('Run Analysis', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
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
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }
}
