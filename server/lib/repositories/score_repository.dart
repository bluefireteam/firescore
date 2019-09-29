import 'package:aqueduct/aqueduct.dart';
import '../model/score.dart';

class ScoreRepository {
  ScoreRepository(this.context);

  final ManagedContext context;

  Future<List<Score>> listScoresFromBoard(
      ScoreBoard board,
      { bool asc = true, int limit = 100, String playerId }
  ) async {
    var scoreQuery = Query<Score>(context)
        ..where((s) => s.scoreBoard.id).equalTo(board.id)
        ..sortBy((s) => s.score, asc ? QuerySortOrder.ascending : QuerySortOrder.descending)
        ..fetchLimit = 100;

    if (playerId != null) {
      scoreQuery = scoreQuery
          ..where((s) => s.playerId).equalTo(playerId);
    }

    return await scoreQuery.fetch();
  }
}
