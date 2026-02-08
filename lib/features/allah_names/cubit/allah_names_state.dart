part of 'allah_names_cubit.dart';

abstract class AllahNamesState {}

class AllahNamesInitial extends AllahNamesState {}

class AllahNamesLoaded extends AllahNamesState {
  final List<AsmaaAllahModel> names;

  AllahNamesLoaded(this.names);
}

class AllahNameSelected extends AllahNamesState {
  final AsmaaAllahModel selectedName;

  AllahNameSelected(this.selectedName);
}