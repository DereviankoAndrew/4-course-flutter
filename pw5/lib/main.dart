import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(text: "Калькулятор 1"),
              Tab(text: "Калькулятор 2"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CalculatorOne(),
            CalculatorTwo(),
          ],
        ),
      ),
    );
  }
}

class EquipmentReliability {
  final double failureRate;
  final int averageRepairTime;
  final double frequency;
  final int averageRecoveryTime;
  EquipmentReliability(this.failureRate, this.averageRepairTime, this.frequency, this.averageRecoveryTime);
}

final Map<String, EquipmentReliability> equipmentData = {
  "T-110 kV": EquipmentReliability(0.015, 100, 1.0, 43),
  "T-35 kV": EquipmentReliability(0.02, 80, 1.0, 28),
  "T-10 kV (кабельна мережа 10 кВ)": EquipmentReliability(0.005, 60, 0.5, 10),
  "T-10 kV (повітряна мережа 10 кВ)": EquipmentReliability(0.05, 60, 0.5, 10),
  "B-110 kV (елегазовий)": EquipmentReliability(0.01, 30, 0.1, 30),
  "B-10 kV (малолойний)": EquipmentReliability(0.02, 15, 0.33, 15),
  "B-10 kV (вакуумний)": EquipmentReliability(0.05, 15, 0.33, 15),
  "Збірні шини 10 кВ на 1 приєднання": EquipmentReliability(0.03, 2, 0.33, 15),
  "АВ-0,38 кВ": EquipmentReliability(0.05, 20, 1.0, 15),
  "ЕД 6,10 кВ": EquipmentReliability(0.1, 50, 0.5, 0),
  "ЕД 0,38 кВ": EquipmentReliability(0.1, 50, 0.5, 0),
  "ПЛ-110 кВ": EquipmentReliability(0.007, 10, 0.167, 35),
  "ПЛ-35 кВ": EquipmentReliability(0.02, 8, 0.167, 35),
  "ПЛ-10 кВ": EquipmentReliability(0.02, 10, 0.167, 35),
  "КЛ-10 кВ (траншея)": EquipmentReliability(0.03, 44, 1.0, 9),
  "КЛ-10 kВ (кабельний канал)": EquipmentReliability(0.005, 18, 1.0, 9)
};

class CalculatorOne extends StatefulWidget {
  @override
  _CalculatorOneState createState() => _CalculatorOneState();
}

