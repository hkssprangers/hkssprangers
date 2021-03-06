package hkssprangers.info;

using Lambda;

enum abstract PaymentMethod(String) to String {
    final PayMe;
    final FPS;

    public function info() return switch (cast this:PaymentMethod) {
        case PayMe:
            {
                id: PayMe,
                name: "PayMe",
            }
        case FPS:
            {
                id: FPS,
                name: "FPS",
            }
    }

    static public function fromName(name:String) {
        name = name.toLowerCase();
        return [PayMe, FPS].find(m -> m.info().name.toLowerCase() == name);
    }
}