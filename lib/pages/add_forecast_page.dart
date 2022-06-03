import 'package:flutter/material.dart';
import 'package:postest7_2009106072_gilang/utils/firestore_services.dart';
import 'package:provider/provider.dart';

import '../utils/constants.dart';
import '../utils/forecast_notifier.dart';

class AddForecastPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Ramalan"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.read<ForecastNotifier>().clear();
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            DropdownButton<String>(
              value: context.select<ForecastNotifier, String>((e) => e.type),
              style: Theme.of(context).textTheme.headlineSmall,
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              items: <String>[
                'Jam',
                'Hari',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: !context.watch<ForecastNotifier>().update
                  ? (value) {
                      context.read<ForecastNotifier>().type = value ?? 'Jam';
                    }
                  : null,
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: context.watch<ForecastNotifier>().type == "Jam"
                  ? HourForecastPage()
                  : DayForecastPage(),
            ),
          ],
        ),
      ),
    );
  }
}

class HourForecastPage extends StatefulWidget {
  const HourForecastPage({
    Key? key,
  }) : super(key: key);

  @override
  State<HourForecastPage> createState() => _HourForecastPageState();
}

class _HourForecastPageState extends State<HourForecastPage> {
  TextEditingController hourController = TextEditingController();
  TextEditingController tempController = TextEditingController();

  @override
  void dispose() {
    hourController.dispose();
    tempController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<ForecastNotifier>().update &&
        tempController.text.isEmpty &&
        hourController.text.isEmpty) {
      setState(() {
        hourController.text =
            context.read<ForecastNotifier>().hourForecast.hour.toString();
        tempController.text =
            context.read<ForecastNotifier>().hourForecast.temp.toString();
      });
    }
    return Column(
      children: [
        TextField(
          controller: hourController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Jam',
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onChanged: (value) {
            context.read<ForecastNotifier>().setHourForecastHour(
                  int.tryParse(value) ?? 0,
                );
          },
        ),
        SizedBox(
          height: 20,
        ),
        TextField(
          controller: tempController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Temperatur',
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onChanged: (value) {
            context.read<ForecastNotifier>().setHourForecastTemp(
                  double.tryParse(value) ?? 0.0,
                );
          },
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView.separated(
            itemBuilder: (_, index) {
              return ListTile(
                leading: Radio<String>(
                  value: kWeatherImageList[index],
                  groupValue:
                      context.watch<ForecastNotifier>().hourForecast.image,
                  onChanged: (value) {
                    context
                        .read<ForecastNotifier>()
                        .setHourForecastImage(value ?? "");
                  },
                ),
                title: Image.asset(
                  kWeatherImageList[index],
                  height: 44,
                  width: 44,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : null,
                ),
                onTap: () {
                  context
                      .read<ForecastNotifier>()
                      .setHourForecastImage(kWeatherImageList[index]);
                },
              );
            },
            separatorBuilder: (_, __) => Divider(),
            itemCount: kWeatherImageList.length,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            context.read<ForecastNotifier>().update
                ? FirestoreServices.updateHourForecast(
                    context.read<ForecastNotifier>().id,
                    context.read<ForecastNotifier>().hourForecast,
                  ).then((value) {
                    context.read<ForecastNotifier>().clear();
                    Navigator.pop(context);
                  })
                : FirestoreServices.addHourForecast(
                        context.read<ForecastNotifier>().hourForecast)
                    .then((value) {
                    context.read<ForecastNotifier>().clear();
                    Navigator.pop(context);
                  });
          },
          child: Text(
            "${context.read<ForecastNotifier>().update ? 'Update' : 'Tambah'} Ramalan",
          ),
        ),
      ],
    );
  }
}

class DayForecastPage extends StatefulWidget {
  DayForecastPage({
    Key? key,
  }) : super(key: key);

  @override
  State<DayForecastPage> createState() => _DayForecastPageState();
}

class _DayForecastPageState extends State<DayForecastPage> {
  TextEditingController tempController = TextEditingController();
  TextEditingController feelsLikeController = TextEditingController();

  @override
  void dispose() {
    tempController.dispose();
    feelsLikeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (context.watch<ForecastNotifier>().update &&
        tempController.text.isEmpty &&
        feelsLikeController.text.isEmpty) {
      setState(() {
        tempController.text =
            context.watch<ForecastNotifier>().dayForecast.temp.toString();
        feelsLikeController.text =
            context.watch<ForecastNotifier>().dayForecast.feelsLike.toString();
      });
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(context.watch<ForecastNotifier>().dayForecast.getDateString()),
            SizedBox(width: 25,),
            OutlinedButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate:
                      context.read<ForecastNotifier>().dayForecast.date,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(Duration(days: 30)),
                );
                if (picked != null) {
                  context.read<ForecastNotifier>().setDayForecastDate(picked);
                }
              },
              child: Text("Pilih Tanggal"),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        TextField(
          controller: tempController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Temperatur',
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onChanged: (value) {
            context.read<ForecastNotifier>().setDayForecastTemp(
                  double.tryParse(value) ?? 0.0,
                );
          },
        ),
        SizedBox(
          height: 20,
        ),
        TextField(
          controller: feelsLikeController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Terasa Seperti',
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          onChanged: (value) {
            context.read<ForecastNotifier>().setDayForecastFeelsLike(
                  double.tryParse(value) ?? 0.0,
                );
          },
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: ListView.separated(
            itemBuilder: (_, index) {
              return ListTile(
                leading: Radio<String>(
                  value: kWeatherImageList[index],
                  groupValue:
                      context.watch<ForecastNotifier>().dayForecast.image,
                  onChanged: (value) {
                    context
                        .read<ForecastNotifier>()
                        .setDayForecastImage(value ?? "");
                  },
                ),
                title: Image.asset(
                  kWeatherImageList[index],
                  height: 44,
                  width: 44,
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : null,
                ),
                onTap: () {
                  context
                      .read<ForecastNotifier>()
                      .setDayForecastImage(kWeatherImageList[index]);
                },
              );
            },
            separatorBuilder: (_, __) => Divider(),
            itemCount: kWeatherImageList.length,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () async {
            context.read<ForecastNotifier>().update
                ? await FirestoreServices.updateDayForecast(
                    context.read<ForecastNotifier>().id,
                    context.read<ForecastNotifier>().dayForecast,
                  ).then((value) {
                    context.read<ForecastNotifier>().clear();
                    Navigator.pop(context);
                  })
                : await FirestoreServices.addDayForecast(
                        context.read<ForecastNotifier>().dayForecast)
                    .then((value) {
                    context.read<ForecastNotifier>().clear();
                    Navigator.pop(context);
                  });
          },
          child: Text(
            "${context.read<ForecastNotifier>().update ? 'Update' : 'Tambah'} Ramalan",
          ),
        ),
      ],
    );
  }
}