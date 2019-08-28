import 'controllers/admin_panel_controllers.dart';
import 'controllers/score_board_controller.dart';
import 'firescore.dart';

class _FirescoreConfig extends Configuration {
    _FirescoreConfig(String path): super.fromFile(File(path));

    DatabaseConfiguration database;
}

class FirescoreChannel extends ApplicationChannel {

    ManagedContext context;

    @override
    Future prepare() async {
        logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

        final config = _FirescoreConfig(options.configurationFilePath);

        final dataModel = ManagedDataModel.fromCurrentMirrorSystem();

        final persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
                config.database.username,
                config.database.password,
                config.database.host,
                config.database.port,
                config.database.databaseName
        );

        context = ManagedContext(dataModel, persistentStore);
    }

    @override
    Controller get entryPoint {
        final router = Router();

        router
                .route("/accounts")
                .link(() => CreateAccountController(context));

        router
                .route("/admin/account")
                .link(() => Authorizer.basic(AccountPasswordVerifier(context)))
                .link(() => AdminAccountController(context));

        router
                .route("/admin/games/[:gameId]")
                .link(() => Authorizer.basic(AccountPasswordVerifier(context)))
                .link(() => ManageGamesController(context));

        router
                .route("/admin/games/:gameId/score_boards/[:scoreBoardId]")
                .link(() => Authorizer.basic(AccountPasswordVerifier(context)))
                .link(() => ManageScoreBoardController(context));

        router
                .route("/scores/token/:scoreBoardUui")
                .link(() => GetTokenController());

        router
                .route("/scores")
                .link(() => Authorizer.bearer(JwtVerifier()))
                .link(() => CreateScoreController(context));

        return router;
    }
}
