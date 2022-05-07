@:jsRequire("workbox-range-requests") @valueModuleOnly extern class WorkboxRangeRequests {
	/**
		Given a `Request` and `Response` objects as input, this will return a
		promise for a new `Response`.
		
		If the original `Response` already contains partial content (i.e. it has
		a status of 206), then this assumes it already fulfills the `Range:`
		requirements, and will return it as-is.
	**/
	static function createPartialResponse(request:js.html.Request, originalResponse:js.html.Response):js.lib.Promise<js.html.Response>;
}