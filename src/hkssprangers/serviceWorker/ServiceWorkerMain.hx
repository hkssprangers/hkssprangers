package hkssprangers.serviceWorker;

import workbox_core.*;
import workbox_cacheable_response.*;
import workbox_range_requests.*;
import workbox_strategies.*;
import workbox_expiration.*;
using StringTools;

class ServiceWorkerMain {
    static function main() {
        WorkboxNavigationPreload.enable();
        WorkboxRouting.setDefaultHandler(cast new NetworkFirst());

        WorkboxRouting.registerRoute((options:RouteMatchCallbackOptions) -> {
            StaticResource.parseUrl(options.url.pathname) != null;
        }, cast new CacheFirst({
            cacheName: "static",
            plugins: ([
                new CacheableResponsePlugin({
                    statuses: [0, 200],
                }),
                new ExpirationPlugin({
                    maxEntries: 60,
                }),
                new RangeRequestsPlugin(),
            ]:Array<Dynamic>),
        }));
        WorkboxRouting.registerRoute(function(options:RouteMatchCallbackOptions) {
            if (switch options.request.destination {
                case FONT | IMAGE | SCRIPT | STYLE:
                    var url = options.request.url;
                    url.startsWith("https://cdn.jsdelivr.net/") ||
                    url.startsWith("https://cdn.lordicon.com/") ||
                    url.startsWith("https://fonts.googleapis.com/") ||
                    url.startsWith("https://fonts.gstatic.com/");
                case _:
                    false;
            }) return true;

            if (options.request.url.startsWith("https://cdn.lordicon.com/") && options.request.url.endsWith(".json"))
                return true;

            return false;
        }, cast new CacheFirst({
            cacheName: "external_static",
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
