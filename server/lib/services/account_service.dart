import 'dart:async';
import 'package:aqueduct/aqueduct.dart';

import '../model/account.dart';
import '../util.dart';

class AccountService {
  AccountService(this.context);

  final ManagedContext context;

  Future<Account> createAccount(Account account) async {
    account.password = generateMd5(account.password);

    return await context.insertObject(account);
  }
}
