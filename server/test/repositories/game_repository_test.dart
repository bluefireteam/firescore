
import 'package:firescore/repositories/game_repository.dart';
import '../data_creator_helper/accounts_creator.dart';
import '../data_creator_helper/games_creator.dart';
import '../data_creator_helper/score_board_creator.dart';
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

  test("#fetchGamesFromAccountById", () async { 
    final context = harness.application.channel.context;
    final account = await AccountsCreator(harness.application.channel.context).createAccount();
    final bgug = await GamesCreator(context).createGame(account, name: "BGUG");
    final pointScoreBoard = await ScoreBoardsCreator(context).createScoreBoard(bgug);

    final fetchedGame = await GameRepository(context).fetchGamesFromAccountById(bgug.id, account.id);
    expect(fetchedGame.id, equals(bgug.id));

    final fetchedGameWithScoreBoards = await GameRepository(context).fetchGamesFromAccountById(bgug.id, account.id, includeScoreBoards: true);
    expect(fetchedGameWithScoreBoards.scoreBoards.length, equals(1));
    expect(fetchedGameWithScoreBoards.scoreBoards[0].id, equals(pointScoreBoard.id));
  });
}

