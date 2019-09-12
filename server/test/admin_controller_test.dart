import 'dart:convert';
import 'package:firescore/repositories/account_repository.dart';
import 'package:firescore/repositories/game_repository.dart';
import 'data_creator_helper/accounts_creator.dart';
import 'data_creator_helper/games_creator.dart';
import 'data_creator_helper/score_board_creator.dart';
import 'harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  String _generateAuthorizaiton(String email, String password) {
    return base64.encode(utf8.encode("${email}:${password}"));
  }

  test("GET /admin/account returns the ScoreBoard token", () async {
    final insertedAccount =  await AccountsCreator(harness.application.channel.context).createAccount();
    final authentication = _generateAuthorizaiton(insertedAccount.email, insertedAccount.password);

    expectResponse(await harness.agent.get("/admin/account", headers: {
      "Authorization": "Basic $authentication",
    }), 200,
        body: {
          "id": insertedAccount.id,
          "email": insertedAccount.email,
        }
    );
  });

  test("POST /accounts creates a new account", () async {
    await harness.agent.post("/accounts", body: {
      "email": "bla@bla.com",
      "password": "123password",
    }, headers: {
      "Authorization": "Basic ${_generateAuthorizaiton("donvito", "corleone")}"
    });

    final accounts = await AccountRepository(harness.application.channel.context).fetchAll();
    expect(accounts.length, equals(1));
  });

  test("POST /accounts without property password, returns 401", () async {
    expectResponse(await harness.agent.post("/accounts", body: {
      "email": "bla@bla.com",
      "password": "123password",
    }), 401);
  });

  test("POST /admin/games creates a new game", () async {
    final insertedAccount =  await AccountsCreator(harness.application.channel.context).createAccount();
    final authentication = _generateAuthorizaiton(insertedAccount.email, insertedAccount.password);

    expectResponse(await harness.agent.post("/admin/games", body: { "name": "BGUG" }, headers: {
      "Authorization": "Basic $authentication",
    }), 200,
        body: {
          "id": 1,
          "name": "BGUG",
          "account": { "id": insertedAccount.id }
        }
    );
  });

  test("GET /admin/games lists all the games from that account", () async {
    final insertedAccount =  await AccountsCreator(harness.application.channel.context).createAccount();
    final authentication = _generateAuthorizaiton(insertedAccount.email, insertedAccount.password);

    final bgug = await GamesCreator(harness.application.channel.context).createGame(insertedAccount, name: "BGUG");
    final bob = await GamesCreator(harness.application.channel.context).createGame(insertedAccount, name: "Bob Box");

    expectResponse(await harness.agent.get("/admin/games", headers: {
      "Authorization": "Basic $authentication",
    }), 200,
        body: [{
          "id": bgug.id,
          "name": "BGUG",
          "account": { "id": insertedAccount.id }
        }, {
          "id": bob.id,
          "name": "Bob Box",
          "account": { "id": insertedAccount.id }
        }]
    );
  });

  test("DELETE /admin/games/:gameId deletes a game", () async {
    final insertedAccount =  await AccountsCreator(harness.application.channel.context).createAccount();
    final authentication = _generateAuthorizaiton(insertedAccount.email, insertedAccount.password);

    final context = harness.application.channel.context;
    final bgug = await GamesCreator(context).createGame(insertedAccount, name: "BGUG");
    await GamesCreator(context).createGame(insertedAccount, name: "Bob Box");

    await harness.agent.delete("/admin/games/${bgug.id}", headers: {
      "Authorization": "Basic $authentication",
    });

    final games = await GameRepository(context).fetchGamesFromAccount(insertedAccount);
    expect(games.length, equals(1));
  });

  test("POST /admin/games/:gameId/score_boards creates a scoreboard for that game", () async {
    final insertedAccount =  await AccountsCreator(harness.application.channel.context).createAccount();
    final authentication = _generateAuthorizaiton(insertedAccount.email, insertedAccount.password);

    final context = harness.application.channel.context;
    final bgug = await GamesCreator(context).createGame(insertedAccount, name: "BGUG");
    await harness.agent.post("/admin/games/${bgug.id}/score_boards",
        headers: {
          "Authorization": "Basic $authentication",
        },
        body: {
          "name": "Points",
        }
    );

    final updatedBgug = await GameRepository(context).fetchGamesFromAccountById(bgug.id, insertedAccount.id, includeScoreBoards: true);
    expect(updatedBgug.scoreBoards.length, equals(1));
  });

  test("GET /admin/games/:gameId/score_boards returns the scoreboard list from that game", () async {
    final insertedAccount =  await AccountsCreator(harness.application.channel.context).createAccount();
    final authentication = _generateAuthorizaiton(insertedAccount.email, insertedAccount.password);

    final context = harness.application.channel.context;
    final bgug = await GamesCreator(context).createGame(insertedAccount, name: "BGUG");

    final coinsScoreBoard = await ScoreBoardsCreator(context).createScoreBoard(bgug, name: "Coins");
    final pointsScoreBoard = await ScoreBoardsCreator(context).createScoreBoard(bgug, name: "Points");

    expectResponse(await harness.agent.get("/admin/games/${bgug.id}/score_boards", headers: {
      "Authorization": "Basic $authentication",
    }), 200, body: [{
      "id": coinsScoreBoard.id,
      "name": "Coins",
      "uuid": coinsScoreBoard.uuid,
      "game": { "id": bgug.id}
    }, {
      "id": pointsScoreBoard.id,
      "name": "Points",
      "uuid": pointsScoreBoard.uuid,
      "game": { "id": bgug.id}}
    ]);
  });

  test("DELETE /admin/games/:gameId/score_boards/:scoreboardId deletes a scoreboard for that game", () async {
    final insertedAccount =  await AccountsCreator(harness.application.channel.context).createAccount();
    final authentication = _generateAuthorizaiton(insertedAccount.email, insertedAccount.password);

    final context = harness.application.channel.context;
    final bgug = await GamesCreator(context).createGame(insertedAccount, name: "BGUG");
    final pointsScoreBoard = await ScoreBoardsCreator(context).createScoreBoard(bgug);

    await harness.agent.delete("/admin/games/${bgug.id}/score_boards/${pointsScoreBoard.id}",
        headers: {
          "Authorization": "Basic $authentication",
        }
    );

    final updatedBgug = await GameRepository(context).fetchGamesFromAccountById(bgug.id, insertedAccount.id, includeScoreBoards: true);
    expect(updatedBgug.scoreBoards.length, equals(0));
  });
}
