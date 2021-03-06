package hkssprangers.server;

import react.*;
import react.Fragment;
import react.ReactMacro.jsx;
import hkssprangers.StaticResource.R;
import haxe.*;
import haxe.io.Path;
import hkssprangers.server.ServerMain.*;
import comments.CommentString.comment;
import comments.CommentString.unindent;
using StringTools;

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
            __html: comment(unindent)/**
                window.dataLayer = window.dataLayer || [];
                function gtag(){dataLayer.push(arguments);}
                gtag('js', new Date());
                gtag('config', '${id}');
            **/.replace("${id}", id)
        };
        var scriptSrc = 'https://www.googletagmanager.com/gtag/js?id=${id}';
        return jsx('
            <Fragment>
                <script async src=${scriptSrc}></script>
                <script dangerouslySetInnerHTML=${content}></script>
            </Fragment>
        ');
    }

    function depCss() return jsx('
        <Fragment>
        </Fragment>
    ');

    function depScript() return jsx('
        <Fragment>
            <script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossOrigin="anonymous"></script>
            <script src="https://cdn.jsdelivr.net/npm/js-cookie@2.2.1/src/js.cookie.js" integrity="sha256-P8jY+MCe6X2cjNSmF4rQvZIanL5VwUUT4MBnOMncjRU=" crossOrigin="anonymous"></script>
        </Fragment>
    ');

    function footJs() return jsx('
        <Fragment>
            <script src=${R("/trackExceptions.js")}></script>
        </Fragment>
    ');

    function css() return jsx('
        <Fragment>
            <link rel="preconnect" href="https://fonts.gstatic.com" />
            <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Noto+Sans+HK:wght@300;400;500;700&display=swap" />
            <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700&display=swap" />
            <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons" />
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@5.14.0/css/all.min.css" integrity="sha256-FMvZuGapsJLjouA6k7Eo2lusoAX9i0ShlWFG6qt7SLc=" crossOrigin="anonymous" />
            <link rel="stylesheet" href=${R("/css/tailwind.css")} />
            <link rel="stylesheet" href=${R("/css/style.css")} />
        </Fragment>
    ');

    function script() return null;

    function favicon() return jsx('
        <Fragment>
            <link rel="icon" type="image/png" sizes="720x720" href=${Path.join(["https://" + host, R("/images/ssprangers4-y.png")])}/>
            <link rel="icon" type="image/x-icon" sizes="48x48" href=${Path.join(["https://" + host, R("/favicon.ico")])}/>
            <link rel="icon" type="image/png" sizes="32x32" href=${Path.join(["https://" + host, R("/images/favicon-32x32.png")])}/>
            <link rel="icon" type="image/png" sizes="16x16" href=${Path.join(["https://" + host, R("/images/favicon-16x16.png")])}/>
            <link rel="apple-touch-icon" sizes="720x720" href=${Path.join(["https://" + host, R("/images/ssprangers4-y.png")])}/>
            <meta name="msapplication-TileColor" content="#ffffff" />
            <meta name="msapplication-TileImage" content=${Path.join(["https://" + host, R("/images/ssprangers4-y.png")])} />
            <meta name="theme-color" content="#ffffff" />
        </Fragment>
    ');

    function prefetch():Array<String> return [];
    function prefetchNode(link:String) return jsx('<link key=${link} rel="prefetch" href=${link} />');

    function ogMeta() {
        var description = switch (description()) {
            case null: null;
            case v: jsx('<meta property="og:description" content=${v} />');
        }
        var canonical = switch (canonical()) {
            case null: null;
            case v: jsx('<meta property="og:url" content=${v} />');
        }
        return jsx('
            <Fragment>
                <meta property="og:title" content=${title()} />
                ${description}
                ${canonical}
            </Fragment>
        ');
    }

    function head() {
        var canonical = switch (canonical()) {
            case null:
                null;
            case v:
                jsx('<link rel="canonical" href=${v} />');
        }
        return jsx('
            <head>
                ${gtag()}
                <meta charSet="UTF-8" />
                <meta httpEquiv="X-UA-Compatible" content="IE=edge" />
                <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
                <title>${title()}</title>

                <link rel="manifest" href=${R("/manifest.webmanifest")} />
                <meta name="mobile-web-app-capable" content="yes" />
                <meta name="apple-mobile-web-app-capable" content="yes" />
                <meta name="application-name" content=${name} />
                <meta name="apple-mobile-web-app-title" content=${name} />
                <meta name="msapplication-starturl" content="/" />

                ${favicon()}
                ${descriptionTag()}
                ${canonical}
                ${ogMeta()}
                ${depCss()}
                ${depScript()}
                ${css()}
                ${script()}
                ${prefetch().map(prefetchNode)}
            </head>
        ');
    }

    function htmlClasses():Array<String> {
        return [];
    }

    function bodyClasses():Array<String> {
        return ["overflow-y-scroll"];
    }

    function bodyAttributes():DynamicAccess<String> {
        return {};
    }

    function bodyContent() return null;

    function footer() return jsx('
        <footer className="p-6 text-center">
            <p>"一日一黃店 世界更美妙" - <a href="https://charleywong.giffon.io/" target="_blank" rel="noopener" className="underline text-black">Charley</a></p>
            <p>&copy; 2020-2021 ${name}</p>
            <div className="my-3 flex justify-center">
                <a className="mx-2" href="https://www.facebook.com/hkssprangers">
                    <i className="text-xl text-black fab fa-facebook-f"></i>
                    <span className="sr-only">Facebook</span>
                </a>
                <a className="mx-2" href="https://www.instagram.com/hkssprangers/">
                    <i className="text-xl text-black fab fa-instagram"></i>
                    <span className="sr-only">Instagram</span>
                </a>
                <a className="mx-2" href="https://t.me/hkssprangers">
                    <i className="text-xl text-black fab fa-telegram-plane"></i>
                    <span className="sr-only">Telegram</span>
                </a>
                <a className="mx-2 py-1" href="https://mewe.com/p/hkssprangers">
                    ${StaticResource.image("/images/mewe.png", "MeWe", "w-12")}
                </a>
            </div>
        </footer>
    ');

    function body() return jsx('
        <body className=${bodyClasses().join(" ")} {...bodyAttributes()}>
            <div id="content">
                ${bodyContent()}
            </div>
            ${footer()}
            ${footJs()}
        </body>
    ');

    override function render() {
        return jsx('
            <html lang="zh" className=${htmlClasses().join(" ")}>
                ${head()}
                ${body()}
            </html>
        ');
    }
}