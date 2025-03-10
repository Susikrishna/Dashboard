import 'dart:convert';
import 'package:dashbaord/models/time_table_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dashbaord/models/mess_menu_model.dart';
import 'package:dashbaord/utils/bus_schedule.dart';

class SharedService {
  static const String _keyName = 'user_name';
  static const String _keyEmail = 'user_email';
  static const String _keyImageUrl = 'user_image_url';
  static const String _keyTimetable = 'timetable';
  static const String _keyMessMenu = 'mess_menu';
  static const String _keyBusSchedule = 'bus_schedule';
  static const String _keyCityBusSchedule = 'city_bus_schedule';

  Future<void> saveUserDetails({
    required String name,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyName, name);
    await prefs.setString(_keyEmail, email);
  }

  Future<void> saveUserImage({
    required String image,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyImageUrl, image);
  }

  Future<Map<String, String?>> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_keyName);
    final email = prefs.getString(_keyEmail);
    final imageUrl = prefs.getString(_keyImageUrl);
    return {
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
    };
  }

  Future<void> clearUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyName);
    await prefs.remove(_keyEmail);
    await prefs.remove(_keyImageUrl);
  }

  Future<Timetable?> getTimetable() async {
    final prefs = await SharedPreferences.getInstance();
    final String? timetableJson = prefs.getString(_keyTimetable);

    if (timetableJson != null) {
      final Map<String, dynamic> timetableMap = json.decode(timetableJson);
      return Timetable.fromJson(timetableMap);
    }

    return null;
  }

  Future<void> saveTimetable(Timetable timetable) async {
    final prefs = await SharedPreferences.getInstance();
    final String timetableJson = json.encode(timetable.toJson());
    await prefs.setString(_keyTimetable, timetableJson);
  }

  Future<void> saveMessMenu(MessMenuModel messMenu) async {
    final prefs = await SharedPreferences.getInstance();
    final messMenuJson = jsonEncode(messMenu.toJson());
    await prefs.setString(_keyMessMenu, messMenuJson);
  }

  Future<MessMenuModel?> getMessMenu() async {
    final prefs = await SharedPreferences.getInstance();
    final messMenuJson = prefs.getString(_keyMessMenu);
    if (messMenuJson != null) {
      final Map<String, dynamic> messMenuMap = jsonDecode(messMenuJson);
      return MessMenuModel.fromJson(messMenuMap);
    }
    return null;
  }

  Future<void> saveBusSchedule(BusSchedule busSchedule) async {
    final prefs = await SharedPreferences.getInstance();
    final busScheduleJson = jsonEncode(busSchedule.toJson());
    await prefs.setString(_keyBusSchedule, busScheduleJson);
  }

  Future<void> saveCityBusSchedule(CityBusSchedule cityBusSchedule) async {
    final prefs = await SharedPreferences.getInstance();
    final cityBusScheduleJson = jsonEncode(cityBusSchedule.toJson());
    await prefs.setString(_keyCityBusSchedule, cityBusScheduleJson);
  }

  Future<BusSchedule?> getBusSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final busScheduleJson = prefs.getString(_keyBusSchedule);
    if (busScheduleJson != null) {
      final Map<String, dynamic> busScheduleMap = jsonDecode(busScheduleJson);
      return BusSchedule.fromJson(busScheduleMap);
    }
    return null;
  }

  Future<CityBusSchedule?> getCityBusSchedule() async {
    final prefs = await SharedPreferences.getInstance();
    final cityBusScheduleJson = prefs.getString(_keyCityBusSchedule);
    if (cityBusScheduleJson != null) {
      final Map<String, dynamic> cityBusScheduleMap = jsonDecode(cityBusScheduleJson);
      return CityBusSchedule.fromJson(cityBusScheduleMap);
    }
    return null;
  }

  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