class _CalculatorOneState extends State<CalculatorOne> {
  final Map<String, TextEditingController> amountMap = {
    "T-110 kV": TextEditingController(text: "1"),
    "T-35 kV": TextEditingController(text: "0"),
    "T-10 kV (кабельна мережа 10 кВ)": TextEditingController(text: "0"),
    "T-10 kV (повітряна мережа 10 кВ)": TextEditingController(text: "0"),
    "B-110 kV (елегазовий)": TextEditingController(text: "1"),
    "B-10 kV (малолойний)": TextEditingController(text: "1"),
    "B-10 kV (вакуумний)": TextEditingController(text: "0"),
    "Збірні шини 10 кВ на 1 приєднання": TextEditingController(text: "6"),
    "АВ-0,38 кВ": TextEditingController(text: "0"),
    "ЕД 6,10 кВ": TextEditingController(text: "0"),
    "ЕД 0,38 кВ": TextEditingController(text: "0"),
    "ПЛ-110 кВ": TextEditingController(text: "10"),
    "ПЛ-35 кВ": TextEditingController(text: "0"),
    "ПЛ-10 кВ": TextEditingController(text: "0"),
    "КЛ-10 кВ (траншея)": TextEditingController(text: "0"),
    "КЛ-10 kВ (кабельний канал)": TextEditingController(text: "0")
  };
  String Woc = "";
  String Tvoc = "";
  String Kaoc = "";
  String Kpoc = "";
  String Wdk = "";
  String Wds = "";
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(height: 56),
          for (var key in amountMap.keys) ...[
            TextField(
              controller: amountMap[key],
              decoration: InputDecoration(labelText: key),
              onTap: () => FocusScope.of(context).unfocus(),
            ),
            SizedBox(height: 8),
          ],
          ElevatedButton(
            onPressed: () {
              double w0c = 0.0;
              double tvoc = 0.0;
              double kaoc = 0.0;
              double kpos = 0.0;
              double wdk = 0.0;
              double wds = 0.0;
              amountMap.forEach((key, controller) {
                int amount = int.tryParse(controller.text) ?? 0;
                if (amount > 0) {
                  w0c += amount * (equipmentData[key]?.failureRate ?? 0);
                  tvoc += amount * (equipmentData[key]?.averageRepairTime ?? 0) * (equipmentData[key]?.failureRate ?? 0);
                }
              });
              tvoc = w0c != 0 ? tvoc / w0c : 0;
              kaoc = (tvoc * w0c) / 8760;
              kpos = 1.2 * 43 / 8760;
              wdk = 2 * w0c * (kaoc + kpos);
              wds = wdk + 0.02;
              setState(() {
                Woc = roundToTwoDecimalString(w0c);
                Tvoc = roundToTwoDecimalString(tvoc);
                Kaoc = roundToTwoDecimalString(kaoc);
                Kpoc = roundToTwoDecimalString(kpos);
                Wdk = roundToTwoDecimalString(wdk);
                Wds = roundToTwoDecimalString(wds);
              });
            },
            child: Text("Обчислити"),
          ),
          Text("Частота відмов одноколової системи: " + Woc, style: Theme.of(context).textTheme.bodyLarge),
          SizedBox(height: 8),
          Text("Середня тривалість відновлення: " + Tvoc, style: Theme.of(context).textTheme.bodyLarge),
          SizedBox(height: 8),
          Text("Коефікієнт аварійного простою одноколової системи: " + Kaoc, style: Theme.of(context).textTheme.bodyLarge),
          SizedBox(height: 8),
          Text("Коефікієнт планового простою одноколової системи: " + Kpoc, style: Theme.of(context).textTheme.bodyLarge),
          SizedBox(height: 8),
          Text("Частота відмов одночасно двох кіл: " + Wdk, style: Theme.of(context).textTheme.bodyLarge),
          SizedBox(height: 8),
          Text("Частота відмов двоколової системи з урахуванням секційного вимикача: " + Wds, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}

String roundToTwoDecimalString(double value) {
  return value.toStringAsFixed(2);
}

class CalculatorTwo extends StatefulWidget {
  @override
  _CalculatorTwoState createState() => _CalculatorTwoState();
}

class _CalculatorTwoState extends State<CalculatorTwo> {
  final TextEditingController omegaController = TextEditingController(text: "0.01");
  final TextEditingController tSController = TextEditingController(text: "0.045");
  final TextEditingController pMController = TextEditingController(text: "5120");
  final TextEditingController tMController = TextEditingController(text: "6451");
  final TextEditingController zAvarController = TextEditingController(text: "23.6");
  final TextEditingController zPlanController = TextEditingController(text: "17.6");
  final TextEditingController kPController = TextEditingController(text: "0.004");
  String mWnedA = "";
  String mWnedP = "";
  String mZ = "";
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(height: 56),
          TextField(
            controller: omegaController,
            decoration: InputDecoration(labelText: "частота відмов"),
            onTap: () => FocusScope.of(context).unfocus(),
          ),
          SizedBox(height: 16),
          TextField(
            controller: tSController,
            decoration: InputDecoration(labelText: "середній час відновлення трансформатора напругою 35 кВ"),
            onTap: () => FocusScope.of(context).unfocus(),
          ),
          SizedBox(height: 16),
          TextField(
            controller: pMController,
            decoration: InputDecoration(labelText: "потужність"),
            onTap: () => FocusScope.of(context).unfocus(),
          ),
          SizedBox(height: 16),
          TextField(
            controller: tMController,
            decoration: InputDecoration(labelText: "очікуваний час простою"),
            onTap: () => FocusScope.of(context).unfocus(),
          ),
          SizedBox(height: 16),
          TextField(
            controller: zAvarController,
            decoration: InputDecoration(labelText: "збитки у разі аварійного переривання"),
            onTap: () => FocusScope.of(context).unfocus(),
          ),
          SizedBox(height: 16),
          TextField(
            controller: zPlanController,
            decoration: InputDecoration(labelText: "збитки у разі запланованого переривання"),
            onTap: () => FocusScope.of(context).unfocus(),
          ),
          SizedBox(height: 16),
          TextField(
            controller: kPController,
            decoration: InputDecoration(labelText: "сер час планового простою"),
            onTap: () => FocusScope.of(context).unfocus(),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              double omegaValue = double.tryParse(omegaController.text) ?? 0.0;
              double tSValue = double.tryParse(tSController.text) ?? 0.0;
              double pMValue = double.tryParse(pMController.text) ?? 0.0;
              double tMValue = double.tryParse(tMController.text) ?? 0.0;
              double zAvarValue = double.tryParse(zAvarController.text) ?? 0.0;
              double zPlanValue = double.tryParse(zPlanController.text) ?? 0.0;
              double kPValue = double.tryParse(kPController.text) ?? 0.0;
              double mWnedAValue = omegaValue * tSValue * pMValue * tMValue;
              double mWnedPValue = kPValue * pMValue * tMValue;
              double mZValue = zAvarValue * mWnedAValue + zPlanValue * mWnedPValue;
              setState(() {
                mWnedA = mWnedAValue.toString();
                mWnedP = mWnedPValue.toString();
                mZ = mZValue.toString();
              });
            },
            child: Text("Обчислити"),
          ),
          SizedBox(height: 8),
          Text("Очікувана відсутність енергопостачання в надзвичайних ситуаціях: " + mWnedA, style: Theme.of(context).textTheme.bodyLarge),
          SizedBox(height: 8),
          Text("Очікуваний дефіцит енергії для запланованих: " + mWnedP, style: Theme.of(context).textTheme.bodyLarge),
          SizedBox(height: 8),
          Text("Загальна очікувана вартість перерв у роботі: " + mZ, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
