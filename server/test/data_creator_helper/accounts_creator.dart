import 'dart:async';
import 'package:aqueduct/aqueduct.dart';
import 'package:firescore/model/account.dart';
import 'package:firescore/util.dart';

class AccountsCreator {
  AccountsCreator(this.context);

  final ManagedContext context;

  Future<Account> createAccount({
    String email = "don@corleone.it",
    String password = "vitor"
  }) async {
    final account = Account();
    account.email = email;
    account.password = generateMd5(password);

    return await context.insertObject(account);
  }
}
