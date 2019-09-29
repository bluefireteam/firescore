import 'package:firescore/repositories/score_repository.dart';
import '../data_creator_helper/accounts_creator.dart';
import '../data_creator_helper/games_creator.dart';
import '../data_creator_helper/score_board_creator.dart';
import '../harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  test("#fetchGamesFromAccount", () async {
    final context = harness.application.channel.context;
    final account = await AccountsCreator(context).createAccount();
    final game = await GamesCreator(context).createGame(account);
    final scoreBoard = await ScoreBoardsCreator(context).createScoreBoard(game);
    
    await ScoreBoardsCreator(context).createScore(scoreBoard);
    await ScoreBoardsCreator(context).createScore(scoreBoard, playerId: "Don Vito");

    final result = await ScoreRepository(context).listScoresFromBoard(scoreBoard);

    expect(result.length, equals(2));
  });
}
