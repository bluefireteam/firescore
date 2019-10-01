import 'dart:async';
import 'package:aqueduct/aqueduct.dart';
import 'package:uuid/uuid.dart';

import '../model/game.dart';
import '../model/score.dart';

class ScoreBoardService {
  ScoreBoardService(this.context);

  final ManagedContext context;
  final _uuid = Uuid();

  Future<ScoreBoard> createScoreBoard(Game game, ScoreBoard scoreBoard) async {
    scoreBoard.uuid = _uuid.v4();
    scoreBoard.game = game;

    return await context.insertObject(scoreBoard);
  }

  Future<void> deleteScoreBoardFromGame(int scoreBoardId, int gameId) async {
    final query = Query<ScoreBoard>(context)
        ..where((scoreBoard) => scoreBoard.id).equalTo(scoreBoardId)
        ..where((scoreBoard) => scoreBoard.game.id).equalTo(gameId);

    await query.delete();
  }

  Future<void> createScore(ScoreBoard board, Score score) async {
    score.scoreBoard = board;

    await context.transaction((transaction) async {

      final query = Query<Score>(transaction)
          ..where((s) => s.scoreBoard.id).equalTo(board.id)
          ..where((s) => s.playerId).equalTo(score.playerId);

      await query.delete();
      await transaction.insertObject(score);
    });
  }
}

