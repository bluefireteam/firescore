import 'dart:async';
import 'package:aqueduct/aqueduct.dart';
import 'package:corsac_jwt/corsac_jwt.dart';

import '../model/score.dart';

String _generateToken(String secret) {
    final builder = JWTBuilder()
            ..issuer = 'https://api.foobar.com'
            ..expiresAt = DateTime.now().add(Duration(minutes: 3))
            ..setClaim('data', {'userId': 836});

    final signer = JWTHmacSha256Signer(secret);
    final signedToken = builder.getSignedToken(signer);
    return signedToken.toString();
}

bool _verifyToken(String secret, String token) {
    final signer = JWTHmacSha256Signer(secret);
    final decodedToken = JWT.parse(token);

    return decodedToken.verify(signer);
}

Map<String, dynamic> _getTokenInfo(String secret, String token) {
    final signer = JWTHmacSha256Signer(secret);
    final decodedToken = JWT.parse(token);

    return decodedToken.claims;
}

class AccountPasswordVerifier implements AuthValidator {
    AccountPasswordVerifier(this.context);

    final ManagedContext context;

    // TODO this should be a config
    final jwtSecret = 'bla';

    @override
    List<APISecurityRequirement> documentRequirementsForAuthorizer(APIDocumentContext context, Authorizer authorizer, {List<AuthScope> scopes}) {
        return null;
    }

    @override
    FutureOr<Authorization> validate<T>(AuthorizationParser<T> parser, T authorizationData, {List<AuthScope> requiredScope}) async {
        final bearer = authorizationData as String;


        // TODO
        if (true) {
            return Authorization(null, null, this);
        }
        return null;
    }
}

