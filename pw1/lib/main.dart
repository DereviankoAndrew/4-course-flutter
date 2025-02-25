import 'package:flutter/material.dart';
import 'calculator_one.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CalculatorOne()),
                );
              },
              child: const Text('Calculator One'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CalculatorTwo()),
                );
              },
              child: const Text('Calculator Two'),
            ),
          ],
        ),
      ),
    );
  }
}

double toDoubleOrZero(String value) {
  return double.tryParse(value) ?? 0.0;
}

double roundTo2Decimals(double value) {
  return double.parse(value.toStringAsFixed(2));
}

class CalculatorTwo extends StatefulWidget {
  const CalculatorTwo({Key? key}) : super(key: key);

  @override
  _CalculatorTwoState createState() => _CalculatorTwoState();
}

class _CalculatorTwoState extends State<CalculatorTwo> {
  String carbon = '';
  String hydrogen = '';
  String oxygen = '';
  String sulfur = '';
  String lowerCalorificValue = '';
  String moisture = '';
  String ash = '';
  String vanadium = '';

  double carbonMazut = 0.0;
  double hydrogenMazut = 0.0;
  double oxygenMazut = 0.0;
  double sulfurMazut = 0.0;
  double ashMazut = 0.0;
  double vanadiumMazut = 0.0;
  double combustionHeat = 0.0;

  bool showResults = false;

  void resetResults() {
    setState(() {
      showResults = false;
    });
  }

  bool areAllInputsFilled() {
    return carbon.isNotEmpty &&
        hydrogen.isNotEmpty &&
        oxygen.isNotEmpty &&
        sulfur.isNotEmpty &&
        lowerCalorificValue.isNotEmpty &&
        moisture.isNotEmpty &&
        ash.isNotEmpty &&
        vanadium.isNotEmpty;
  }

  void calculate() {
    setState(() {
      double moistureVal = toDoubleOrZero(moisture);
      double ashVal = toDoubleOrZero(ash);
      double factor = (100 - moistureVal - ashVal) / 100.0;

      carbonMazut = toDoubleOrZero(carbon) * factor;
      hydrogenMazut = toDoubleOrZero(hydrogen) * factor;
      oxygenMazut = toDoubleOrZero(oxygen) * factor;
      sulfurMazut = toDoubleOrZero(sulfur) * factor;
      ashMazut = toDoubleOrZero(ash) * ((100 - moistureVal) / 100.0);
      vanadiumMazut = toDoubleOrZero(vanadium) * ((100 - moistureVal) / 100.0);

      combustionHeat = toDoubleOrZero(lowerCalorificValue) * factor -
          0.025 * moistureVal;

      showResults = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculator Two"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Перерахунок елементарного складу та нижчої\n"
              "теплоти згоряння мазуту на робочу масу для складу горючої маси мазуту",
            ),
            const SizedBox(height: 8),
            PercentageInput(
              label: "Вуглець, %",
              value: carbon,
              onChanged: (value) {
                setState(() {
                  carbon = value;
                });
                resetResults();
              },
            ),
            PercentageInput(
              label: "Водень, %",
              value: hydrogen,
              onChanged: (value) {
                setState(() {
                  hydrogen = value;
                });
                resetResults();
              },
            ),
            PercentageInput(
              label: "Кисень, %",
              value: oxygen,
              onChanged: (value) {
                setState(() {
                  oxygen = value;
                });
                resetResults();
              },
            ),
            PercentageInput(
              label: "Сірка, %",
              value: sulfur,
              onChanged: (value) {
                setState(() {
                  sulfur = value;
                });
                resetResults();
              },
            ),
            PercentageInput(
              label: "Нижча теплота згоряння\nгорючої маси мазуту, МДж/кг",
              value: lowerCalorificValue,
              onChanged: (value) {
                setState(() {
                  lowerCalorificValue = value;
                });
                resetResults();
              },
            ),
            PercentageInput(
              label: "Вологість робочої маси палива, %",
              value: moisture,
              onChanged: (value) {
                setState(() {
                  moisture = value;
                });
                resetResults();
              },
            ),
            PercentageInput(
              label: "Зольність сухої маси, %",
              value: ash,
              onChanged: (value) {
                setState(() {
                  ash = value;
                });
                resetResults();
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: TextField(
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: "Вміст ванадію, мг/кг",
                  errorText: vanadium.isNotEmpty &&
                          (double.tryParse(vanadium) == null ||
                              double.parse(vanadium) <= 0)
                      ? "Введіть число більше 0"
                      : null,
                ),
                onChanged: (value) {
                  setState(() {
                    vanadium = value;
                  });
                  resetResults();
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (!areAllInputsFilled()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Будь ласка, заповніть усі аргументи."),
                    ),
                  );
                  return;
                }
                calculate();
              },
              child: const Text("Розрахувати"),
            ),
            const SizedBox(height: 8),
            if (showResults)
              Results(
                hydrogen: hydrogen,
                carbon: carbon,
                sulfur: sulfur,
                oxygen: oxygen,
                vanadium: vanadium,
                lowerCalorificValue: lowerCalorificValue,
                moisture: moisture,
                ash: ash,
                hydrogenMazut: roundTo2Decimals(hydrogenMazut).toString(),
                carbonMazut: roundTo2Decimals(carbonMazut).toString(),
                sulfurMazut: roundTo2Decimals(sulfurMazut).toString(),
                oxygenMazut: roundTo2Decimals(oxygenMazut).toString(),
                vanadiumMazut: roundTo2Decimals(vanadiumMazut).toString(),
                ashMazut: roundTo2Decimals(ashMazut).toString(),
                combustionHeat: roundTo2Decimals(combustionHeat).toString(),
              ),
          ],
        ),
      ),
    );
  }
}

