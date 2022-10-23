package hkssprangers;

import js.lib.Promise;
import js.html.*;
import CrossFetch.fetch;
import comments.CommentString.*;

enum abstract OsmElementType(String) to String {
    final Node = "node";
    final Way = "way";
    final Relation = "relation";
}

typedef OsmRef = {
    type:OsmElementType,
    id:Int,
}

typedef OsmElement = OsmRef & {
    ?tags:DynamicAccess<String>,
}

typedef OsmNode = OsmElement & OsmCoordinates;

typedef OsmWay = OsmElement & {
    nodes:Array<Int>,
}

typedef OsmRelation = OsmElement & {
    members:Array<OsmElement>,
}

typedef OsmCoordinates = {
    lat:Float,
    lon:Float,
}

typedef OsmCenter = {
    center:OsmCoordinates,
}

typedef OsmMeta = {
    timestamp:String,
    version:Int,
    changeset:Int,
    user:String,
    uid:Int,
}

typedef OsmResult = {
    version:Float,
    generator:String,
    osm3s:{
        timestamp_osm_base:String,
        copyright:String,
    },
    elements:Array<OsmElement>,
}

class Osm {
    static public var overpassEndpoint = "https://overpass-api.de/api/interpreter";
    static public function overpass(query:String):Promise<String> {
        final body = new URLSearchParams(
            {
                data: query,
            }
        );
        return fetch(overpassEndpoint, {
            body: Std.string(body),
            method: "POST",
        })
            .then(r -> if (r.ok) {
                r.text();
            } else {
                r.text().then(t -> throw t);
            });
    }

    /**
        URL examples:
         - https://www.openstreetmap.org/node/2544686378
         - https://www.openstreetmap.org/way/1028585181
         - https://www.openstreetmap.org/relation/10692715
    **/
    static public function parseUrl(url:String):OsmRef {
        final r = ~/https:\/\/www\.openstreetmap\.org\/(node|way|relation)\/([0-9]+)/;
        if (!r.match(url)) {
            throw 'URL doesn\'t look like a OSM element reference: $url';
        }
        return {
            type: cast r.matched(1),
            id: Std.parseInt(r.matched(2)),
        }
    }

    static public function printRef(ref:OsmRef):String {
        return '${ref.type}(${ref.id})';
    }

    static public function printUrl(ref:OsmRef):String {
        return 'https://www.openstreetmap.org/${ref.type}/${ref.id}';
    }
}
