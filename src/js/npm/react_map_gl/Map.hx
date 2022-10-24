package js.npm.react_map_gl;

import react.*;

@:jsRequire("react-map-gl", "Map")
extern class Map extends ReactComponent {}

@:jsRequire("react-map-gl", "Marker")
extern class Marker extends ReactComponent {}

@:jsRequire("react-map-gl", "Source")
extern class Source extends ReactComponent {}

@:jsRequire("react-map-gl", "Layer")
extern class Layer extends ReactComponent {}
