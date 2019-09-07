
import 'package:firescore/model/account.dart';
import 'package:firescore/services/account_service.dart';
import 'package:firescore/repositories/account_repository.dart';
import '../harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  test("#findByEmail", () async {
    final accountService = AccountService(harness.application.channel.context);
    final accountRepository = AccountRepository(harness.application.channel.context);

    final account = await accountService.createAccount(
        Account()
          ..email = "don@corleone.it"
          ..password = "LeaveTheGunTakeTheCannoli"
    );

    final fetchedAccount = await accountRepository.findByEmail(account.email);
    expect(fetchedAccount, isNotNull);
  });
}
