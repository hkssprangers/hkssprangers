package hkssprangers.serviceWorker;

import workbox_core.*;
import workbox_cacheable_response.*;
import workbox_strategies.*;
import workbox_expiration.*;

class ServiceWorkerMain {
	static function main() {
		WorkboxRouting.registerRoute((options:RouteMatchCallbackOptions) -> {
            StaticResource.parseUrl(options.url.pathname).hash != null;
        }, new CacheFirst({
			cacheName: "static",
			plugins: ([
				new CacheableResponsePlugin({
					statuses: [0, 200],
				}),
				new ExpirationPlugin({
					maxEntries: 60,
				}),
			]:Array<Dynamic>),
		}));
	}
}
