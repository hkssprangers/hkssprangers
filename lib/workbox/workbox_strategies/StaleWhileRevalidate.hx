package workbox_strategies;

/**
	An implementation of a
	[stale-while-revalidate](https://developer.chrome.com/docs/workbox/reference/workbox-strategies/#type-StaleWhileRevalidate)
	request strategy.
	
	Resources are requested from both the cache and the network in parallel.
	The strategy will respond with the cached version if available, otherwise
	wait for the network response. The cache is updated with the network response
	with each successful request.
	
	By default, this strategy will cache responses with a 200 status code as
	well as [opaque responses](https://developer.chrome.com/docs/workbox/caching-resources-during-runtime/#opaque-responses).
	Opaque responses are cross-origin requests where the response doesn't
	support [CORS](https://enable-cors.org/).
	
	If the network request fails, and there is no cache match, this will throw
	a `WorkboxError` exception.
**/
@:jsRequire("workbox-strategies", "StaleWhileRevalidate") extern class StaleWhileRevalidate extends Strategy {
	function new(?options:StrategyOptions);
	function _handle(request:js.html.Request, handler:StrategyHandler):js.lib.Promise<js.html.Response>;
	static var prototype : StaleWhileRevalidate;
}