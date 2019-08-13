import 'dart:async';
import 'package:aqueduct/aqueduct.dart';

import '../model/account.dart';
import '../util.dart';

class AccountPasswordVerifier implements AuthValidator {
    AccountPasswordVerifier(this.context);

    final ManagedContext context;

    @override
    List<APISecurityRequirement> documentRequirementsForAuthorizer(APIDocumentContext context, Authorizer authorizer, {List<AuthScope> scopes}) {
        return null;
    }

    @override
    FutureOr<Authorization> validate<T>(AuthorizationParser<T> parser, T authorizationData, {List<AuthScope> requiredScope}) async {
        final credentials = authorizationData as AuthBasicCredentials;

        final query = Query<Account>(context)
                ..where((a) => a.email).equalTo(credentials.username);

        final fetchedAccount = await query.fetchOne();

        if (fetchedAccount != null) {
            if (fetchedAccount.password == credentials.password) {
                return Authorization(null, null, this);
            }
        }

        return null;
    }
}

Map<String, dynamic> _mapAccount(Account account) => {
    "id": account.id,
    "email": account.email,
};

class AccountController  extends ResourceController {
    AccountController(this.context);

    final ManagedContext context;

    @Operation.get('id')
    Future<Response> getAccount(@Bind.path('id') int id) async {
        final query = Query<Account>(context)
            ..where((a) => a.id).equalTo(id);

        final account = await query.fetchOne();

        return Response.ok(_mapAccount(account));
    }

}

class CreateAccountController extends ResourceController {
    CreateAccountController(this.context);

    final ManagedContext context;


    @Operation.post()
    Future<Response> createAccount(@Bind.body() Account account) async {
        account.password = generateMd5(account.password);

        final insertedAccount = await context.insertObject(account);

        return Response.ok(_mapAccount(insertedAccount));
    }
}
