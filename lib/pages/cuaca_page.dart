import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../pages/details_page.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../utils/constants.dart';

class CuacaPage extends StatelessWidget {
  const CuacaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: const BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Samarinda, Indonesia",
              style: kWeatherTitleTextStyle,
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              "27 April, 2022",
              style: kWeatherSubtitleTextStyle,
            ),
            const SizedBox(
              height: 30,
            ),
            Image.asset(
              "images/clear_white.png",
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : null,
            ),
            const SizedBox(
              height: 60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 20,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GradientText(
                            "30",
                            style: kWeatherTempTextStyle,
                            gradientType: GradientType.linear,
                            colors:
                                Theme.of(context).brightness == Brightness.light
                                    ? [
                                        Colors.black,
                                        Colors.grey,
                                        Colors.grey.shade300
                                      ]
                                    : [
                                        Colors.white,
                                        Colors.grey,
                                        Colors.grey.shade700
                                      ],
                          ),
                          const Text(
                            "°",
                            style: kWeatherTempTextStyle,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          const Text(
                            "Feels Like: ",
                            style: kWeatherSubtitleTextStyle,
                          ),
                          Text(
                            "36°",
                            style: kLandingButtonTextStyle.copyWith(
                              fontSize: 20,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2 - 20,
                  child: const Text(
                    "Humid and Mostly Cloudy",
                    style: kWeatherDescTextStyle,
                    softWrap: true,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade200
                    : Colors.grey.shade800,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              height: 90,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "06:00",
                            style: kWeatherAttrTextStyle2,
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            "Terbit",
                            style: kWeatherAttrTextStyle1,
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "18:00",
                            style: kWeatherAttrTextStyle2,
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          Text(
                            "Terbenam",
                            style: kWeatherAttrTextStyle1,
                          ),
                        ],
                      )
                    ],
                  ),
                  Positioned(
                    bottom: 5,
                    child: CustomPaint(
                      painter: ArcPainter(
                        height: 120,
                        width: 200,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.black.withAlpha(150)
                            : Colors.white.withAlpha(150),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey.shade300
                      : Colors.grey.shade800,
                  onPrimary: Theme.of(context).brightness == Brightness.light
                      ? Colors.black
                      : Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const DetailsPage(),
                    ),
                  );
                },
                icon: const Icon(Icons.info_outline),
                label: const Text("Details"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArcPainter extends CustomPainter {
  double height;
  double width;
  Color color;

  ArcPainter({required this.height, required this.width, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect =
        Rect.fromCenter(center: Offset.zero, width: width, height: height);
    const startAngle = 0.0;
    const sweepAngle = -math.pi;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}