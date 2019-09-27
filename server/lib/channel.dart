import 'controllers/admin_panel_controllers.dart';
import 'controllers/score_board_controller.dart';
import 'firescore.dart';
import 'repositories/account_repository.dart';
import 'repositories/game_repository.dart';
import 'services/account_service.dart';
import 'services/game_service.dart';
import 'services/score_board_service.dart';

class _FirescoreConfig extends Configuration {
    _FirescoreConfig(String path): super.fromFile(File(path));

    DatabaseConfiguration database;
    String jwtSecret;
    String masterUser;
    String masterPassword;
}

class FirescoreChannel extends ApplicationChannel {

    ManagedContext context;
    PersistentStore persistentStore;

    AccountRepository accountRepository;
    AccountService accountService;

    GameRepository gameRepository;
    GameService gameService;

    ScoreBoardService scoreBoardService;

    String jwtSecret;
    String masterUser;
    String masterPassword;

    @override
    Future prepare() async {
        logger.onRecord.listen((rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

        final config = _FirescoreConfig(options.configurationFilePath);

        final dataModel = ManagedDataModel.fromCurrentMirrorSystem();

        persistentStore = PostgreSQLPersistentStore.fromConnectionInfo(
            config.database.username,
            config.database.password,
            config.database.host,
            config.database.port,
            config.database.databaseName
        );

        context = ManagedContext(dataModel, persistentStore);

        jwtSecret = config.jwtSecret;
        masterUser = config.masterUser;
        masterPassword = config.masterPassword;

        accountRepository = AccountRepository(context);
        accountService = AccountService(context);

        gameRepository = GameRepository(context);
        gameService = GameService(context);

        scoreBoardService = ScoreBoardService(context);
    }

    @override
    Controller get entryPoint {
        final router = Router();

        router
                .route("/accounts")
                .link(() => Authorizer.basic(MasterAccountVerifier(masterUser, masterPassword)))
                .link(() => CreateAccountController(accountService));

        router
                .route("/admin/account")
                .link(() => Authorizer.basic(AccountPasswordVerifier(accountRepository)))
                .link(() => AdminAccountController(accountRepository));

        router
                .route("/admin/games/[:gameId]")
                .link(() => Authorizer.basic(AccountPasswordVerifier(accountRepository)))
                .link(() => ManageGamesController(accountRepository, gameRepository, gameService));

        router
                .route("/admin/games/:gameId/score_boards/[:scoreBoardId]")
                .link(() => Authorizer.basic(AccountPasswordVerifier(accountRepository)))
                .link(() => ManageScoreBoardController(context, accountRepository, gameRepository, scoreBoardService));

        router
                .route("/scores/token/:scoreBoardUui")
                .link(() => GetTokenController(jwtSecret));

        router
                .route("/scores")
                .link(() => Authorizer.bearer(JwtVerifier(jwtSecret)))
                .link(() => CreateScoreController(context, jwtSecret));

        router
                .route("/scores/:scoreBoardUui")
                .link(() => ListScoreController(context));

        router
                .route("/scoreboard/:scoreBoardUui/playerIds")
                .link(() => ListUniquePlayerIdController(persistentStore));

        return router;
    }
}
