import 'dart:convert';
import 'package:firescore/repositories/account_repository.dart';
import 'data_creator_helper/accounts_creator.dart';
import 'harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  test("GET /admin/account returns the ScoreBoard token", () async {
    final insertedAccount =  await AccountsCreator(harness.application.channel.context).createAccount();

    final authentication = base64.encode(utf8.encode("${insertedAccount.email}:${insertedAccount.password}"));

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
    });

    final accounts = await AccountRepository(harness.application.channel.context).fetchAll();
    expect(accounts.length, equals(1));
  });
}
