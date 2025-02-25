import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SolarCalculatorApp());
  }
}

class SolarCalculatorApp extends StatefulWidget {
  @override
  _SolarCalculatorAppState createState() => _SolarCalculatorAppState();
}

class _SolarCalculatorAppState extends State<SolarCalculatorApp> {
  TextEditingController pcController = TextEditingController();
  TextEditingController energyPriceController = TextEditingController();
  TextEditingController sigmaController = TextEditingController();
  String revenue = "";
  String fine = "";
  String profit = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Solar Calculator")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: pcController,
                decoration: InputDecoration(labelText: "Середньодобова потужність, Pc (МВт)"),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 8),
              TextField(
                controller: energyPriceController,
                decoration: InputDecoration(labelText: "Вартість електроенергії, В (грн/кВт*год)"),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 8),
              TextField(
                controller: sigmaController,
                decoration: InputDecoration(labelText: "Cередньоквадратичне відхилення, σ"),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  double powerAverage = double.tryParse(pcController.text) ?? 0.0;
                  double price = double.tryParse(energyPriceController.text) ?? 0.0;
                  double deviation = double.tryParse(sigmaController.text) ?? 0.0;
                  double noImbalancesEnergyShare = integration(powerAverage, 5000, deviation);
                  double _revenue = powerAverage * 24 * noImbalancesEnergyShare * price;
                  double _fine = powerAverage * 24 * (1 - noImbalancesEnergyShare) * price;
                  double _profit = _revenue - _fine;
                  setState(() {
                    revenue = _revenue.toString();
                    fine = _fine.toString();
                    profit = _profit.toString();
                  });
                },
                child: Text("Обчислити"),
              ),
              SizedBox(height: 16),
              Text("Дохід: " + revenue),
              SizedBox(height: 8),
              Text("Штраф: " + fine),
              SizedBox(height: 8),
              Text("Прибуток: " + profit),
              SizedBox(height: 8),
              Builder(builder: (context) {
                double p = double.tryParse(profit) ?? 0.0;
                String conclusion = p > 0 ? "Модель є рентабельна" : "Модель не є рентабельна";
                return Text("Висновок: " + conclusion);
              }),
            ],
          ),
        ),
      ),
    );
  }
}

double normalPowerDistributionLaw(double p, double pC, double sigma1) {
  double coefficient = 1 / (sigma1 * sqrt(2 * pi));
  double exponent = -pow((p - pC), 2) / (2 * pow(sigma1, 2));
  return coefficient * exp(exponent);
}

double integration(double powerAverage, int numSteps, double deviation) {
  double lowerBound = powerAverage - powerAverage * 0.05;
  double upperBound = powerAverage + powerAverage * 0.05;
  double stepSize = (upperBound - lowerBound) / numSteps;
  double res = 0.0;
  for (int i = 0; i < numSteps; i++) {
    double p1 = lowerBound + i * stepSize;
    double p2 = p1 + stepSize;
    double npdl1 = normalPowerDistributionLaw(p1, powerAverage, deviation);
    double npdl2 = normalPowerDistributionLaw(p2, powerAverage, deviation);
    res += 0.5 * (npdl1 + npdl2) * stepSize;
  }
  return res;
}
