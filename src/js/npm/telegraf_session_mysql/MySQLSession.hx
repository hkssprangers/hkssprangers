package js.npm.telegraf_session_mysql;

@:jsRequire("telegraf-session-mysql")
extern class MySQLSession {
    public function new(opts:Dynamic):Void;
    public function middleware():Dynamic;
}