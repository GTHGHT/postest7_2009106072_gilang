import 'package:flutter/widgets.dart';

import 'day_forecast.dart';
import 'hour_forecast.dart';

class ForecastNotifier extends ChangeNotifier {
  HourForecast _hourForecast = HourForecast.empty();
  DayForecast _dayForecast = DayForecast.empty();
  String _id = "";
  bool _update = false;
  String _type = 'Jam';

  void updateHourForecast(HourForecast hourForecast, String id) {
    _type = 'Jam';
    _hourForecast = hourForecast;
    _id = id;
    _update = true;
    notifyListeners();
  }

  void updateDayForecast(DayForecast dayForecast, String id) {
    _type = 'Hari';
    _dayForecast = dayForecast;
    _id = id;
    _update = true;
    notifyListeners();
  }

  String get id => _id;

  String get type => _type;

  set type(String value) {
    _type = value;
    notifyListeners();
  }

  bool get update => _update;

  set update(bool value) {
    _update = value;
    notifyListeners();
  }

  DayForecast get dayForecast => _dayForecast;

  set dayForecast(DayForecast value) {
    _dayForecast = value;
    notifyListeners();
  }

  void setDayForecastDate(DateTime date) {
    _dayForecast.date = date;
    notifyListeners();
  }

  void setDayForecastImage(String image) {
    _dayForecast.image = image;
    notifyListeners();
  }

  void setDayForecastTemp(double temp) {
    _dayForecast.temp = temp;
    notifyListeners();
  }

  set hourForecast(HourForecast value) {
    _hourForecast = value;
  }

  void setDayForecastFeelsLike(double feelsLike) {
    _dayForecast.feelsLike = feelsLike;
    notifyListeners();
  }

  HourForecast get hourForecast => _hourForecast;

  void setHourForecastHour(int hour) {
    _hourForecast.hour = hour;
    notifyListeners();
  }

  void setHourForecastImage(String image) {
    _hourForecast.image = image;
    notifyListeners();
  }

  void setHourForecastTemp(double temp) {
    _hourForecast.temp = temp;
    notifyListeners();
  }

  void clear(){
    _dayForecast = DayForecast.empty();
    _hourForecast = HourForecast.empty();
    _update = false;
    notifyListeners();
  }
}