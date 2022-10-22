package hkssprangers;

import js.lib.Promise;
import js.html.*;
import CrossFetch.fetch;
import comments.CommentString.*;

typedef OsmElement = {
    type:String,
    id:Int,
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
}