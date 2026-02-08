import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_colors.dart';
import '../data/tasbih_data.dart';

class TasbihController extends ChangeNotifier {
  int counter = 0;
  int goalIndex = 2; // Default: 33
  int selectedTasbihIndex = 0;
  int customGoal1 = 0;
  int customGoal2 = 0;
  List<TasbihItem> tasbihList = [];

  List<int> goals = TasbihData.defaultGoals;

  TasbihController() {
    _loadData();
  }

  // Load saved data
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    // Load tasbih list (default + custom)
    final savedList = prefs.getString('tasbih_list');
    if (savedList != null) {
      final List<dynamic> decoded = json.decode(savedList);
      tasbihList = decoded.map((e) => TasbihItem.fromJson(e)).toList();
    } else {
      tasbihList = [...TasbihData.defaultTasbihList];
      // Add 2 empty custom slots
      tasbihList.add(TasbihItem(arabicText: '', isCustom: true));
      tasbihList.add(TasbihItem(arabicText: '', isCustom: true));
    }

    // Load counter for selected tasbih
    selectedTasbihIndex = prefs.getInt('selected_tasbih_index') ?? 0;
    counter = prefs.getInt('counter_$selectedTasbihIndex') ?? 0;

    // Load goal
    goalIndex = prefs.getInt('goal_index') ?? 2;
    customGoal1 = prefs.getInt('custom_goal_1') ?? 0;
    customGoal2 = prefs.getInt('custom_goal_2') ?? 0;

    notifyListeners();
  }

  // Save data
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();

    // Save tasbih list
    final encoded = json.encode(tasbihList.map((e) => e.toJson()).toList());
    await prefs.setString('tasbih_list', encoded);

    // Save counter for current tasbih
    await prefs.setInt('counter_$selectedTasbihIndex', counter);

    // Save selected tasbih
    await prefs.setInt('selected_tasbih_index', selectedTasbihIndex);

    // Save goal
    await prefs.setInt('goal_index', goalIndex);
    await prefs.setInt('custom_goal_1', customGoal1);
    await prefs.setInt('custom_goal_2', customGoal2);
  }

  // Increment counter
  void incrementCounter(BuildContext context) {
    counter++;
    _saveData();
    notifyListeners();

    // Check if goal reached
    int currentGoal = getCurrentGoal();
    if (counter >= currentGoal) {
      _onGoalReached(context);
    }
  }

  // Reset counter
  void resetCounter() {
    counter = 0;
    _saveData();
    notifyListeners();
  }

  // Change selected tasbih
  Future<void> selectTasbih(int index) async {
    // Save current counter before switching
    await _saveData();

    selectedTasbihIndex = index;

    // Load counter for new tasbih
    final prefs = await SharedPreferences.getInstance();
    counter = prefs.getInt('counter_$index') ?? 0;

    notifyListeners();
  }

  // Change goal
  void setGoal(int index) {
    goalIndex = index;
    _saveData();
    notifyListeners();
  }

  // Set custom goal
  void setCustomGoal(int goal) {
    if (goalIndex == goals.length) {
      customGoal1 = goal;
    } else if (goalIndex == goals.length + 1) {
      customGoal2 = goal;
    }
    _saveData();
    notifyListeners();
  }

  // Get current goal
  int getCurrentGoal() {
    if (goalIndex == goals.length) {
      return customGoal1 > 0 ? customGoal1 : 10;
    } else if (goalIndex == goals.length + 1) {
      return customGoal2 > 0 ? customGoal2 : 10;
    }
    return goals[goalIndex];
  }

  // Get custom goal value for display
  int getCustomGoalValue() {
    if (goalIndex == goals.length) {
      return customGoal1;
    } else if (goalIndex == goals.length + 1) {
      return customGoal2;
    }
    return 0;
  }

  // Edit custom tasbih
  Future<void> editCustomTasbih(int index, String text) async {
    if (index < tasbihList.length && tasbihList[index].isCustom) {
      tasbihList[index] = TasbihItem(arabicText: text, isCustom: true);
      await _saveData();
      notifyListeners();
    }
  }

  // Goal reached
  void _onGoalReached(BuildContext context) {
    counter = 0;
    _saveData();
    notifyListeners();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'مَبْرُوكٌ! 🎉 لَقَدْ أَتْمَمْتَ ${getCurrentGoal()} تَسْبِيحَةً',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'cairo',
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}