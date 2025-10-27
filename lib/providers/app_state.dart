import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/recipe.dart';

class AppState extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;
  List<Recipe> all = [];
  final Set<String> favorites = {};
  final Map<String, List<String>> planner = {
    "Mon": [],
    "Tue": [],
    "Wed": [],
    "Thu": [],
    "Fri": [],
    "Sat": [],
    "Sun": []
  };

  Future<void> init() async {
    await _loadRecipes();
    await _loadPrefs();
  }

  Future<void> _loadRecipes() async {
    final raw = await rootBundle.loadString('assets/recipes.json');
    final data = json.decode(raw) as List;
    all = data.map((e) => Recipe.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> _loadPrefs() async {
    final sp = await SharedPreferences.getInstance();
    favorites.addAll(sp.getStringList('favorites') ?? []);
    final tm = sp.getString('theme') ?? 'light';
    themeMode = tm == 'dark' ? ThemeMode.dark : ThemeMode.light;
    final pRaw = sp.getString('planner');
    if (pRaw != null) {
      final Map<String, dynamic> decoded = json.decode(pRaw);
      decoded.forEach((k, v) => planner[k] = List<String>.from(v));
    }
    notifyListeners();
  }

  Future<void> _savePrefs() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setStringList('favorites', favorites.toList());
    await sp.setString('planner', json.encode(planner));
    await sp.setString('theme', themeMode == ThemeMode.dark ? 'dark' : 'light');
  }

  void toggleFavorite(String id) {
    favorites.contains(id) ? favorites.remove(id) : favorites.add(id);
    _savePrefs();
    notifyListeners();
  }

  void addToPlanner(String day, String id) {
    final list = planner[day] ?? [];
    if (!list.contains(id)) list.add(id);
    planner[day] = list;
    _savePrefs();
    notifyListeners();
  }

  void removeFromPlanner(String day, String id) {
    planner[day]?.remove(id);
    _savePrefs();
    notifyListeners();
  }

  void clearAll() {
    favorites.clear();
    for (final k in planner.keys) {
      planner[k] = [];
    }
    _savePrefs();
    notifyListeners();
  }

  void setTheme(ThemeMode mode) {
    themeMode = mode;
    _savePrefs();
    notifyListeners();
  }
}
