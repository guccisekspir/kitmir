import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kitmir/data/databaseRepository.dart';
import 'package:kitmir/locator.dart';
import 'package:kitmir/models/doge.dart';

part 'database_event.dart';
part 'database_state.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  List<Doge>? dogeList;
  DatabaseRepository databaseRepository = getIt<DatabaseRepository>();

  DatabaseBloc() : super(DatabaseInitial()) {
    on<DatabaseEvent>((event, emit) async {
      if (event is GetDoges) {
        if (dogeList == null) {
          try {
            dogeList = await databaseRepository.getDoges();

            emit(DogesLoaded(dogeList: dogeList!));
          } on FirebaseException catch (e) {
            emit(DogesLoadError(errorCode: e.code));
          }
        } else {
          emit(DogesLoaded(dogeList: dogeList!));
        }
      }
    });
  }
}
