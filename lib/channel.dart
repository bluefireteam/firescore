import 'controllers/admin_panel_controllers.dart';
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
                .route("/accounts/:id")
                .link(() => Authorizer.basic(AccountPasswordVerifier(context)))
                .link(() => CreateAccountController(context));

        return router;
    }
}
