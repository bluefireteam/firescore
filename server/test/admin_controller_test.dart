import 'dart:convert';
import 'package:firescore/model/account.dart';
import 'package:firescore/util.dart';
import 'harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  test("GET /admin/account returns the ScoreBoard token", () async {

    final account = Account();
    account.email = "don@corleone.it";
    account.password = generateMd5("vito");

    final insertedAccount = await harness.application.channel.context.insertObject(account);

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

    final accounts = await Query<Account>(harness.application.channel.context).fetch();
    expect(accounts.length, equals(1));
  });
}
