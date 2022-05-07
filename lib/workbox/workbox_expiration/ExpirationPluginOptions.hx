package workbox_expiration;

typedef ExpirationPluginOptions = {
	@:optional
	var maxEntries : Float;
	@:optional
	var maxAgeSeconds : Float;
	@:optional
	var matchOptions : js.html.CacheQueryOptions;
	@:optional
	var purgeOnQuotaError : Bool;
};