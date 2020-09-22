package hkssprangers.server;

import react.*;
import react.Fragment;
import react.ReactMacro.jsx;
import hkssprangers.StaticResource.R;
import haxe.*;

class View extends ReactComponent {
    function title():String return name;

    function description():Null<String> return null;
    function descriptionTag() return switch description() {
        case null:
            null;
        case desc:
             jsx('
                <meta name="description" content=${desc} />
            ');
    };

    function canonical():String throw "should be overridden";

    function gtag() {
        var id = "UA-174916152-1";
        var content = {
            __html: "
                window.dataLayer = window.dataLayer || [];
                function gtag(){dataLayer.push(arguments);}
                gtag('js', new Date());
                gtag('config', '" + id + "');
            "
        };
        var scriptSrc = 'https://www.googletagmanager.com/gtag/js?id=${id}';
        return jsx('
            <Fragment>
                <script async=${true} src=${scriptSrc}></script>
                <script dangerouslySetInnerHTML=${content}></script>
            </Fragment>
        ');
    }

    function depCss() return jsx('
        <Fragment>
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/css/bootstrap.min.css" integrity="sha256-Ww++W3rXBfapN8SZitAvc9jw2Xb+Ixt0rvDsmWmQyTo=" crossOrigin="anonymous" />
        </Fragment>
    ');

    function depScript() return jsx('
        <Fragment>
            <script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossOrigin="anonymous"></script>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js" integrity="sha256-9nt4LsWmLI/O24lTW89IzAKuBqEZ47l/4rh1+tH/NY8=" crossOrigin="anonymous"></script>
            <script src="https://cdn.jsdelivr.net/npm/js-cookie@2.2.1/src/js.cookie.js" integrity="sha256-P8jY+MCe6X2cjNSmF4rQvZIanL5VwUUT4MBnOMncjRU=" crossOrigin="anonymous"></script>
        </Fragment>
    ');

    function footJs() return jsx('
        <Fragment>
            <script src=${R("/trackExceptions.js")}></script>
            <script src="//instant.page/3.0.0" type="module" defer=${true} integrity="sha384-OeDn4XE77tdHo8pGtE1apMPmAipjoxUQ++eeJa6EtJCfHlvijigWiJpD7VDPWXV1"></script>
        </Fragment>
    ');

    function css() return jsx('
        <Fragment>
            <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700&display=swap" />
            <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons" />
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@5.14.0/css/all.min.css" integrity="sha256-FMvZuGapsJLjouA6k7Eo2lusoAX9i0ShlWFG6qt7SLc=" crossOrigin="anonymous" />
            <link rel="stylesheet" href=${R("/css/style.css")} />
        </Fragment>
    ');

    function script() return jsx('
        <Fragment>
            <script src=${R("/browser.bundled.js")}></script>
        </Fragment>
    ');

    function favicon() return jsx('
        <Fragment>
            <link rel="apple-touch-icon" sizes="720x720" href=${R("/images/ssprangers4-y.png")}/>
            <link rel="icon" type="image/png" sizes="720x720"  href=${R("/images/ssprangers4-y.png")}/>
            <meta name="msapplication-TileColor" content="#ffffff" />
            <meta name="msapplication-TileImage" content=${R("/images/ssprangers4-y.png")} />
            <meta name="theme-color" content="#ffffff" />
        </Fragment>
    ');

    function prefetch():Array<String> return [];
    function prefetchNode(link:String) return jsx('<link key=${link} rel="prefetch" href=${link} />');

    function ogMeta() return jsx('
        <Fragment>
            <meta property="og:title" content=${title()} />
            <meta property="og:description" content=${description()} />
            <meta property="og:url" content=${canonical()} />
        </Fragment>
    ');

    function head() return jsx('
        <head>
            ${gtag()}
            <meta charSet="UTF-8" />
            <meta httpEquiv="X-UA-Compatible" content="IE=edge" />
            <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
            <title>${title()}</title>

            <link rel="manifest" href="/manifest.webmanifest" />
            <meta name="mobile-web-app-capable" content="yes" />
            <meta name="apple-mobile-web-app-capable" content="yes" />
            <meta name="application-name" content=${name} />
            <meta name="apple-mobile-web-app-title" content=${name} />
            <meta name="msapplication-starturl" content="/" />

            ${favicon()}
            ${descriptionTag()}
            <link rel="canonical" href=${canonical()} />
            ${ogMeta()}
            ${depCss()}
            ${depScript()}
            ${css()}
            ${script()}
            ${prefetch().map(prefetchNode)}
        </head>
    ');

    function bodyClasses():Array<String> {
        return [];
    }

    function bodyAttributes():DynamicAccess<String> {
        return {};
    }

    function bodyContent() return null;

    function body() return jsx('
        <body className=${bodyClasses().join(" ")} {...bodyAttributes()}>
            <div id="content">
                ${bodyContent()}
            </div>
            <footer>
                <p>
                    Copyright (C) 2020  ${name}
                </p>
            </footer>
            ${footJs()}
        </body>
    ');

    override function render() {
        return jsx('
            <html lang="zh">
                ${head()}
                ${body()}
            </html>
        ');
    }
}