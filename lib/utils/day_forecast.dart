import 'constants.dart';

class DayForecast {
  DateTime date;
  String image;
  double temp;
  double feelsLike;

  DayForecast(
      {required this.date,
      required this.image,
      required this.temp,
      required this.feelsLike});

  String getDateString(){
    return "${date.day}-${date.month}-${date.year}";
  }

  factory DayForecast.empty() {
    return DayForecast(
      date: DateTime.now(),
      image: kWeatherImageList[0],
      temp: 0,
      feelsLike: 0,
    );
  }
}