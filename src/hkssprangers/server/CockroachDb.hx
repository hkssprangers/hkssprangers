package hkssprangers.server;

import tink.sql.*;

class CockroachDb {
    static public final host = Sys.getEnv("COCKROACH_HOST");
    static public final port = Std.parseInt(Sys.getEnv("COCKROACH_PORT"));
    static public final user = Sys.getEnv("COCKROACH_USER");
    static public final password = Sys.getEnv("COCKROACH_PASSWORD");
    static public final database = Sys.getEnv("COCKROACH_DATABASE");

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