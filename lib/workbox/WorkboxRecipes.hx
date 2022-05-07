@:jsRequire("workbox-recipes") @valueModuleOnly extern class WorkboxRecipes {
	/**
		An implementation of the [Google fonts]{@link https://developers.google.com/web/tools/workbox/guides/common-recipes#google_fonts} caching recipe
	**/
	static function googleFontsCache(?options:workbox_recipes.GoogleFontCacheOptions):Void;
	/**
		An implementation of the [image caching recipe]{@link https://developers.google.com/web/tools/workbox/guides/common-recipes#caching_images}
	**/
	static function imageCache(?options:workbox_recipes.ImageCacheOptions):Void;
	/**
		An implementation of the [comprehensive fallbacks recipe]{@link https://developers.google.com/web/tools/workbox/guides/advanced-recipes#comprehensive_fallbacks}. Be sure to include the fallbacks in your precache injection
	**/
	static function offlineFallback(?options:workbox_recipes.OfflineFallbackOptions):Void;
	/**
		An implementation of a page caching recipe with a network timeout
	**/
	static function pageCache(?options:workbox_recipes.PageCacheOptions):Void;
	/**
		An implementation of the [CSS and JavaScript files recipe]{@link https://developers.google.com/web/tools/workbox/guides/common-recipes#cache_css_and_javascript_files}
	**/
	static function staticResourceCache(?options:workbox_recipes.StaticResourceOptions):Void;
	static function warmStrategyCache(options:workbox_recipes.WarmStrategyCacheOptions):Void;
}