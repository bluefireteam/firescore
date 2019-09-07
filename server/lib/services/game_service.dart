import 'dart:async';
import 'package:aqueduct/aqueduct.dart';

import '../model/account.dart';
import '../model/game.dart';

class GameService {
  GameService(this.context);

  final ManagedContext context;

  Future<Game> createGameForAccount(Game game, Account account) async {
    game.account = account;

    return await context.insertObject(game);
  }

  Future<void> deleteGameForAccount(int gameId, Account account) async {
    final query = Query<Game>(context)
        ..where((game) => game.account.id).equalTo(account.id)
        ..where((game) => game.id).equalTo(gameId);

    await query.delete();
  }
}

