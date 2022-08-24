package hkssprangers.server;

import react.*;
import react.ReactComponent;
import react.Fragment;
import react.ReactMacro.jsx;
import hkssprangers.NodeModules;
import hkssprangers.StaticResource.R;
import haxe.*;
import haxe.io.Path;
import hkssprangers.server.ServerMain.*;
import comments.CommentString.comment;
import comments.CommentString.unindent;
using StringTools;
using Reflect;

class View<Props:{}> extends ReactComponentOf<Props, {}> {
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

    function fullstory() {
        final content = {
            __html: comment(unindent)/**
                window['_fs_debug'] = false;
                window['_fs_host'] = 'fullstory.com';
                window['_fs_script'] = 'edge.fullstory.com/s/fs.js';
                window['_fs_org'] = 'o-1BBGAN-na1';
                window['_fs_namespace'] = 'FS';
                (function(m,n,e,t,l,o,g,y){
                    if (e in m) {if(m.console && m.console.log) { m.console.log('FullStory namespace conflict. Please set window["_fs_namespace"].');} return;}
                    g=m[e]=function(a,b,s){g.q?g.q.push([a,b,s]):g._api(a,b,s);};g.q=[];
                    o=n.createElement(t);o.async=1;o.crossOrigin='anonymous';o.src='https://'+_fs_script;
                    y=n.getElementsByTagName(t)[0];y.parentNode.insertBefore(o,y);
                    g.identify=function(i,v,s){g(l,{uid:i},s);if(v)g(l,v,s)};g.setUserVars=function(v,s){g(l,v,s)};g.event=function(i,v,s){g('event',{n:i,p:v},s)};
                    g.anonymize=function(){g.identify(!!0)};
                    g.shutdown=function(){g("rec",!1)};g.restart=function(){g("rec",!0)};
                    g.log = function(a,b){g("log",[a,b])};
                    g.consent=function(a){g("consent",!arguments.length||a)};
                    g.identifyAccount=function(i,v){o='account';v=v||{};v.acctId=i;g(o,v)};
                    g.clearUserCookie=function(){};
                    g.setVars=function(n, p){g('setVars',[n,p]);};
                    g._w={};y='XMLHttpRequest';g._w[y]=m[y];y='fetch';g._w[y]=m[y];
                    if(m[y])m[y]=function(){return g._w[y].apply(this,arguments)};
                    g._v="1.3.0";
                })(window,document,window['_fs_namespace'],'script','user');
            **/
        };
        return jsx('
            <Fragment>
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
        </Fragment>
    ');

    function footJs() return jsx('
        <Fragment>
            <script src=${R("/trackExceptions.js")}></script>
        </Fragment>
    ');

    function css() {
        final tailwind = switch (ServerMain.deployStage) {
            case master | production:
                jsx('
                    <link rel="stylesheet" href=${R("/css/tailwind.css", false)} />
                ');
            case _:
                null;
        };
        final fontawesomeCssUrl = 'https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@${NodeModules.lockedVersion("@fortawesome/fontawesome-free")}/css/all.min.css';
        return jsx('
            <Fragment>
                <link rel="preconnect" href="https://fonts.gstatic.com" />
                <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Noto+Sans+HK:wght@300;400;500;700&display=swap" />
                <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,400,500,700&display=swap" />
                <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons" />
                <link rel="stylesheet" href=${fontawesomeCssUrl} crossOrigin="anonymous" />
                ${tailwind}
                <link rel="stylesheet" href=${R("/css/style.css")} />
            </Fragment>
        ');
    }

    function script() {
        final tailwind = switch (ServerMain.deployStage) {
            case master | production:
                null;
            case _:
                jsx('
                    <script src="https://cdn.tailwindcss.com"></script>
                ');
        };
        return jsx('
            <Fragment>
                ${tailwind}
                <script src=${R("/browser.bundled.js")} data-deploy-stage=${ServerMain.deployStage}></script>
            </Fragment>
        ');
    }

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
                ${fullstory()}
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

    static public function header() return jsx('
        <div className="mx-auto container md:flex items-center">
            <div className="md:w-1/3 flex items-center py-3 px-6 md:p-0">
                <a href="/">${StaticResource.image("/images/logo-blk-png.png", "埗兵", "inline w-12 lg:w-16")}</a>
                <div className="flex-1 px-3">
                    <b className="text-lg lg:text-xl">埗兵</b>
                    <p className="text-sm">為深水埗黃店服務為主嘅外賣平台</p>
                </div>
                <button id="menuBtn" className="md:hidden text-gray-500 w-8 h-8 relative focus:outline-none bg-white">
                    <div className="navicon position-absolute">
                        <span></span>
                        <span></span>
                        <span></span>
                    </div>
                </button>
            </div>
            <div className="md:w-2/3 hidden md:block p-0 md:py-6 bg-gray-100 md:bg-transparent" id="mmenu">
                <div className="md:flex">
                    <div className="flex-1 py-3 px-6 md:p-0">
                        <div className="md:pr-6">
                            <div className="flex items-center my-3 md:mt-0 text-gray-400">
                                <span className="text-sm">主業</span>
                                <div className="flex-1 ml-3 bg-border-gray">&nbsp;</div>
                            </div>
                            <ul className="md:flex text-sm">
                                <li><a className="block p-3 md:p-0 md:pr-3" href="/">點叫外賣</a></li>
                                <li><a className="block p-3 md:p-0" href="/">合作餐廳</a></li>
                            </ul>
                        </div>
                    </div>
                    <div className="flex-1 py-3 px-6 md:p-0">
                        <div className="flex items-center my-3 md:mt-0 text-gray-400">
                            <span className="text-sm">副業</span>
                            <div className="flex-1 ml-3 bg-border-gray">&nbsp;</div>
                        </div>
                        <ul className="md:flex text-sm">
                            <li><a className="block p-3 md:p-0 md:pr-3" href="/food-waste-recycle">咖啡渣回收</a></li>
                            <li><a className="block p-3 md:p-0 md:pr-3" href="/aulaw-vege">本地菜團購</a></li>
                            <li><a className="block p-3 md:p-0" href="/recipe">埗兵鬼煮意</a></li>
                        </ul>   
                    </div>
                </div>
            </div>
        </div>
    ');

    function footer() return jsx('
        <footer className="p-6 text-center">
            <p>"一日一黃店 世界更美妙" - <a href="https://charleywong.giffon.io/" target="_blank" rel="noopener" className="underline text-black">Charley</a></p>
            <p>&copy; 2020-2022 ${name}</p>
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