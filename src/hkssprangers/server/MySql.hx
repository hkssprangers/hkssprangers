package hkssprangers.server;

import tink.sql.*;

class MySql {
    static public final host = Sys.getEnv("MYSQL_HOST");
    static public final user = Sys.getEnv("MYSQL_USER");
    static public final password = Sys.getEnv("MYSQL_PASSWORD");

    static public final driver = new tink.sql.drivers.node.MySql({
        host: host,
        user: user,
        password: password,
    });

    static public final db = new hkssprangers.db.Database("hkssprangers", MySql.driver);
}