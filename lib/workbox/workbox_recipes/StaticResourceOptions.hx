package workbox_recipes;

typedef StaticResourceOptions = {
	@:optional
	var cacheName : String;
	@:optional
	dynamic function matchCallback(options:workbox_core.RouteMatchCallbackOptions):Dynamic;
	@:optional
	var plugins : Array<workbox_core.WorkboxPlugin>;
	@:optional
	var warmCache : Array<String>;
};