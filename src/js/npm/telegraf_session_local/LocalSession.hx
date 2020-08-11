package js.npm.telegraf_session_local;

@:jsRequire("telegraf-session-local")
extern class LocalSession {
    public function new(opts:Dynamic):Void;
    public function middleware():Dynamic;
}