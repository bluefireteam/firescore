import 'dart:async';
import 'package:aqueduct/aqueduct.dart';

import '../model/account.dart';
import '../model/game.dart';
import '../model/score.dart';

import '../repositories/account_repository.dart';
import '../repositories/game_repository.dart';

import '../services/account_service.dart';
import '../services/game_service.dart';
import '../services/score_board_service.dart';

class MasterAccountVerifier implements AuthValidator {
  MasterAccountVerifier(this.masterUser, this.masterPassword);

  final String masterUser;
  final String masterPassword;

  @override
  List<APISecurityRequirement> documentRequirementsForAuthorizer(APIDocumentContext context, Authorizer authorizer, {List<AuthScope> scopes}) {
    return null;
  }

  @override
  FutureOr<Authorization> validate<T>(AuthorizationParser<T> parser, T authorizationData, {List<AuthScope> requiredScope}) async {
    final credentials = authorizationData as AuthBasicCredentials;

    if (credentials.username == masterUser && credentials.password == masterPassword) {
      return Authorization(null, null, this, credentials: credentials);
    }

    return null;
  }
}
class AccountPasswordVerifier implements AuthValidator {
  AccountPasswordVerifier(this.accountRepository);

  final AccountRepository accountRepository;

  @override
  List<APISecurityRequirement> documentRequirementsForAuthorizer(APIDocumentContext context, Authorizer authorizer, {List<AuthScope> scopes}) {
    return null;
  }

  @override
  FutureOr<Authorization> validate<T>(AuthorizationParser<T> parser, T authorizationData, {List<AuthScope> requiredScope}) async {
    final credentials = authorizationData as AuthBasicCredentials;

    final fetchedAccount = await accountRepository.findByEmail(credentials.username);

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


Future<Account> _getAccount(Request request, AccountRepository repository) async {
  final email = request.authorization.credentials.username;

  return await repository.findByEmail(email);
}

class AdminAccountController  extends ResourceController {
  AdminAccountController(this.repository);

  final AccountRepository repository;

  @Operation.get()
  Future<Response> getAccount() async {
    final account = await _getAccount(request, repository);

    return Response.ok(_mapAccount(account));
  }

}

class CreateAccountController extends ResourceController {
  CreateAccountController(this.service);

  final AccountService service;


  @Operation.post()
  Future<Response> createAccount(@Bind.body() Account account) async {
    final insertedAccount = await service.createAccount(account);

    return Response.ok(_mapAccount(insertedAccount));
  }
}

class ManageGamesController extends ResourceController {
  ManageGamesController(this.accountRepository, this.repository, this.service);

  final AccountRepository accountRepository;
  final GameRepository repository;
  final GameService service;

  @Operation.post()
  Future<Response> createGame(@Bind.body() Game game) async {
    final account = await _getAccount(request, accountRepository);

    final insertedGame = await service.createGameForAccount(game, account);

    return Response.ok(insertedGame);
  }

  @Operation.get()
  Future<Response> getGames() async {
    final account = await _getAccount(request, accountRepository);

    final games = await repository.fetchGamesFromAccount(account);

    return Response.ok(games);
  }

  @Operation.delete('gameId')
  Future<Response> deleteGame(@Bind.path('gameId') int id) async {
    final account = await _getAccount(request, accountRepository);

    await service.deleteGameForAccount(id, account);

    return Response.noContent();
  }
}

class ManageScoreBoardController extends ResourceController {
  ManageScoreBoardController(this.context, this.repository, this.gameRepository, this.scoreBoardService);

  final ManagedContext context;
  final AccountRepository repository;
  final GameRepository gameRepository;
  final ScoreBoardService scoreBoardService;

  @Operation.post('gameId')
  Future<Response> createScoreBoard(@Bind.path('gameId') int gameId, @Bind.body() ScoreBoard scoreBoard) async {
    final account = await _getAccount(request, repository);
    final game = await gameRepository.fetchGamesFromAccountById(gameId, account.id);

    if (game != null) {
      final insertScoreBoard = await scoreBoardService.createScoreBoard(game, scoreBoard);
      return Response.ok(insertScoreBoard);
    } else {
      return Response.notFound();
    }
  }

  @Operation.get('gameId')
  Future<Response> listScoreBoards(@Bind.path('gameId') int gameId) async {
    final account = await _getAccount(request, repository);
    final game = await gameRepository.fetchGamesFromAccountById(gameId, account.id, includeScoreBoards: true);

    if (game != null) {
      return Response.ok(game.scoreBoards);
    } else {
      return Response.notFound();
    }
  }

  @Operation.delete('gameId', 'scoreBoardId')
  Future<Response> deleteScoreBoard(@Bind.path('gameId') int gameId, @Bind.path('scoreBoardId') int scoreBoardId) async {
    final account = await _getAccount(request, repository);
    final game = await gameRepository.fetchGamesFromAccountById(gameId, account.id);

    if (game != null) {
      await scoreBoardService.deleteScoreBoardFromGame(scoreBoardId, gameId);

      return Response.noContent();
    } else {
      return Response.notFound();
    }
  }
}
