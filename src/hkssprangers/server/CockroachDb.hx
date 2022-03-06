package hkssprangers.server;

import tink.sql.*;

class CockroachDb {
    static public final host = Sys.getEnv("POSTGRES_HOST");
    static public final port = Std.parseInt(Sys.getEnv("POSTGRES_PORT"));
    static public final user = Sys.getEnv("POSTGRES_USER");
    static public final password = Sys.getEnv("POSTGRES_PASSWORD");
    static public final database = Sys.getEnv("POSTGRES_DB");

    static public final driver = new tink.sql.drivers.node.CockroachDb({
        host: host,
        port: port,
        user: user,
        password: password,
        ssl: cast {
            rejectUnauthorized: false,
        }
    });

    static public final db = new hkssprangers.db.Database(database, CockroachDb.driver);
}