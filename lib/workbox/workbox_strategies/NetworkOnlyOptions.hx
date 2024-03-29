package workbox_strategies;

typedef NetworkOnlyOptions = {
	@:optional
	var networkTimeoutSeconds : Float;
	@:optional
	var plugins : Array<workbox_core.WorkboxPlugin>;
	@:optional
	var fetchOptions : js.html.RequestInit;
};