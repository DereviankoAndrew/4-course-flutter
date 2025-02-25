import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: CalculatorScreen());
  }
}

class EpData {
  String name;
  String nu_n;
  String cos_phi;
  String Un;
  String n;
  String Pn;
  String Kv;
  String tg_phi;
  String n_mult_Pn;
  String Ip;
  EpData(
      {this.name = "",
      this.nu_n = "",
      this.cos_phi = "",
      this.Un = "",
      this.n = "",
      this.Pn = "",
      this.Kv = "",
      this.tg_phi = "",
      this.n_mult_Pn = "",
      this.Ip = ""});
}

class EpDataForm extends StatelessWidget {
  final EpData epData;
  final VoidCallback onChanged;
  EpDataForm({required this.epData, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: epData.name,
          decoration: InputDecoration(labelText: "Найменування ЕП"),
          onChanged: (val) {
            epData.name = val;
            onChanged();
          },
        ),
        TextFormField(
          initialValue: epData.nu_n,
          decoration:
              InputDecoration(labelText: "Номінальне значення ККД (ηн)"),
          onChanged: (val) {
            epData.nu_n = val;
            onChanged();
          },
        ),
        TextFormField(
          initialValue: epData.cos_phi,
          decoration:
              InputDecoration(labelText: "Коефіцієнт потужн навантаж (cos φ)"),
          onChanged: (val) {
            epData.cos_phi = val;
            onChanged();
          },
        ),
        TextFormField(
          initialValue: epData.Un,
          decoration:
              InputDecoration(labelText: "Напруга навантаження (Uн, кВ)"),
          onChanged: (val) {
            epData.Un = val;
            onChanged();
          },
        ),
        TextFormField(
          initialValue: epData.n,
          decoration:
              InputDecoration(labelText: "Кількість ЕП (n, шт)"),
          onChanged: (val) {
            epData.n = val;
            onChanged();
          },
        ),
        TextFormField(
          initialValue: epData.Pn,
          decoration: InputDecoration(
              labelText: "Номінальна потужність ЕП (Рн, кВт)"),
          onChanged: (val) {
            epData.Pn = val;
            onChanged();
          },
        ),
        TextFormField(
          initialValue: epData.Kv,
          decoration:
              InputDecoration(labelText: "Коефіцієнт використання (КВ)"),
          onChanged: (val) {
            epData.Kv = val;
            onChanged();
          },
        ),
        TextFormField(
          initialValue: epData.tg_phi,
          decoration: InputDecoration(
              labelText: "Коефіцієнт реактивної потужн (tgφ)"),
          onChanged: (val) {
            epData.tg_phi = val;
            onChanged();
          },
        ),
      ],
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  List<EpData> epDataList = [
    EpData(
        name: "Шліфувальний верстат",
        nu_n: "0.92",
        cos_phi: "0.9",
        Un: "0.38",
        n: "4",
        Pn: "20",
        Kv: "0.15",
        tg_phi: "1.33"),
    EpData(
        name: "Свердлильний верстат",
        nu_n: "0.92",
        cos_phi: "0.9",
        Un: "0.38",
        n: "2",
        Pn: "14",
        Kv: "0.12",
        tg_phi: "1"),
    EpData(
        name: "Фугувальний верстат",
        nu_n: "0.92",
        cos_phi: "0.9",
        Un: "0.38",
        n: "4",
        Pn: "42",
        Kv: "0.15",
        tg_phi: "1.33"),
    EpData(
        name: "Циркулярна пила",
        nu_n: "0.92",
        cos_phi: "0.9",
        Un: "0.38",
        n: "1",
        Pn: "36",
        Kv: "0.3",
        tg_phi: "1.52"),
    EpData(
        name: "Прес",
        nu_n: "0.92",
        cos_phi: "0.9",
        Un: "0.38",
        n: "1",
        Pn: "20",
        Kv: "0.5",
        tg_phi: "0.75"),
    EpData(
        name: "Полірувальний верстат",
        nu_n: "0.92",
        cos_phi: "0.9",
        Un: "0.38",
        n: "1",
        Pn: "40",
        Kv: "0.2",
        tg_phi: "1"),
    EpData(
        name: "Фрезерний верстат",
        nu_n: "0.92",
        cos_phi: "0.9",
        Un: "0.38",
        n: "2",
        Pn: "32",
        Kv: "0.2",
        tg_phi: "1"),
    EpData(
        name: "Вентилятор",
        nu_n: "0.92",
        cos_phi: "0.9",
        Un: "0.38",
        n: "1",
        Pn: "20",
        Kv: "0.65",
        tg_phi: "0.75"),
  ];
  String Kr = "1.25";
  String Kr2 = "0.7";
  double sum_of_n_Pn_Kv_product_41 = 0.0;
  String kv_group = "";
  String eff_ep_amount = "";
  String total_department_util_coef = "";
  String eff_ep_department_amount = "";
  String rozrah_act_nav = "";
  String rozrah_react_nav = "";
  String full_power = "";
  String rozrah_group_strum_shr1 = "";
  String rozrah_act_nav_shin = "";
  String rozrah_react_nav_shin = "";
  String full_power_shin = "";
  String rozrah_group_strum_shin = "";
  TextEditingController _krController = TextEditingController(text: "1.25");
  TextEditingController _kr2Controller = TextEditingController(text: "0.7");
  @override
  void dispose() {
    _krController.dispose();
    _kr2Controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculator")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  epDataList.add(EpData());
                });
              },
              child: Text("Додати ЕП"),
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: epDataList
                    .map((e) => Container(
                        width: MediaQuery.of(context).size.width,
                        child: EpDataForm(
                            epData: e,
                            onChanged: () {
                              setState(() {});
                            })))
                    .toList(),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                double sum_of_n_Pn_Kv_product = 0.0;
                double sum_of_n_Pn_product = 0.0;
                double sum_of_n_Pn_Pn_product = 0.0;
                double group_util_coefficient = 0.0;
                double effective_ep_amount = 0.0;
                for (var epData in epDataList) {
                  double n = double.tryParse(epData.n) ?? 0.0;
                  double Pn = double.tryParse(epData.Pn) ?? 0.0;
                  epData.n_mult_Pn = (n * Pn).toString();
                  double Un = double.tryParse(epData.Un) ?? 1.0;
                  double cos_phi = double.tryParse(epData.cos_phi) ?? 1.0;
                  double nu_n = double.tryParse(epData.nu_n) ?? 1.0;
                  double Ip =
                      (n * Pn) / (sqrt(3) * Un * cos_phi * nu_n);
                  epData.Ip = Ip.toString();
                  sum_of_n_Pn_Kv_product += (n * Pn) *
                      (double.tryParse(epData.Kv) ?? 0.0);
                  sum_of_n_Pn_product += (n * Pn);
                  sum_of_n_Pn_Pn_product += n * Pn * Pn;
                }
                sum_of_n_Pn_Kv_product_41 = sum_of_n_Pn_Kv_product;
                group_util_coefficient = sum_of_n_Pn_product == 0
                    ? 0
                    : sum_of_n_Pn_Kv_product / sum_of_n_Pn_product;
                effective_ep_amount = sum_of_n_Pn_Pn_product == 0
                    ? 0
                    : (sum_of_n_Pn_product * sum_of_n_Pn_product /
                        sum_of_n_Pn_Pn_product)
                        .ceilToDouble();
                setState(() {
                  kv_group = group_util_coefficient.toString();
                  eff_ep_amount = effective_ep_amount.toString();
                });
              },
              child: Text("Обчислити"),
            ),
            SizedBox(height: 8),
            Text("груповий коефіцієнт використання: " + kv_group,
                style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            Text("ефективна кількість ЕП: " + eff_ep_amount,
                style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            TextField(
              controller: _krController,
              decoration: InputDecoration(
                  labelText: "розрахунковий коеф активної потужності"),
              onChanged: (val) {
                Kr = val;
              },
            ),
            ElevatedButton(
              onPressed: () {
                double KvValue = double.tryParse(kv_group) ?? 0.0;
                double KrValue = double.tryParse(Kr) ?? 0.0;
                double PH = 23.0;
                double tan_phi = 1.58;
                double Un = 0.38;
                double Pp = KrValue * sum_of_n_Pn_Kv_product_41;
                double Qp = KvValue * PH * tan_phi;
                double Sp = sqrt(Pp * Pp + Qp * Qp);
                double Ip = Pp / Un;
                double KvDepartment = 752.0 / 2330.0;
                double n_e = (2330.0 * 2330.0) / 96399.0;
                setState(() {
                  rozrah_act_nav = Pp.toString();
                  rozrah_react_nav = Qp.toString();
                  full_power = Sp.toString();
                  rozrah_group_strum_shr1 = Ip.toString();
                  total_department_util_coef = KvDepartment.toString();
                  eff_ep_department_amount = n_e.toString();
                });
              },
              child: Text("Обчислити"),
            ),
            SizedBox(height: 8),
            Text("розрахункове активне навантаження: " + rozrah_act_nav,
                style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            Text("розрахункове реактивне навантаження: " + rozrah_react_nav,
                style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            Text("повна потужність: " + full_power,
                style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            Text("розрахунковий груповий струм ШР1: " + rozrah_group_strum_shr1,
                style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            Text("коефіцієнт використання цеху в цілому: " +
                total_department_util_coef,
                style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            Text("ефективна кількість ЕП цеху в цілому: " +
                eff_ep_department_amount,
                style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            TextField(
              controller: _kr2Controller,
              decoration: InputDecoration(
                  labelText: "розрахунковий коеф активної потужності"),
              onChanged: (val) {
                Kr2 = val;
              },
            ),
            ElevatedButton(
              onPressed: () {
                double KvValue = double.tryParse(Kr2) ?? 0.0;
                double Pp = KvValue * 752.0;
                double Qp = KvValue * 657.0;
                double Sp = sqrt(Pp * Pp + Qp * Qp);
                double Ip = Pp / 0.38;
                setState(() {
                  rozrah_act_nav_shin = Pp.toString();
                  rozrah_react_nav_shin = Qp.toString();
                  full_power_shin = Sp.toString();
                  rozrah_group_strum_shin = Ip.toString();
                });
              },
              child: Text("Обчислити"),
            ),
            SizedBox(height: 8),
            Text("розрахункове активне навантаження на шинах 0,38 кВ ТП: " +
                    rozrah_act_nav_shin,
                style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            Text("розрахункове реактивне навантаження на шинах 0,38 кВ ТП: " +
                    rozrah_react_nav_shin,
                style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            Text("повна потужність на шинах 0,38 кВ ТП: " + full_power_shin,
                style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(height: 8),
            Text("розрахунковий груповий струм на шинах 0,38 кВ ТП: " +
                    rozrah_group_strum_shin,
                style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }
}
