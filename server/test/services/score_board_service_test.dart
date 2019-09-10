import 'package:firescore/services/score_board_service.dart';
import 'package:firescore/repositories/game_repository.dart';
import 'package:firescore/model/score.dart';
import '../data_creator_helper/accounts_creator.dart';
import '../data_creator_helper/games_creator.dart';
import '../data_creator_helper/score_board_creator.dart';
import '../harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  test("#createScoreBoard", () async {
    final context = harness.application.channel.context;
    final account =  await AccountsCreator(context).createAccount();
    final game = await GamesCreator(context).createGame(account);

    final scoreBoard = ScoreBoard()
        ..name = "points";
    await ScoreBoardService(context).createScoreBoard(game, scoreBoard);

    final games = await GameRepository(context).fetchGamesFromAccountById(game.id, account.id, includeScoreBoards: true);

    expect(games.scoreBoards.length, equals(1));
  });

  test("#deleteScoreBoardFromGame", () async {
    final context = harness.application.channel.context;
    final account =  await AccountsCreator(context).createAccount();
    final game = await GamesCreator(context).createGame(account);

    final scoreBoard = await ScoreBoardsCreator(context).createScoreBoard(game);

    await ScoreBoardService(context).deleteScoreBoardFromGame(scoreBoard.id, game.id);

    final updatedGame = await GameRepository(context).fetchGamesFromAccountById(game.id, account.id, includeScoreBoards: true);
    expect(updatedGame.scoreBoards.length, equals(0));
  });
}
