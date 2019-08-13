import 'package:aqueduct/aqueduct.dart';

import 'game.dart';

class _ScoreBoard {
    @primaryKey
    int id;

    @Column(nullable: false)
    String name;

    @Relate(#scoreBoards, isRequired: true, onDelete: DeleteRule.cascade)
    Game game;

    ManagedSet<Score> scores;
}

class ScoreBoard extends ManagedObject<_ScoreBoard> implements _ScoreBoard {}

class _Score {
    @primaryKey
    int id;

    @Column(nullable: false, indexed: true)
    String playerId;

    @Relate(#scores, isRequired: true, onDelete: DeleteRule.cascade)
    ScoreBoard scoreBoard;
}

class Score extends ManagedObject<_Score> implements _Score {}