import 'dart:async';
import 'package:aqueduct/aqueduct.dart';
import 'package:uuid/uuid.dart';

import '../model/account.dart';
import '../model/game.dart';
import '../model/score.dart';
import '../util.dart';

class AccountPasswordVerifier implements AuthValidator {
    AccountPasswordVerifier(this.context);

    final ManagedContext context;

    @override
    List<APISecurityRequirement> documentRequirementsForAuthorizer(APIDocumentContext context, Authorizer authorizer, {List<AuthScope> scopes}) {
        return null;
    }

    @override
    FutureOr<Authorization> validate<T>(AuthorizationParser<T> parser, T authorizationData, {List<AuthScope> requiredScope}) async {
        final credentials = authorizationData as AuthBasicCredentials;

        final query = Query<Account>(context)
                ..where((a) => a.email).equalTo(credentials.username);

        final fetchedAccount = await query.fetchOne();

        if (fetchedAccount != null) {
            if (fetchedAccount.password == credentials.password) {
                return Authorization(null, null, this, credentials: credentials);
            }
        }

        return null;
    }
}

Map<String, dynamic> _mapAccount(Account account) => {
    "id": account.id,
    "email": account.email,
};


Future<Account> _getAccount(Request request, ManagedContext context) async {
    final email = request.authorization.credentials.username;

    final query = Query<Account>(context)
            ..where((a) => a.email).equalTo(email);

    return await query.fetchOne();
}

class AdminAccountController  extends ResourceController {
    AdminAccountController(this.context);

    final ManagedContext context;

    @Operation.get()
    Future<Response> getAccount() async {
        final account = await _getAccount(request, context);

        return Response.ok(_mapAccount(account));
    }

}

class CreateAccountController extends ResourceController {
    CreateAccountController(this.context);

    final ManagedContext context;


    @Operation.post()
    Future<Response> createAccount(@Bind.body() Account account) async {
        account.password = generateMd5(account.password);

        final insertedAccount = await context.insertObject(account);

        return Response.ok(_mapAccount(insertedAccount));
    }
}

class ManageGamesController extends ResourceController {
    ManageGamesController(this.context);

    final ManagedContext context;

    @Operation.post()
    Future<Response> createGame(@Bind.body() Game game) async {
        game.account = await _getAccount(request, context);

        final insertedGame = await context.insertObject(game);

        return Response.ok(insertedGame);
    }

    @Operation.get()
    Future<Response> getGames() async {
        final account = await _getAccount(request, context);

        final query = Query<Game>(context)
                ..where((game) => game.account.id).equalTo(account.id);

        final games = await query.fetch();

        return Response.ok(games);
    }

    @Operation.delete('gameId')
    Future<Response> deleteGame(@Bind.path('gameId') int id) async {
        final account = await _getAccount(request, context);

        final query = Query<Game>(context)
                ..where((game) => game.account.id).equalTo(account.id)
                ..where((game) => game.id).equalTo(id);

        await query.delete();

        return Response.noContent();
    }
}

class ManageScoreBoardController extends ResourceController {
    ManageScoreBoardController(this.context);

    final ManagedContext context;
    final _uuid = Uuid();

    Future<Game> _fetchGame(int gameId, { bool fetchScoreBoards = false }) async {

        final account = await _getAccount(request, context);
        final query = Query<Game>(context)
                ..where((game) => game.account.id).equalTo(account.id)
                ..where((game) => game.id).equalTo(gameId);

        if (fetchScoreBoards) {
            query.join(set: (game) => game.scoreBoards);
        }

        return await query.fetchOne();
    }

    @Operation.post('gameId')
    Future<Response> createScoreBoard(@Bind.path('gameId') int gameId, @Bind.body() ScoreBoard scoreBoard) async {
        final game = await _fetchGame(gameId);

        if (game != null) {

            scoreBoard.uuid = _uuid.v4();
            scoreBoard.game = game;

            final insertScoreBoard = await context.insertObject(scoreBoard);
            return Response.ok(insertScoreBoard);
        } else {
            return Response.notFound();
        }
    }

    @Operation.get('gameId')
    Future<Response> listScoreBoards(@Bind.path('gameId') int gameId) async {
        final game = await _fetchGame(gameId, fetchScoreBoards: true);

        if (game != null) {
            return Response.ok(game.scoreBoards);
        } else {
            return Response.notFound();
        }
    }

    @Operation.delete('gameId', 'scoreBoardId')
    Future<Response> deleteScoreBoard(@Bind.path('gameId') int gameId, @Bind.path('scoreBoardId') int scoreBoardId) async {
        final game = await _fetchGame(gameId, fetchScoreBoards: true);

        if (game != null) {
            final query = Query<ScoreBoard>(context)
                    ..where((scoreBoard) => scoreBoard.id).equalTo(scoreBoardId);

            await query.delete();

            return Response.noContent();
        } else {
            return Response.notFound();
        }
    }
}
