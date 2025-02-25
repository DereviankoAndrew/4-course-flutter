import 'package:flutter/material.dart';

double toDoubleOrZero(String value) {
  return double.tryParse(value) ?? 0.0;
}

String roundTo2Decimals(double value) {
  return value.toStringAsFixed(2);
}

class Variable {
  final String description;
  final String sign;

  Variable({this.description = "", this.sign = ""});
}

class CalculatorOne extends StatefulWidget {
  const CalculatorOne({Key? key}) : super(key: key);

  @override
  _CalculatorOneState createState() => _CalculatorOneState();
}

class _CalculatorOneState extends State<CalculatorOne> {

  String hydrogenWorkingInput = "";
  String carbonWorkingInput = "";
  String sulfurWorkingInput = "";
  String nitrogenWorkingInput = "";
  String oxygenWorkingInput = "";
  String moistureInput = "";
  String ashInput = "";

  bool showResults = false;

  double conversionRatioFromWorkingToDryMass = 0.0;
  double conversionRatioFromWorkingToCombustibleMass = 0.0;

  double carbonDry = 0.0;
  double hydrogenDry = 0.0;
  double sulfurDry = 0.0;
  double oxygenDry = 0.0;
  double nitrogenDry = 0.0;
  double ashDry = 0.0;

  double carbonCombustile = 0.0;
  double hydrogenCombustile = 0.0;
  double sulfurCombustile = 0.0;
  double oxygenCombustile = 0.0;
  double nitrogenCombustile = 0.0;

  double combustionHeat = 0.0;
  double lowerCalorificValueForDryMass = 0.0;
  double lowerCalorificValueForCombustibleMass = 0.0;

  void resetResults() {
    setState(() {
      showResults = false;
    });
  }

  bool areAllInputsFilled() {
    return hydrogenWorkingInput.isNotEmpty &&
        carbonWorkingInput.isNotEmpty &&
        sulfurWorkingInput.isNotEmpty &&
        nitrogenWorkingInput.isNotEmpty &&
        oxygenWorkingInput.isNotEmpty &&
        moistureInput.isNotEmpty &&
        ashInput.isNotEmpty;
  }

  double calculateInputSum() {
    return toDoubleOrZero(carbonWorkingInput) +
        toDoubleOrZero(hydrogenWorkingInput) +
        toDoubleOrZero(sulfurWorkingInput) +
        toDoubleOrZero(nitrogenWorkingInput) +
        toDoubleOrZero(oxygenWorkingInput) +
        toDoubleOrZero(moistureInput) +
        toDoubleOrZero(ashInput);
  }

  void calculate({
    required double carbonWorking,
    required double hydrogenWorking,
    required double sulfurWorking,
    required double oxygenWorking,
    required double nitrogenWorking,
    required double moisture,
    required double ash,
  }) {
    setState(() {
      conversionRatioFromWorkingToDryMass = 100 / (100 - moisture);
      conversionRatioFromWorkingToCombustibleMass = 100 / (100 - moisture - ash);

      carbonDry = carbonWorking * conversionRatioFromWorkingToDryMass;
      hydrogenDry = hydrogenWorking * conversionRatioFromWorkingToDryMass;
      sulfurDry = sulfurWorking * conversionRatioFromWorkingToDryMass;
      oxygenDry = oxygenWorking * conversionRatioFromWorkingToDryMass;
      nitrogenDry = nitrogenWorking * conversionRatioFromWorkingToDryMass;
      ashDry = ash * conversionRatioFromWorkingToDryMass;

      carbonCombustile =
          carbonWorking * conversionRatioFromWorkingToCombustibleMass;
      hydrogenCombustile =
          hydrogenWorking * conversionRatioFromWorkingToCombustibleMass;
      sulfurCombustile =
          sulfurWorking * conversionRatioFromWorkingToCombustibleMass;
      oxygenCombustile =
          oxygenWorking * conversionRatioFromWorkingToCombustibleMass;
      nitrogenCombustile =
          nitrogenWorking * conversionRatioFromWorkingToCombustibleMass;

      combustionHeat = 339 * carbonWorking +
          1030 * hydrogenWorking -
          108.8 * (oxygenWorking - sulfurWorking) -
          25 * moisture;

      lowerCalorificValueForDryMass =
          (combustionHeat / 1000 + 0.025 * moisture) * (100 / (100 - moisture));

      lowerCalorificValueForCombustibleMass =
          (combustionHeat / 1000 + 0.025 * moisture) *
              (100 / (100 - moisture - ash));
    });
  }

