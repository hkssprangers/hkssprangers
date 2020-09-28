package hkssprangers.info.menu;

enum abstract EightyNineItem(String) {
    var EightyNineSet;

    public function info(data:Dynamic) return switch (cast this:EightyNineItem) {
        case EightyNineSet:
            var dataInfo = {
                main: (data.main:EightyNineSetMain).info(),
                sub: (data.sub:EightyNineSetSub).info(),
                given: (data.given:EightyNineSetGiven).info(),
            };
            {
                id: EightyNineSet,
                name: "套餐",
                description: "主菜 + 配菜 + 絲苗白飯2個",
                detail:
                    [
                        dataInfo.main != null ? dataInfo.main.name + " " + dataInfo.main.price : "未選取主菜",
                        dataInfo.sub != null ? dataInfo.sub.name : "未選取配菜",
                        dataInfo.given != null ? dataInfo.given.name: "未選取套餐附送食物",
                    ].join("\n"),
                price: {
                    switch (dataInfo) {
                        case {main: main} if (main != null):
                            main.price;
                        case _:
                            0;
                    }
                },
                isValid:
                    data.main != null && data.sub != null && data.given != null,
            }
    }
}

enum abstract EightyNineSetMain(String) {
    var EightyNineSetMain1;
    var EightyNineSetMain2;
    var EightyNineSetMain3;
    var EightyNineSetMain4;
    var EightyNineSetMain5;

    public function info():{
        id:EightyNineSetMain,
        name:String,
        price:Float,
    } return switch (cast this:EightyNineSetMain) {
        case EightyNineSetMain1:
            {
                id: EightyNineSetMain1,
                name: "香茅豬頸肉",
                price: 85,
            }
        case EightyNineSetMain2:
            {
                id: EightyNineSetMain2,
                name: "招牌口水雞 (例)",
                price: 85,
            }
        case EightyNineSetMain3:
            {
                id: EightyNineSetMain3,
                name: "去骨海南雞 (例)",
                price: 85,
            }
        case EightyNineSetMain4:
            {
                id: EightyNineSetMain4,
                name: "招牌口水雞 (例) 拼香茅豬頸肉",
                price: 98,
            }
        case EightyNineSetMain5:
            {
                id: EightyNineSetMain5,
                name: "去骨海南雞 (例) 拼香茅豬頸肉",
                price: 98,
            }
    }
}

enum abstract EightyNineSetSub(String) {
    var EightyNineSetSub1;
    var EightyNineSetSub2;

    public function info() return switch (cast this:EightyNineSetSub) {
        case EightyNineSetSub1:
            {
                id: EightyNineSetSub1,
                name: "涼拌青瓜拼木耳",
            }
        case EightyNineSetSub2:
            {
                id: EightyNineSetSub2,
                name: "郊外油菜",
            }
    }
}

enum abstract EightyNineSetGiven(String) {
    var EightyNineSetGiven1;

    public function info() return switch (cast this:EightyNineSetGiven) {
        case EightyNineSetGiven1:
            {
                id: EightyNineSetGiven1,
                name: "絲苗白飯2個",
            }
    }
}