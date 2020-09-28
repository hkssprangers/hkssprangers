package hkssprangers.info;

using Lambda;

enum abstract PickupMethod(String) to String {
    var Door;
    var HangOutside;
    var Street;

    public function info() return switch (cast this:PickupMethod) {
        case Door:
            {
                id: Door,
                name: "上門交收",
            }
        case HangOutside:
            {
                id: HangOutside,
                name: "食物外掛",
            }
        case Street:
            {
                id: Street,
                name: "樓下交收",
            }
    }

    static public function fromName(name:String) {
        return [Door, HangOutside, Street].find(m -> m.info().name == name);
    }
}