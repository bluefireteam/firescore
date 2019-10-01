import 'dart:async';
import 'package:aqueduct/aqueduct.dart';
import 'package:corsac_jwt/corsac_jwt.dart';

import '../model/score.dart';
import '../repositories/score_repository.dart';
import '../services/score_board_service.dart';

String _generateToken(String secret, String scoreBoardUui) {
  final builder = JWTBuilder()
      ..issuer = 'https://score.fireslime.xyz'
      ..expiresAt = DateTime.now().add(Duration(minutes: 3))
      ..setClaim('data', {'scoreBoardUui': scoreBoardUui});

  final signer = JWTHmacSha256Signer(secret);
  final signedToken = builder.getSignedToken(signer);
  return signedToken.toString();
}

bool _verifyToken(String secret, String token) {
  final signer = JWTHmacSha256Signer(secret);
  final decodedToken = JWT.parse(token);

  final validator = JWTValidator();
  final errors = validator.validate(decodedToken);
  return decodedToken.verify(signer) && errors.isEmpty;
}

Map<String, dynamic> _getTokenInfo(String secret, String token) {
  final decodedToken = JWT.parse(token);

  return decodedToken.claims;
}
class JwtVerifier implements AuthValidator {

  JwtVerifier(this._jwtSecret);

  final String _jwtSecret;

  @override
  List<APISecurityRequirement> documentRequirementsForAuthorizer(APIDocumentContext context, Authorizer authorizer, {List<AuthScope> scopes}) {
    return null;
  }

  @override
  FutureOr<Authorization> validate<T>(AuthorizationParser<T> parser, T authorizationData, {List<AuthScope> requiredScope}) async {
    final bearer = authorizationData as String;


    if (_verifyToken(_jwtSecret, bearer)) {
      return Authorization(null, null, this);
    }

    return null;
  }
}

class GetTokenController extends ResourceController {
  GetTokenController(this._jwtSecret);

  final String _jwtSecret;

  @Operation.get('scoreBoardUui')
  Future<Response> createToken(@Bind.path('scoreBoardUui') String scoreBoardUui) async {
    return Response.ok({ "token": _generateToken(_jwtSecret, scoreBoardUui) });
  }
}

class CreateScoreController extends ResourceController {
  CreateScoreController(this.context, this._jwtSecret);

  final ManagedContext context;
  final String _jwtSecret;

  @Operation.put()
  Future<Response> createScore(@Bind.body() Score score, @Bind.header('Authorization') String authorization) async {

    final claims = _getTokenInfo(_jwtSecret, authorization.replaceFirst('Bearer ', ''));

    final data = claims['data'];
    final scoreBoardUui = data['scoreBoardUui'] as String;

    final query = Query<ScoreBoard>(context)
        ..where((s) => s.uuid).equalTo(scoreBoardUui);

    final fetchedScoreBoard = await query.fetchOne();

    await ScoreBoardService(context).createScore(fetchedScoreBoard, score);

    return Response.noContent();
  }
}

Map<String, dynamic> _mapScore(Score score) => {
  'playerId': score.playerId,
  'score': score.score,
  'metadata': score.metadata
};

class ListScoreController extends ResourceController {
  ListScoreController(this.context);

  final ManagedContext context;

  @Operation.get('scoreBoardUui')
  Future<Response> listScores(
      @Bind.path('scoreBoardUui') String scoreBoardUui,
      @Bind.query("sortOrder") String sortOrder,
      { @Bind.query("playerId") String playerId }
  ) async {
    final scoreBoardQuery = Query<ScoreBoard>(context)
        ..where((s) => s.uuid).equalTo(scoreBoardUui);

    final fetchedScoreBoard = await scoreBoardQuery.fetchOne();

    final scores = await ScoreRepository(context).listScoresFromBoard(
        fetchedScoreBoard,
        asc: sortOrder == "ASC",
        playerId: playerId
    );

    return Response.ok(scores.map(_mapScore).toList());
  }
}

class ListUniquePlayerIdController extends ResourceController {
  ListUniquePlayerIdController(this.persistentStore);

  final PersistentStore persistentStore;

  @Operation.get('scoreBoardUui')
  Future<Response> listScores(
      @Bind.path('scoreBoardUui') String scoreBoardUui,
  ) async {

    final result = await persistentStore.execute(
        "select playerId from _score join _scoreboard on _score.scoreboard_id = _scoreboard.id where _scoreboard.uuid = @uuid",
        substitutionValues: { "uuid": scoreBoardUui }
    );

    return Response.ok(
        result.map((row) => row[0]).toList()
    );
  }
}