class PercentageInput extends StatelessWidget {
  final String label;
  final String value;
  final ValueChanged<String> onChanged;

  const PercentageInput({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: value);
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
        ),
        onChanged: onChanged,
      ),
    );
  }
}

class Results extends StatelessWidget {
  final String hydrogen;
  final String carbon;
  final String sulfur;
  final String oxygen;
  final String vanadium;
  final String lowerCalorificValue;
  final String moisture;
  final String ash;
  final String hydrogenMazut;
  final String carbonMazut;
  final String sulfurMazut;
  final String oxygenMazut;
  final String vanadiumMazut;
  final String ashMazut;
  final String combustionHeat;

  const Results({
    Key? key,
    required this.hydrogen,
    required this.carbon,
    required this.sulfur,
    required this.oxygen,
    required this.vanadium,
    required this.lowerCalorificValue,
    required this.moisture,
    required this.ash,
    required this.hydrogenMazut,
    required this.carbonMazut,
    required this.sulfurMazut,
    required this.oxygenMazut,
    required this.vanadiumMazut,
    required this.ashMazut,
    required this.combustionHeat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Для складу горючої маси мазуту з компонентним складом: \n"
          "Водень - $hydrogen% \n"
          "Вуглець - $carbon% \n"
          "Сірка - $sulfur% \n"
          "Кисень - $oxygen% \n"
          "Ванадій - ${vanadium}мг/кг \n"
          "Нижча теплота згоряння горючої маси мазуту - ${lowerCalorificValue}МДж/кг \n"
          "Волога - $moisture% \n"
          "Зола - $ash% \n",
        ),
        const SizedBox(height: 8),
        Text(
          "2.1. Склад робочої маси мазуту становитиме: \n"
          "Водень - $hydrogenMazut%\n"
          "Вуглець - $carbonMazut% \n"
          "Сірка - $sulfurMazut% \n"
          "Кисень - $oxygenMazut% \n"
          "Ванадій - ${vanadiumMazut}мг/кг \n"
          "Зола - $ashMazut% \n\n"
          "2.2 Нижча теплота згоряння мазуту на робочу масу для робочої маси за заданим складом\n"
          "компонентів палива становить: $combustionHeat МДж/кг.",
        ),
      ],
    );
  }
}
