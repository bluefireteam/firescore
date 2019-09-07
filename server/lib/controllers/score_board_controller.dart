import 'dart:async';
import 'package:aqueduct/aqueduct.dart';
import 'package:corsac_jwt/corsac_jwt.dart';

import '../model/score.dart';

String _generateToken(String secret, String scoreBoardUui) {
  final builder = JWTBuilder()
      ..issuer = 'https://firescore.fireslime.xyz'
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

  @Operation.post()
  Future<Response> createScore(@Bind.body() Score score, @Bind.header('Authorization') String authorization) async {

    final claims = _getTokenInfo(_jwtSecret, authorization.replaceFirst('Bearer ', ''));

    final data = claims['data'];
    final scoreBoardUui = data['scoreBoardUui'] as String;

    final query = Query<ScoreBoard>(context)
        ..where((s) => s.uuid).equalTo(scoreBoardUui);

    final fetchedScoreBoard = await query.fetchOne();

    score.scoreBoard = fetchedScoreBoard;

    await context.insertObject(score);

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

    var scoreQuery = Query<Score>(context)
        ..where((s) => s.scoreBoard.id).equalTo(fetchedScoreBoard.id)
        ..sortBy((s) => s.score, sortOrder == "ASC" ? QuerySortOrder.ascending : QuerySortOrder.descending)
        ..fetchLimit = 100;

    if (playerId != null) {
      scoreQuery = scoreQuery
          ..where((s) => s.playerId).equalTo(playerId);
    }

    final scores = await scoreQuery.fetch();

    return Response.ok(scores.map(_mapScore).toList());
  }
}
