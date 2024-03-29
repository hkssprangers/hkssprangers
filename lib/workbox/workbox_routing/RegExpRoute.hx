package workbox_routing;

/**
	RegExpRoute makes it easy to create a regular expression based
	{@link workbox-routing.Route}.
	
	For same-origin requests the RegExp only needs to match part of the URL. For
	requests against third-party servers, you must define a RegExp that matches
	the start of the URL.
**/
@:jsRequire("workbox-routing", "RegExpRoute") extern class RegExpRoute extends Route {
	/**
		If the regular expression contains
		[capture groups]{@link https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/RegExp#grouping-back-references},
		the captured values will be passed to the
		{@link workbox-routing~handlerCallback} `params`
		argument.
	**/
	function new(regExp:js.lib.RegExp, handler:workbox_core.RouteHandler, ?method:workbox_routing.utils.constants.HTTPMethod);
	static var prototype : RegExpRoute;
}