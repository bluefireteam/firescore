import 'dart:async';
import 'package:aqueduct/aqueduct.dart';
import '../model/account.dart';
import '../model/game.dart';

class GameRepository {
  GameRepository(this.context);

  final ManagedContext context;

  Future<List<Game>> fetchGamesFromAccount(Account account) async {
    final query = Query<Game>(context)
        ..where((game) => game.account.id).equalTo(account.id);

    return await query.fetch();
  }

  Future<Game> fetchGamesFromAccountById(int gameId, int accountId, { bool includeScoreBoards = false } ) async {
    final query = Query<Game>(context)
        ..where((game) => game.account.id).equalTo(accountId)
        ..where((game) => game.id).equalTo(gameId);

    if (includeScoreBoards) {
      query.join(set: (game) => game.scoreBoards);
    }

    return await query.fetchOne();
  }
}
