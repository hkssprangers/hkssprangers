package workbox_recipes;

typedef GoogleFontCacheOptions = {
	@:optional
	var cachePrefix : String;
	@:optional
	var maxAgeSeconds : Float;
	@:optional
	var maxEntries : Float;
};