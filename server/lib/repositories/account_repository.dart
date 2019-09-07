import 'dart:async';
import 'package:aqueduct/aqueduct.dart';
import '../model/account.dart';

class AccountRepository {
    AccountRepository(this.context);

    final ManagedContext context;

    Future<Account> findByEmail(String email) async {
      final query = Query<Account>(context)
          ..where((a) => a.email).equalTo(email);

      return await query.fetchOne();
    }

    Future<List<Account>> fetchAll() async {
      return await Query<Account>(context).fetch();
    }
}
