import '../data/tasbih_data.dart';

abstract class TasbihState {}

class TasbihInitial extends TasbihState {}

class TasbihLoading extends TasbihState {}

class TasbihLoaded extends TasbihState {
  final int counter;
  final int goalIndex;
  final int selectedTasbihIndex;
  final int customGoal1;
  final int customGoal2;
  final List<TasbihItem> tasbihList;
  final List<int> goals;

  TasbihLoaded({
    required this.counter,
    required this.goalIndex,
    required this.selectedTasbihIndex,
    required this.customGoal1,
    required this.customGoal2,
    required this.tasbihList,
    required this.goals,
  });

  TasbihLoaded copyWith({
    int? counter,
    int? goalIndex,
    int? selectedTasbihIndex,
    int? customGoal1,
    int? customGoal2,
    List<TasbihItem>? tasbihList,
    List<int>? goals,
  }) {
    return TasbihLoaded(
      counter: counter ?? this.counter,
      goalIndex: goalIndex ?? this.goalIndex,
      selectedTasbihIndex: selectedTasbihIndex ?? this.selectedTasbihIndex,
      customGoal1: customGoal1 ?? this.customGoal1,
      customGoal2: customGoal2 ?? this.customGoal2,
      tasbihList: tasbihList ?? this.tasbihList,
      goals: goals ?? this.goals,
    );
  }
}

class TasbihGoalReached extends TasbihState {
  final int goalValue;

  TasbihGoalReached(this.goalValue);
}