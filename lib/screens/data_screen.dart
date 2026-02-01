import 'package:flutter/material.dart';
import '../data/mock_employees.dart';
import '../models/employee_record.dart';
import '../services/simulation_engine.dart';
import '../services/system_analyzer.dart';
import 'add_employee_screen.dart';
import 'result_screen.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  late List<EmployeeRecord> _employees;

  @override
  void initState() {
    super.initState();
    _employees = List.from(getMockEmployees());
  }

  Future<void> _addEmployee() async {
    final added = await Navigator.push<EmployeeRecord>(
      context,
      MaterialPageRoute(builder: (_) => const AddEmployeeScreen()),
    );
    if (added != null && mounted) {
      setState(() => _employees.add(added));
    }
  }

  void _runAnalysis() {
    final result = SystemAnalyzer().analyze(_employees);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(result: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sim = SimulationEngine();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Dataset'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addEmployee,
            tooltip: 'Add employee',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '${_employees.length} employees in dataset. Run analysis to detect system-level patterns.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _employees.length,
              itemBuilder: (context, i) {
                final e = _employees[i];
                final perf = sim.calculatePerformance(
                  owned: e.merit.projectsOwned,
                  completed: e.merit.projectsCompleted,
                  teamSize: e.merit.avgTeamSize,
                  projectsPerQuarter: e.merit.projectsPerQuarter,
                  selfInitiated: e.merit.selfInitiatedProjects,
                  impactBucket: e.merit.impactBucket,
                );
                final merit = perf.overallScore;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text('${e.gender} • Merit ${merit.toStringAsFixed(2)}'),
                    subtitle: Text(e.promoted ? 'Promoted ✓' : 'Not promoted'),
                    trailing: Icon(
                      e.promoted ? Icons.arrow_upward : Icons.remove,
                      color: e.promoted ? Colors.green : Colors.grey,
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _runAnalysis,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                ),
                child: const Text('Run System Analysis'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