  @override
  Widget build(BuildContext context) {
    final hydrogenWorking =
        Variable(description: "Водень (робоче паливо)", sign: "Hw");
    final carbonWorking =
        Variable(description: "Вуглець (робоче паливо)", sign: "Cw");
    final sulfurWorking =
        Variable(description: "Сірка (робоче паливо)", sign: "Sw");
    final oxygenWorking =
        Variable(description: "Кисень (робоче паливо)", sign: "Ow");
    final nitrogenWorking =
        Variable(description: "Азот (робоче паливо)", sign: "Nw");
    final moistureVar = Variable(description: "Волога", sign: "W");
    final ashVar = Variable(description: "Зола", sign: "A");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculator One"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Розрахунок складу сухої та горючої маси палива та нижчої теплоти згоряння для "
              "робочої, сухої та горючої маси",
            ),
            const SizedBox(height: 8),
            PercentageInput(
              label:
                  "${hydrogenWorking.description} (${hydrogenWorking.sign})",
              value: hydrogenWorkingInput,
              onChanged: (value) {
                setState(() {
                  hydrogenWorkingInput = value;
                });
                resetResults();
              },
            ),
            PercentageInput(
              label: "${carbonWorking.description} (${carbonWorking.sign})",
              value: carbonWorkingInput,
              onChanged: (value) {
                setState(() {
                  carbonWorkingInput = value;
                });
                resetResults();
              },
            ),
            PercentageInput(
              label: "${sulfurWorking.description} (${sulfurWorking.sign})",
              value: sulfurWorkingInput,
              onChanged: (value) {
                setState(() {
                  sulfurWorkingInput = value;
                });
                resetResults();
              },
            ),
            PercentageInput(
              label: "${nitrogenWorking.description} (${nitrogenWorking.sign})",
              value: nitrogenWorkingInput,
              onChanged: (value) {
                setState(() {
                  nitrogenWorkingInput = value;
                });
                resetResults();
              },
            ),
            PercentageInput(
              label: "${oxygenWorking.description} (${oxygenWorking.sign})",
              value: oxygenWorkingInput,
              onChanged: (value) {
                setState(() {
                  oxygenWorkingInput = value;
                });
                resetResults();
              },
            ),
            PercentageInput(
              label: "${moistureVar.description} (${moistureVar.sign})",
              value: moistureInput,
              onChanged: (value) {
                setState(() {
                  moistureInput = value;
                });
                resetResults();
              },
            ),
            PercentageInput(
              label: "${ashVar.description} (${ashVar.sign})",
              value: ashInput,
              onChanged: (value) {
                setState(() {
                  ashInput = value;
                });
                resetResults();
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (!areAllInputsFilled()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Будь ласка, заповніть усі аргументи."),
                        ),
                      );
                      return;
                    }
                    if (calculateInputSum() != 100.00) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Запевніться, що сума аргументів дорівнює 100."),
                        ),
                      );
                      return;
                    }

                    calculate(
                      carbonWorking: toDoubleOrZero(carbonWorkingInput),
                      hydrogenWorking: toDoubleOrZero(hydrogenWorkingInput),
                      sulfurWorking: toDoubleOrZero(sulfurWorkingInput),
                      oxygenWorking: toDoubleOrZero(oxygenWorkingInput),
                      nitrogenWorking: toDoubleOrZero(nitrogenWorkingInput),
                      moisture: toDoubleOrZero(moistureInput),
                      ash: toDoubleOrZero(ashInput),
                    );

                    setState(() {
                      showResults = true;
                    });
                  },
                  child: const Text("Розрахувати"),
                ),
                Text("Сума: ${roundTo2Decimals(calculateInputSum())}"),
              ],
            ),
            const SizedBox(height: 16),
            if (showResults)
              Results(
                hydrogenWorkingInput: hydrogenWorkingInput,
                carbonWorkingInput: carbonWorkingInput,
                sulfurWorkingInput: sulfurWorkingInput,
                nitrogenWorkingInput: nitrogenWorkingInput,
                oxygenWorkingInput: oxygenWorkingInput,
                moistureInput: moistureInput,
                ashInput: ashInput,
                conversionRatioFromWorkingToDryMass:
                    roundTo2Decimals(conversionRatioFromWorkingToDryMass),
                conversionRatioFromWorkingToCombustibleMass:
                    roundTo2Decimals(conversionRatioFromWorkingToCombustibleMass),
                carbonDry: roundTo2Decimals(carbonDry),
                hydrogenDry: roundTo2Decimals(hydrogenDry),
                sulfurDry: roundTo2Decimals(sulfurDry),
                oxygenDry: roundTo2Decimals(oxygenDry),
                nitrogenDry: roundTo2Decimals(nitrogenDry),
                ashDry: roundTo2Decimals(ashDry),
                carbonCombustile: roundTo2Decimals(carbonCombustile),
                hydrogenCombustile: roundTo2Decimals(hydrogenCombustile),
                sulfurCombustile: roundTo2Decimals(sulfurCombustile),
                oxygenCombustile: roundTo2Decimals(oxygenCombustile),
                nitrogenCombustile: roundTo2Decimals(nitrogenCombustile),
                combustionHeat: roundTo2Decimals(combustionHeat / 1000),
                lowerCalorificValueForDryMass:
                    roundTo2Decimals(lowerCalorificValueForDryMass),
                lowerCalorificValueForCombustibleMass:
                    roundTo2Decimals(lowerCalorificValueForCombustibleMass),
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
        keyboardType:
            const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(
          labelText: label,
        ),
        onChanged: onChanged,
      ),
    );
  }
}

