package workbox_core;

typedef CacheWillUpdateCallback = (param:CacheWillUpdateCallbackParam) -> js.lib.Promise<Null<ts.AnyOf2<ts.Undefined, js.html.Response>>>;