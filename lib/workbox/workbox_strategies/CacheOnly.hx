package workbox_strategies;

/**
	An implementation of a [cache-only](https://developer.chrome.com/docs/workbox/caching-strategies-overview/#cache-only)
	request strategy.
	
	This class is useful if you want to take advantage of any
	[Workbox plugins](https://developer.chrome.com/docs/workbox/using-plugins/).
	
	If there is no cache match, this will throw a `WorkboxError` exception.
**/
@:jsRequire("workbox-strategies", "CacheOnly") extern class CacheOnly extends Strategy {
	function new(?options:Dynamic);
	function _handle(request:js.html.Request, handler:StrategyHandler):js.lib.Promise<js.html.Response>;
	static var prototype : CacheOnly;
}