class Results extends StatelessWidget {
  final String hydrogenWorkingInput;
  final String carbonWorkingInput;
  final String sulfurWorkingInput;
  final String nitrogenWorkingInput;
  final String oxygenWorkingInput;
  final String moistureInput;
  final String ashInput;

  final String conversionRatioFromWorkingToDryMass;
  final String conversionRatioFromWorkingToCombustibleMass;

  final String carbonDry;
  final String hydrogenDry;
  final String sulfurDry;
  final String oxygenDry;
  final String nitrogenDry;
  final String ashDry;

  final String carbonCombustile;
  final String hydrogenCombustile;
  final String sulfurCombustile;
  final String oxygenCombustile;
  final String nitrogenCombustile;

  final String combustionHeat;
  final String lowerCalorificValueForDryMass;
  final String lowerCalorificValueForCombustibleMass;

  const Results({
    Key? key,
    required this.hydrogenWorkingInput,
    required this.carbonWorkingInput,
    required this.sulfurWorkingInput,
    required this.nitrogenWorkingInput,
    required this.oxygenWorkingInput,
    required this.moistureInput,
    required this.ashInput,
    required this.conversionRatioFromWorkingToDryMass,
    required this.conversionRatioFromWorkingToCombustibleMass,
    required this.carbonDry,
    required this.hydrogenDry,
    required this.sulfurDry,
    required this.oxygenDry,
    required this.nitrogenDry,
    required this.ashDry,
    required this.carbonCombustile,
    required this.hydrogenCombustile,
    required this.sulfurCombustile,
    required this.oxygenCombustile,
    required this.nitrogenCombustile,
    required this.combustionHeat,
    required this.lowerCalorificValueForDryMass,
    required this.lowerCalorificValueForCombustibleMass,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Для палива з компонентним складом: \n"
          "Водень - ${hydrogenWorkingInput}% \n"
          "Вуглець - ${carbonWorkingInput}% \n"
          "Сірка - ${sulfurWorkingInput}% \n"
          "Азот - ${nitrogenWorkingInput}% \n"
          "Кисень - ${oxygenWorkingInput}% \n"
          "Волога - ${moistureInput}% \n"
          "Зола - ${ashInput}% \n",
        ),
        const SizedBox(height: 8),
        Text(
          "1.1. Коефіцієнт переходу від робочої до сухої маси становить: $conversionRatioFromWorkingToDryMass\n\n"
          "1.2. Коефіцієнт переходу від робочої до горючої маси становить: $conversionRatioFromWorkingToCombustibleMass\n\n"
          "1.3. Склад сухої маси палива становитиме: \n"
          "Водень = $hydrogenDry%\n"
          "Вуглець = $carbonDry%\n"
          "Сірка = $sulfurDry%\n"
          "Кисень = $oxygenDry%\n"
          "Азот = $nitrogenDry%\n"
          "Зола = $ashDry%\n\n"
          "1.4. Склад горючої маси палива становитиме: \n"
          "Водень = $hydrogenCombustile%\n"
          "Вуглець = $carbonCombustile%\n"
          "Сірка = $sulfurCombustile%\n"
          "Кисень = $oxygenCombustile%\n"
          "Азот = $nitrogenCombustile%\n\n"
          "1.5. Нижча теплота згоряння для робочої маси за заданим складом компонентів палива становить: $combustionHeat МДж/кг\n\n"
          "1.6. Нижча теплота згоряння для сухої маси за заданим складом компонентів палива становить: $lowerCalorificValueForDryMass МДж/кг\n\n"
          "1.7. Нижча теплота згоряння для горючої маси за заданим складом компонентів палива становить: $lowerCalorificValueForCombustibleMass МДж/кг.",
        ),
      ],
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator One',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CalculatorOne(),
    );
  }
}
