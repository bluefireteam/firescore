import 'package:firescore/services/game_service.dart';
import 'package:firescore/model/game.dart';
import 'package:firescore/repositories/game_repository.dart';
import '../data_creator_helper/accounts_creator.dart';
import '../data_creator_helper/games_creator.dart';
import '../harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  test("#createGameForAccount", () async {
    final context = harness.application.channel.context;
    final account =  await AccountsCreator(context).createAccount();

    final game = Game()
        ..name = "Tales";

    await GameService(context).createGameForAccount(game, account);

    final games = await GameRepository(context).fetchGamesFromAccount(account);
    expect(games.length, equals(1));
  });

  test("#deleteGameForAccount", () async {
    final context = harness.application.channel.context;
    final account =  await AccountsCreator(context).createAccount();

    await GamesCreator(context).createGame(account, name: "Bob");
    final bgug = await GamesCreator(context).createGame(account, name: "Bgug");

    await GameService(context).deleteGameForAccount(bgug.id, account);

    final games = await GameRepository(context).fetchGamesFromAccount(account);
    expect(games.length, equals(1));
  });
}
