package hkssprangers;

import haxe.Json;

abstract JsonString<T>(String) to String {
    @:from static function fromJson<T>(object:T):JsonString<T> {
        return cast Json.stringify(object);
    }

    public function parse():T {
        return Json.parse(this);
    }
} 