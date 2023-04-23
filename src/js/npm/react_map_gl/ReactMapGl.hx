package js.npm.react_map_gl;

import maplibre_gl.Map_;

@:jsRequire("react-map-gl")
extern class ReactMapGl {
    static function useMap():{ current:Map_ };
}