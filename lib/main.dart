import 'package:flutter/material.dart';

void main() {
  runApp(const CGPACalculatorApp());
}

class CGPACalculatorApp extends StatelessWidget {
  const CGPACalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CGPA Calculator',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D47A1),
          primary: const Color(0xFF0D47A1),
          secondary: const Color(0xFF64B5F6),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFF0D47A1), width: 2),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0D47A1),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _idController = TextEditingController();

  void _login() {
    if (_idController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CGPACalculator(studentId: _idController.text),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.school, size: 80, color: Color(0xFF0D47A1)),
              const SizedBox(height: 20),
              const Text(
                "University CGPA Calculator",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D47A1),
                ),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: "Enter Student ID",
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 25),
              ElevatedButton(onPressed: _login, child: const Text("Login")),
            ],
          ),
        ),
      ),
    );
  }
}

class CGPACalculator extends StatefulWidget {
  final String studentId;
  const CGPACalculator({super.key, required this.studentId});

  @override
  State<CGPACalculator> createState() => _CGPACalculatorState();
}

class _CGPACalculatorState extends State<CGPACalculator> {
  final List<Map<String, dynamic>> _semesters = [];
  final _semesterController = TextEditingController();
  final _cgpaController = TextEditingController();

  double get averageCGPA {
    if (_semesters.isEmpty) return 0;
    double total = _semesters.fold(0, (sum, item) => sum + item['cgpa']);
    return total / _semesters.length;
  }

  void _addSemester() {
    final name = _semesterController.text;
    final cgpa = double.tryParse(_cgpaController.text);

    if (name.isNotEmpty && cgpa != null) {
      setState(() {
        _semesters.add({'name': name, 'cgpa': cgpa});
        _semesterController.clear();
        _cgpaController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student: ${widget.studentId}"),
        backgroundColor: const Color(0xFF0D47A1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _semesterController,
              decoration: const InputDecoration(
                labelText: "Semester Name",
                prefixIcon: Icon(Icons.calendar_today),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _cgpaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Semester CGPA",
                prefixIcon: Icon(Icons.star_outline),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: _addSemester,
              icon: const Icon(Icons.add),
              label: const Text("Add Semester"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _semesters.length,
                itemBuilder: (context, index) {
                  final s = _semesters[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.bookmark, color: Colors.blue),
                      title: Text(
                        s['name'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      trailing: Text(
                        "CGPA: ${s['cgpa'].toStringAsFixed(2)}",
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFF64B5F6),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                "Average CGPA: ${averageCGPA.toStringAsFixed(2)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
