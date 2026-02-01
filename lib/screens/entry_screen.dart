import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../services/simulation_engine.dart';
import 'input_screen.dart';
import 'result_screen.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  bool _isLoading = false;

  void _showIdDialog(BuildContext context, {required bool isHR}) {
    final TextEditingController idController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          isHR ? 'HR Portal' : 'Employee Portal',
          style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter Employee ID',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: idController,
              autofocus: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.redAccent)),
                hintText: 'e.g. emp_001',
                hintStyle: TextStyle(color: Colors.white24),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.black,
            ),
            onPressed: () async {
              final id = idController.text.trim();
              if (id.isEmpty) return;
              Navigator.pop(context);

              if (isHR) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => InputScreen(employeeId: id)),
                );
              } else {
                setState(() => _isLoading = true);
                try {
                  final data = await FirebaseService().fetchEmployeeById(id);
                  if (data != null) {
                    final result = SimulationEngine().analyze(data);
                    if (!mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ResultScreen(result: result, employeeId: id),
                      ),
                    );
                  } else {
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Employee ID not found'),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
                  );
                } finally {
                  if (mounted) setState(() => _isLoading = false);
                }
              }
            },
            child: const Text('CONFIRM', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Darpan',
                    style: TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                      letterSpacing: 4,
                      shadows: [
                        Shadow(blurRadius: 10, color: Colors.red, offset: Offset(2, 2)),
                      ],
                    ),
                  ),
                  const Text(
                    'THE MIRROR WORLD',
                    style: TextStyle(color: Colors.white54, letterSpacing: 2),
                  ),
                  const SizedBox(height: 80),
                  _buildEntryButton(
                    text: 'Employee',
                    onPressed: () => _showIdDialog(context, isHR: false),
                  ),
                  const SizedBox(height: 24),
                  _buildEntryButton(
                    text: 'HR',
                    onPressed: () => _showIdDialog(context, isHR: true),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.redAccent),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEntryButton({required String text, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.redAccent,
        side: const BorderSide(color: Colors.redAccent, width: 2),
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.2),
      ),
    );
  }
}
