import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/tasbih_data.dart';
import 'tasbih_state.dart';

class TasbihCubit extends Cubit<TasbihState> {
  TasbihCubit() : super(TasbihInitial()) {
    _loadData();
  }

  // Load saved data
  Future<void> _loadData() async {
    emit(TasbihLoading());

    final prefs = await SharedPreferences.getInstance();

    // Load tasbih list (default + custom)
    List<TasbihItem> tasbihList;
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
    final selectedTasbihIndex = prefs.getInt('selected_tasbih_index') ?? 0;
    final counter = prefs.getInt('counter_$selectedTasbihIndex') ?? 0;

    // Load goal
    final goalIndex = prefs.getInt('goal_index') ?? 2;
    final customGoal1 = prefs.getInt('custom_goal_1') ?? 0;
    final customGoal2 = prefs.getInt('custom_goal_2') ?? 0;

    emit(TasbihLoaded(
      counter: counter,
      goalIndex: goalIndex,
      selectedTasbihIndex: selectedTasbihIndex,
      customGoal1: customGoal1,
      customGoal2: customGoal2,
      tasbihList: tasbihList,
      goals: TasbihData.defaultGoals,
    ));
  }

  // Save data
  Future<void> _saveData() async {
    if (state is! TasbihLoaded) return;

    final currentState = state as TasbihLoaded;
    final prefs = await SharedPreferences.getInstance();

    // Save tasbih list
    final encoded = json.encode(
      currentState.tasbihList.map((e) => e.toJson()).toList(),
    );
    await prefs.setString('tasbih_list', encoded);

    // Save counter for current tasbih
    await prefs.setInt(
      'counter_${currentState.selectedTasbihIndex}',
      currentState.counter,
    );

    // Save selected tasbih
    await prefs.setInt('selected_tasbih_index', currentState.selectedTasbihIndex);

    // Save goal
    await prefs.setInt('goal_index', currentState.goalIndex);
    await prefs.setInt('custom_goal_1', currentState.customGoal1);
    await prefs.setInt('custom_goal_2', currentState.customGoal2);
  }

  // Increment counter
  void incrementCounter() {
    if (state is! TasbihLoaded) return;

    final currentState = state as TasbihLoaded;
    final newCounter = currentState.counter + 1;
    final currentGoal = getCurrentGoal();

    emit(currentState.copyWith(counter: newCounter));
    _saveData();

    // Check if goal reached
    if (newCounter >= currentGoal) {
      emit(TasbihGoalReached(currentGoal));
      // Reset counter after goal reached
      emit(currentState.copyWith(counter: 0));
      _saveData();
    }
  }

  // Reset counter
  void resetCounter() {
    if (state is! TasbihLoaded) return;

    final currentState = state as TasbihLoaded;
    emit(currentState.copyWith(counter: 0));
    _saveData();
  }

  // Change selected tasbih
  Future<void> selectTasbih(int index) async {
    if (state is! TasbihLoaded) return;

    final currentState = state as TasbihLoaded;

    // Save current counter before switching
    await _saveData();

    // Load counter for new tasbih
    final prefs = await SharedPreferences.getInstance();
    final counter = prefs.getInt('counter_$index') ?? 0;

    emit(currentState.copyWith(
      selectedTasbihIndex: index,
      counter: counter,
    ));
  }

  // Change goal
  void setGoal(int index) {
    if (state is! TasbihLoaded) return;

    final currentState = state as TasbihLoaded;
    emit(currentState.copyWith(goalIndex: index));
    _saveData();
  }

  // Set custom goal
  void setCustomGoal(int goal) {
    if (state is! TasbihLoaded) return;

    final currentState = state as TasbihLoaded;

    if (currentState.goalIndex == currentState.goals.length) {
      emit(currentState.copyWith(customGoal1: goal));
    } else if (currentState.goalIndex == currentState.goals.length + 1) {
      emit(currentState.copyWith(customGoal2: goal));
    }
    _saveData();
  }

  // Get current goal
  int getCurrentGoal() {
    if (state is! TasbihLoaded) return 33;

    final currentState = state as TasbihLoaded;

    if (currentState.goalIndex == currentState.goals.length) {
      return currentState.customGoal1 > 0 ? currentState.customGoal1 : 10;
    } else if (currentState.goalIndex == currentState.goals.length + 1) {
      return currentState.customGoal2 > 0 ? currentState.customGoal2 : 10;
    }
    return currentState.goals[currentState.goalIndex];
  }

  // Get custom goal value for display
  int getCustomGoalValue() {
    if (state is! TasbihLoaded) return 0;

    final currentState = state as TasbihLoaded;

    if (currentState.goalIndex == currentState.goals.length) {
      return currentState.customGoal1;
    } else if (currentState.goalIndex == currentState.goals.length + 1) {
      return currentState.customGoal2;
    }
    return 0;
  }

  // Edit custom tasbih
  Future<void> editCustomTasbih(int index, String text) async {
    if (state is! TasbihLoaded) return;

    final currentState = state as TasbihLoaded;

    if (index < currentState.tasbihList.length &&
        currentState.tasbihList[index].isCustom) {
      final newList = List<TasbihItem>.from(currentState.tasbihList);
      newList[index] = TasbihItem(arabicText: text, isCustom: true);

      emit(currentState.copyWith(tasbihList: newList));
      await _saveData();
    }
  }
}