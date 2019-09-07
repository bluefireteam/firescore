import 'dart:async';
import 'package:aqueduct/aqueduct.dart';
import 'package:firescore/model/account.dart';
import 'package:firescore/model/game.dart';

class GamesCreator {
  GamesCreator(this.context);

  final ManagedContext context;

  Future<Game> createGame(Account account, { String name = "Tales of a Lost Mine" }) async {
    final game = Game()
        ..name = name
        ..account = account;

    return await context.insertObject(game);
  }
}
