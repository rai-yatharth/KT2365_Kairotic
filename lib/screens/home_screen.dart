import 'package:flutter/material.dart';
import 'input_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
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
              const SizedBox(height: 8),
              const Text(
                'A mirror for promotion fairness',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const InputScreen(employeeId: 'temp_id'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.redAccent,
                  side: const BorderSide(color: Colors.redAccent, width: 2),
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text(
                  'RUN MIRROR ANALYSIS',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
