package workbox_cacheable_response;

typedef CacheableResponseOptions = {
	@:optional
	var statuses : Array<Float>;
	@:optional
	var headers : haxe.DynamicAccess<String>;
};