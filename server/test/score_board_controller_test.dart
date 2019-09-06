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

    print(base64.encode(utf8.encode(account.password)));

    expectResponse(await harness.agent.get("/admin/account", headers: {
      "Authorization": "Basic ${base64.encode(utf8.encode(account.password))}",
    }), 200, 
        body: {
          "id": insertedAccount.id,
          "email": insertedAccount.email,
        }
    );
  });
}
