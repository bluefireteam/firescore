import 'package:firescore/repositories/score_repository.dart';
import 'data_creator_helper/accounts_creator.dart';
import 'data_creator_helper/games_creator.dart';
import 'data_creator_helper/score_board_creator.dart';
import 'harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  test("PUT /scores creates a new score on the score board", () async {
    final context = harness.application.channel.context;
    final account = await AccountsCreator(context).createAccount();
    final game = await GamesCreator(context).createGame(account);
    final scoreBoard = await ScoreBoardsCreator(context).createScoreBoard(game);

    final response = await harness.agent.get("/scores/token/${scoreBoard.uuid}");

    final body = await response.body.decode();
    final token = body["token"];

    expectResponse(await harness.agent.put(
        "/scores",
        headers: {
          "Authorization": "Bearer ${token}"
        },
        body: {
          "playerId": "Tony Montana",
          "score": 300,
        }
    ), 204);

    final results = await ScoreRepository(context).listScoresFromBoard(scoreBoard);
    expect(results.length, equals(1));
  });

  test("PUT /scores twice, keeps only the last one", () async {
    final context = harness.application.channel.context;
    final account = await AccountsCreator(context).createAccount();
    final game = await GamesCreator(context).createGame(account);
    final scoreBoard = await ScoreBoardsCreator(context).createScoreBoard(game);

    final response = await harness.agent.get("/scores/token/${scoreBoard.uuid}");

    final body = await response.body.decode();
    final token = body["token"];

    for (var i = 1; i <= 2; i++) {
      expectResponse(await harness.agent.put(
              "/scores",
              headers: {
                "Authorization": "Bearer ${token}"
              },
              body: {
                "playerId": "Tony Montana",
                "score": 300 * i,
              }
      ), 204);
    }

    final results = await ScoreRepository(context).listScoresFromBoard(scoreBoard);
    expect(results.length, equals(1));
  });

  test("GET /scores gets the current scores", () async {
    final context = harness.application.channel.context;
    final account = await AccountsCreator(context).createAccount();
    final game = await GamesCreator(context).createGame(account);
    final scoreBoard = await ScoreBoardsCreator(context).createScoreBoard(game);
    await ScoreBoardsCreator(context).createScore(scoreBoard, playerId: "Player1", score: 10);
    await ScoreBoardsCreator(context).createScore(scoreBoard, playerId: "Player2", score: 12);

    // ASC
    expectResponse(await harness.agent.get("/scores/${scoreBoard.uuid}?sortOrder=ASC"), 200, body: [
      {
        "playerId": "Player1",
        "score": 10.0,
        "metadata": null
      },
      {
        "playerId": "Player2",
        "score": 12.0,
        "metadata": null
      },
    ]);

    // DESC
    expectResponse(await harness.agent.get("/scores/${scoreBoard.uuid}?sortOrder=DESC"), 200, body: [
      {
        "playerId": "Player2",
        "score": 12.0,
        "metadata": null
      },
      {
        "playerId": "Player1",
        "score": 10.0,
        "metadata": null
      },
    ]);

    //Single player score 
    expectResponse(await harness.agent.get("/scores/${scoreBoard.uuid}?sortOrder=DESC&playerId=Player1"), 200, body: [
      {
        "playerId": "Player1",
        "score": 10.0,
        "metadata": null
      },
    ]);
  });
}
