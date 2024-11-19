import 'package:flutter/material.dart';
import 'package:myapp/models/lost_object_model.dart';
import 'package:myapp/services/db_service.dart';
import 'package:myapp/utils/util_functions.dart';
import 'package:sqflite/sqflite.dart';

class LostObjectsProvider with ChangeNotifier {
  List<LostObject> _lostObjects = [];
  bool _isLoading = false;
  DateTime? _dateFilter;
  List<String> _stationFilter = [];
  List<String> _allStations = [];
  List<String> _typeFilter = [];
  List<String> _allTypes = [];
  List<String> _natureFilter = [];
  List<String> _allNatures = [];
  String _orderBy = 'date';
  String _orderByDirection = 'desc';

  List<LostObject> get lostObjects => _lostObjects;
  bool get isLoading => _isLoading;
  DateTime? get dateFilter => _dateFilter;
  List<String> get stationFilter => _stationFilter;
  List<String> get allStations => _allStations;
  List<String> get natureFilter => _natureFilter;
  List<String> get allNatures => _allNatures;
  List<String> get typeFilter => _typeFilter;
  List<String> get allTypes => _allTypes;

  LostObjectsProvider() {
    initLostObjetcts();
  }

  void setSelectedDate(DateTime newDate) {
    _dateFilter = newDate;
    getLostObjects();
  }

  void resetDate() {
    _dateFilter = null;
    getLostObjects();
  }

  Future<void> setSelectedStations(List<String> stations) async {
    _stationFilter = stations;
    getLostObjects();
  }

  Future<void> setSelectedNatures(List<String> natures) async {
    _natureFilter = natures;
    getLostObjects();
  }

  Future<void> setSelectedTypes(List<String> types) async {
    _typeFilter = types;
    getLostObjects();
  }

  void setSelectedSort(String orderBy, String direction) {
    _orderBy = orderBy;
    _orderByDirection = direction;
    getLostObjects();
  }

  Future<void> getFiltersOptions() async {
    Database? db = await getDB();
    _isLoading = true;
    notifyListeners();
    _allStations = await retrieveStations(db!);
    _allNatures = await retrieveNatures(db);
    _allTypes = await retrieveTypes(db);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> initLostObjetcts() async {
    getFiltersOptions();
    await getLostObjects();
  }

  bool hasFilter() {
    return (_dateFilter != null ||
        _typeFilter.isNotEmpty ||
        _typeFilter.isNotEmpty ||
        _stationFilter.isNotEmpty);
  }

  Future<void> getLostObjects() async {
    Database? db = await getDB();
    _isLoading = true;
    notifyListeners();

    String minDate = '';
    String maxDate = '';

    if (hasFilter()) {
      if (dateFilter != null) {
        DateTime originalDate = DateTime.parse(
            formatDate(_dateFilter.toString(), "yyyy-MM-dd'T'HH:mm:ssZ"));
        DateTime startOfDay =
            DateTime(originalDate.year, originalDate.month, originalDate.day);
        minDate = startOfDay.toIso8601String();
        DateTime endOfDay = startOfDay.add(const Duration(days: 1));
        maxDate = endOfDay.toIso8601String();
      }
    }
    _lostObjects = await retrieveItems(db!,
        startStation: stationFilter,
        nature: natureFilter,
        type: typeFilter,
        minDate: minDate,
        maxDate: maxDate,
        orderBy: _orderBy,
        orderByDirection: _orderByDirection);
    _isLoading = false;
    notifyListeners();
  }
}
