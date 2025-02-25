import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Калькулятор викидів',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _qiController = TextEditingController();
  final TextEditingController _aVivController = TextEditingController();
  final TextEditingController _arController = TextEditingController();
  final TextEditingController _gVivController = TextEditingController();
  final TextEditingController _etaLuzController = TextEditingController();
  final TextEditingController _kMsController = TextEditingController();
  final TextEditingController _bController = TextEditingController();

  double? emissionResult;
  double? grossEmissionResult;

  double calculateEmission(
      double Qi, double a_viv, double Ar, double G_viv, double eta_luz, double k_ms) {
    double factor1 = 1000000 / Qi;
    double factor2 = a_viv * (Ar / (100 - G_viv)) * (1 - eta_luz);
    return factor1 * factor2 + k_ms;
  }

  double calculateGrossEmission(double ktv, double Qi, double B) {
    return 1e-6 * ktv * Qi * B;
  }

  bool areInputsValid() {
    return _qiController.text.isNotEmpty &&
        _aVivController.text.isNotEmpty &&
        _arController.text.isNotEmpty &&
        _gVivController.text.isNotEmpty &&
        _etaLuzController.text.isNotEmpty &&
        _kMsController.text.isNotEmpty &&
        _bController.text.isNotEmpty;
  }

  void calculate() {
    if (areInputsValid()) {
      double qi = double.parse(_qiController.text);
      double aViv = double.parse(_aVivController.text);
      double ar = double.parse(_arController.text);
      double gViv = double.parse(_gVivController.text);
      double etaLuz = double.parse(_etaLuzController.text);
      double kMs = double.parse(_kMsController.text);
      double b = double.parse(_bController.text);

      double emission = calculateEmission(qi, aViv, ar, gViv, etaLuz, kMs);
      double grossEmission = calculateGrossEmission(emission, qi, b);

      setState(() {
        emissionResult = emission;
        grossEmissionResult = grossEmission;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Будь ласка, заповніть всі поля')),
      );
    }
  }

  @override
  void dispose() {
    _qiController.dispose();
    _aVivController.dispose();
    _arController.dispose();
    _gVivController.dispose();
    _etaLuzController.dispose();
    _kMsController.dispose();
    _bController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Калькулятор викидів"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Калькулятор викидів",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            TextField(
              controller: _qiController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Q'_i (Qi)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _aVivController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "a_вив (a_viv)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _arController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "A^r (Ar)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _gVivController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Г_вив (G_viv)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _etaLuzController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "η_луз (eta_luz)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _kMsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "k_мс (k_ms)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _bController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "B (Маса палива)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: calculate,
              child: Text("Обчислити"),
            ),
            SizedBox(height: 16),
            if (emissionResult != null)
              Text("Показник емісії: ${emissionResult.toString()}"),
            SizedBox(height: 8),
            if (grossEmissionResult != null)
              Text("Валові викиди: ${grossEmissionResult.toString()}"),
          ],
        ),
      ),
    );
  }
}
