import 'dart:async';
import 'package:aqueduct/aqueduct.dart';
import 'package:firescore/model/game.dart';
import 'package:firescore/model/score.dart';
import 'package:uuid/uuid.dart';

class ScoreBoardsCreator {
  ScoreBoardsCreator(this.context);

  final ManagedContext context;

  Future<ScoreBoard> createScoreBoard(Game game, {
    String name = "Points",
    String uuid,
  }) async {
    final _uuid = uuid ?? Uuid().v4();

    final scoreBoard = ScoreBoard()
        ..game = game
        ..name = name
        ..uuid = _uuid;

    return await context.insertObject(scoreBoard);
  }
}

