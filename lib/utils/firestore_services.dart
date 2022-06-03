import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:postest7_2009106072_gilang/utils/day_forecast.dart';
import 'package:postest7_2009106072_gilang/utils/hour_forecast.dart';

class FirestoreServices {
  static final _firestore = FirebaseFirestore.instance;

  static Stream<QuerySnapshot> getHourForecast() {
    return _firestore.collection("hour").snapshots();
  }

  static Stream<QuerySnapshot> getDayForecast() {
    return _firestore.collection("day").snapshots();
  }

  static Future<void> addHourForecast(HourForecast hour) async {
    await _firestore.collection("hour").add({
      'hour': hour.hour,
      'image': hour.image,
      'temp': hour.temp,
    });
  }

  static Future<void> addDayForecast(DayForecast day) async {
    await _firestore.collection("day").add({
      'date': Timestamp.fromDate(day.date),
      'image': day.image,
      'temp': day.temp,
      'feelsLike': day.feelsLike,
    });
  }

  static Future<void> updateDayForecast(String id, DayForecast day) async{
    await _firestore.collection("day").doc(id).set({
      'date': Timestamp.fromDate(day.date),
      'image': day.image,
      'temp': day.temp,
      'feelsLike': day.feelsLike,
    });
  }

  static Future<void> updateHourForecast(String id, HourForecast hour) async{
    await _firestore.collection("hour").doc(id).set({
      'hour': hour.hour,
      'image': hour.image,
      'temp': hour.temp,
    });
  }

  static Future<void> deleteDayForecast(String id) async {
    await _firestore.collection("day").doc(id).delete();
  }

  static Future<void> deleteHourForecast(String id) async {
    await _firestore.collection("hour").doc(id).delete();
  }
}