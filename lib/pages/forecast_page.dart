import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:postest7_2009106072_gilang/utils/day_forecast.dart';
import 'package:postest7_2009106072_gilang/utils/firestore_services.dart';
import 'package:postest7_2009106072_gilang/utils/forecast_notifier.dart';
import 'package:postest7_2009106072_gilang/utils/hour_forecast.dart';
import 'package:provider/provider.dart';

import '../utils/constants.dart';
import 'add_forecast_page.dart';


class ForecastPage extends StatelessWidget {
  const ForecastPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Ramalan Cuaca Per Jam",
            style: kWeatherTitleTextStyle,
          ),
          const SizedBox(
            height: 20,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: FirestoreServices.getHourForecast(),
            builder: (context, snapshot) {
              Widget defaultEmptyReturn = const Center(
                child: Text("Ramalan Kosong"),
              );
              if (!(snapshot.hasData)) {
                return defaultEmptyReturn;
              }
              final hourForecasts = snapshot.data!.docs.toList();
              if (hourForecasts.isEmpty) {
                return defaultEmptyReturn;
              }

              return SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, index) {
                    HourForecast hourForecast = HourForecast(
                      hour: (hourForecasts[index]['hour'] as num).toInt(),
                      image: hourForecasts[index]["image"],
                      temp: (hourForecasts[index]["temp"] as num).toDouble(),
                    );
                    return Card(
                      child: HourForecastGrid(
                        hourForecast: hourForecast,
                        id: hourForecasts[index].id,
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const VerticalDivider(),
                  itemCount: hourForecasts.length,
                ),
              );
            },
          ),
          const SizedBox(
            height: 30,
          ),
          const Text(
            "Ramalan Cuaca Per Hari",
            style: kWeatherTitleTextStyle,
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirestoreServices.getDayForecast(),
              builder: (context, snapshot) {
                Widget defaultEmptyReturn = const Center(
                  child: Text("Ramalan Kosong"),
                );
                if (!(snapshot.hasData)) {
                  return defaultEmptyReturn;
                }
                final dayForecasts = snapshot.data!.docs.toList();
                if (dayForecasts.isEmpty) {
                  return defaultEmptyReturn;
                }

                return ListView.separated(
                  itemBuilder: (_, index) {
                    DayForecast dayForecast = DayForecast(
                      date: (dayForecasts[index]['date'] as Timestamp).toDate(),
                      image: dayForecasts[index]['image'],
                      temp: (dayForecasts[index]['temp'] as num).toDouble(),
                      feelsLike:
                          (dayForecasts[index]['feelsLike'] as num).toDouble(),
                    );
                    return DayForecastCard(
                      id: dayForecasts[index].id,
                      dayForecast: dayForecast,
                    );
                  },
                  separatorBuilder: (_, __) => const Divider(),
                  itemCount: dayForecasts.length,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HourForecastGrid extends StatelessWidget {
  final String id;
  final HourForecast hourForecast;

    const HourForecastGrid({
    Key? key,
    required this.id,
    required this.hourForecast,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (dialogContext) {
              return AlertDialog(
                title: Text("${hourForecast.hour}:00"),
                content: SizedBox(
                  height: 100,
                  child: Column(
                    children: [
                      Image.asset(
                        hourForecast.image,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : null,
                        width: 64,
                        height: 64,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${hourForecast.temp}°",
                        style: kWeatherSubtitleTextStyle,
                      ),
                    ],
                  ),
                ),
                titleTextStyle: kWeatherTitleTextStyle.copyWith(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
                alignment: Alignment.center,
                actions: [
                  TextButton(
                    child: Text(
                      "Hapus",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onPressed: () async {
                      context.read<ForecastNotifier>().clear();
                      await FirestoreServices.deleteHourForecast(id);
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                  TextButton(
                    child: Text(
                      "Ubah",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onPressed: () {
                      context
                          .read<ForecastNotifier>()
                          .updateHourForecast(hourForecast, id);
                      Navigator.pushReplacement(
                        dialogContext,
                        MaterialPageRoute(builder: (_) => AddForecastPage()),
                      );
                    },
                  ),
                  TextButton(
                    child: Text(
                      "Tutup",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                ],
              );
            });
      },
      child: SizedBox(
        height: 100,
        width: 100,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("${hourForecast.hour}:00"),
              Image.asset(
                hourForecast.image,
                height: 40,
                width: 40,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : null,
              ),
              Text("${hourForecast.temp}°")
            ],
          ),
        ),
      ),
    );
  }
}

class DayForecastCard extends StatelessWidget {
  final String id;
  final DayForecast dayForecast;

  const DayForecastCard({
    Key? key,
    required this.id,
    required this.dayForecast,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (dialogContext) {
              return AlertDialog(
                title: Text(dayForecast.getDateString()),
                content: SizedBox(
                  height: 100,
                  child: Column(
                    children: [
                      Image.asset(
                        dayForecast.image,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black
                            : null,
                        width: 64,
                        height: 64,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "${dayForecast.temp}° | ${dayForecast.feelsLike}°",
                        style: kWeatherSubtitleTextStyle,
                      ),
                    ],
                  ),
                ),
                titleTextStyle: kWeatherTitleTextStyle.copyWith(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
                alignment: Alignment.center,
                actions: [
                  TextButton(
                    child: Text(
                      "Hapus",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onPressed: () {
                      FirestoreServices.deleteDayForecast(id).then(
                        (value) => Navigator.of(dialogContext).pop(),
                      );
                    },
                  ),
                  TextButton(
                    child: Text(
                      "Ubah",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onPressed: () {
                      context
                          .read<ForecastNotifier>()
                          .updateDayForecast(dayForecast, id);
                      Navigator.pushReplacement(
                        dialogContext,
                        MaterialPageRoute(builder: (_) => AddForecastPage()),
                      );
                    },
                  ),
                  TextButton(
                    child: Text(
                      "Tutup",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                ],
              );
            });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                dayForecast.getDateString(),
                style: kWeatherAttrTextStyle2,
              ),
            ),
            Expanded(
              child: Image.asset(
                dayForecast.image,
                width: 44,
                height: 44,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black
                    : null,
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "${dayForecast.temp}°",
                  style: kDayForecastTempTextStyle,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "${dayForecast.feelsLike}°",
                  style: kDayForecastTempTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}