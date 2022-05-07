package workbox_range_requests;

/**
	The range request plugin makes it easy for a request with a 'Range' header to
	be fulfilled by a cached response.
	
	It does this by intercepting the `cachedResponseWillBeUsed` plugin callback
	and returning the appropriate subset of the cached response body.
**/
@:jsRequire("workbox-range-requests", "RangeRequestsPlugin") extern class RangeRequestsPlugin {
	function new();
	@:optional
	dynamic function cachedResponseWillBeUsed(param:workbox_core.CachedResponseWillBeUsedCallbackParam):js.lib.Promise<Null<ts.AnyOf2<ts.Undefined, js.html.Response>>>;
	static var prototype : RangeRequestsPlugin;
}