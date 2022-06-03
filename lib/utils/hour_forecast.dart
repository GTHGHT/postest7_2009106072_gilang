import 'constants.dart';

class HourForecast{
  int hour;
  String image;
  double temp;

  HourForecast({required this.hour, required this.image, required this.temp});

  factory HourForecast.fromFirestore(Map<String, dynamic> data){
    return HourForecast(
      hour: data['hour'],
      image: data['image'],
      temp: data['temp'],
    );
  }

  factory HourForecast.empty(){
    return HourForecast(
      hour: 0,
      image: kWeatherImageList[0],
      temp: 0,
    );
  }
}