package workbox_core;

typedef CachedResponseWillBeUsedCallback = (param:CachedResponseWillBeUsedCallbackParam) -> js.lib.Promise<Null<ts.AnyOf2<ts.Undefined, js.html.Response>>>;