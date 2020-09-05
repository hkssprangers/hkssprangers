package hkssprangers.server;

class MySql {
    static public final mysqlHost = Sys.getEnv("MYSQL_HOST");
    static public final mysqlUser = Sys.getEnv("MYSQL_USER");
    static public final mysqlPassword = Sys.getEnv("MYSQL_PASSWORD");
}