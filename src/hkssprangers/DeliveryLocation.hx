package hkssprangers;

import hkssprangers.Osm;

typedef DeliveryLocation = {
    name: String,
    osm: String,
    center: OsmCoordinates,
    fee: DynamicAccess<Float>,
}