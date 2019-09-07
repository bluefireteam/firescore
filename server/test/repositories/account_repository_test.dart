
import 'package:firescore/repositories/account_repository.dart';
import '../data_creator_helper/accounts_creator.dart';
import '../harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  test("#findByEmail", () async {
    final accountRepository = AccountRepository(harness.application.channel.context);
    final account = await AccountsCreator(harness.application.channel.context).createAccount();

    final fetchedAccount = await accountRepository.findByEmail(account.email);
    expect(fetchedAccount, isNotNull);
  });

  test("#findAll", () async {
    final accountRepository = AccountRepository(harness.application.channel.context);
    await AccountsCreator(harness.application.channel.context).createAccount( email: "bla@bla.com" );
    await AccountsCreator(harness.application.channel.context).createAccount( email: "ble@bla.com" );

    final accounts = await accountRepository.fetchAll();
    expect(accounts.length, equals(2));
  });
}
