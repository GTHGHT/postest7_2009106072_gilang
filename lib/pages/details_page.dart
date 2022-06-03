import 'package:flutter/material.dart';

import '../utils/constants.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double screenHeight =
        (MediaQuery.of(context).size.height - kToolbarHeight - 24);
    final double itemWidth = MediaQuery.of(context).size.width / 2;

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).brightness == Brightness.light
            ? Colors.black
            : Colors.white,
        title: const Text(
          "Samarinda, Indonesia",
          style: kWeatherTitleTextStyle,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          const Text(
            "Rabu, 27 April 2022",
            style: kWeatherSubtitleTextStyle,
          ),
          SizedBox(
            height: (screenHeight / 2) + 40,
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: (itemWidth / 128),
              padding: const EdgeInsets.all(20),
              children: const [
                DetailGridTile(
                  imageLocation: "images/thermometer_white.png",
                  title: "Min|Max",
                  subtitle: "23.7|23.7",
                ),
                DetailGridTile(
                  imageLocation: "images/pressure_white.png",
                  title: "Pressure",
                  subtitle: "1009",
                ),
                DetailGridTile(
                  imageLocation: "images/haze_white.png",
                  title: "Visibility",
                  subtitle: "10000",
                ),
                DetailGridTile(
                  imageLocation: "images/humidity_white.png",
                  title: "Humidity",
                  subtitle: "23.7|23.7",
                ),
                DetailGridTile(
                  imageLocation: "images/wind_white.png",
                  title: "Wind",
                  subtitle: "1009",
                ),
                DetailGridTile(
                  imageLocation: "images/broken_white.png",
                  title: "Cloudiness",
                  subtitle: "10000",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailGridTile extends StatelessWidget {
  final String imageLocation;
  final String title;
  final String subtitle;

  const DetailGridTile({
    Key? key,
    required this.imageLocation,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16),
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.grey.shade300
            : Colors.grey.shade800,
      ),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(title),
                content: SizedBox(
                  height: 100,
                  child: Column(
                    children: [
                      Image.asset(
                        imageLocation,
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
                        subtitle,
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
                      "Tutup",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Row(
          children: [
            Image.asset(
              imageLocation,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : null,
              height: 44,
              width: 44,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: kWeatherAttrTextStyle2,
                ),
                Text(
                  subtitle,
                  style: kWeatherAttrTextStyle1,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}