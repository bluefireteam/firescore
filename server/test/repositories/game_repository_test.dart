
import 'package:firescore/repositories/game_repository.dart';
import '../data_creator_helper/accounts_creator.dart';
import '../data_creator_helper/games_creator.dart';
import '../harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  test("#fetchGamesFromAccount", () async {
    final context = harness.application.channel.context;
    final account = await AccountsCreator(harness.application.channel.context).createAccount();
    await GamesCreator(context).createGame(account, name: "BGUG");
    await GamesCreator(context).createGame(account, name: "Bob Box");

    final games = await GameRepository(context).fetchGamesFromAccount(account);
    expect(games.length, equals(2));
  });
}

