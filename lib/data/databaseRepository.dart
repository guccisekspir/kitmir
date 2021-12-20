import 'package:kitmir/data/dbApiClient.dart';
import 'package:kitmir/locator.dart';
import 'package:kitmir/models/doge.dart';

class DatabaseRepository {
  DatabaseApiClient databaseApiClient = getIt<DatabaseApiClient>();

  Future<List<Doge>> getDoges() async {
    return databaseApiClient.getDoges();
  }
}
