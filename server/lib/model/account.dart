import 'package:aqueduct/aqueduct.dart';

import 'game.dart';

class _Account {

    @primaryKey
    int id;

    @Column(nullable: false)
    String email;

    @Column(nullable: false)
    String password;

    ManagedSet<Game> games;
}

class Account extends ManagedObject<_Account> implements _Account {}
