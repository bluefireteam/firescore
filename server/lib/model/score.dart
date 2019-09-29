import 'package:aqueduct/aqueduct.dart';

import 'game.dart';

class _ScoreBoard {
    @primaryKey
    int id;

    @Column(nullable: false)
    String name;

    @Relate(#scoreBoards, isRequired: true, onDelete: DeleteRule.cascade)
    Game game;

    @Column(nullable: false)
    String uuid;


    ManagedSet<Score> scores;
}

class ScoreBoard extends ManagedObject<_ScoreBoard> implements _ScoreBoard {}

class _Score {
    @primaryKey
    int id;

    @Column(nullable: false, indexed: true)
    String playerId;

    @Column(nullable: false, indexed: true)
    double score;

    @Column(nullable: true, indexed: false)
    String metadata;

    @Relate(#scores, isRequired: true, onDelete: DeleteRule.cascade)
    ScoreBoard scoreBoard;
}

class Score extends ManagedObject<_Score> implements _Score {}
