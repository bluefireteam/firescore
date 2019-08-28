import 'package:aqueduct/aqueduct.dart';

import 'account.dart';
import 'score.dart';

class _Game {
    @primaryKey
    int id;

    @Column(nullable: false)
    String name;

    @Relate(#games, isRequired: true, onDelete: DeleteRule.cascade)
    Account account;

    ManagedSet<ScoreBoard> scoreBoards;
}

class Game extends ManagedObject<_Game> implements _Game {}
