part of 'database_bloc.dart';

abstract class DatabaseState extends Equatable {
  const DatabaseState();

  @override
  List<Object> get props => [];
}

class DatabaseInitial extends DatabaseState {}

class DogesLoading extends DatabaseState {}

class DogesLoaded extends DatabaseState {
  final List<Doge> dogeList;
  const DogesLoaded({required this.dogeList});
}

class DogesLoadError extends DatabaseState {
  final String errorCode;
  const DogesLoadError({required this.errorCode});
}
