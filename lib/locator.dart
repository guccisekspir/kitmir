import 'package:get_it/get_it.dart';
import 'package:kitmir/blocs/databaseBloc/bloc/database_bloc.dart';
import 'package:kitmir/data/databaseRepository.dart';
import 'package:kitmir/data/dbApiClient.dart';
import 'package:kitmir/helpers/notificationHelper.dart';

GetIt getIt = GetIt.instance;

setupLocator() {
  getIt.registerLazySingleton<DatabaseRepository>(() => DatabaseRepository());
  getIt.registerLazySingleton<DatabaseApiClient>(() => DatabaseApiClient());

  getIt.registerLazySingleton<NotificationHelper>(() => NotificationHelper());

  getIt.registerLazySingleton<DatabaseBloc>(() => DatabaseBloc());
}
