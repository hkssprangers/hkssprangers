package hkssprangers.info.menu;

class EightyNineMenu {
    static public final EightyNineSet = {
        title: "套餐",
        description: "主菜 + 配菜 + 絲苗白飯2個",
        properties: {
            main: {
                title: "主菜選擇",
                type: "string",
                "enum": [
                    "香茅豬頸肉 $85",
                    "招牌口水雞 (例) $85",
                    "去骨海南雞 (例) $85",
                    "招牌口水雞 (例) 拼香茅豬頸肉 $98",
                    "去骨海南雞 (例) 拼香茅豬頸肉 $98",
                ]
            },
            sub: {
                title: "配菜選擇",
                type: "string",
                "enum": [
                    "涼拌青瓜拼木耳",
                    "郊外油菜",
                ],
            },
        },
        required: [
            "main",
            "sub",
        ]
    };

    
    static public function itemsSchema():Dynamic {
        return {
            type: "array",
            items:  EightyNineSet,
            minItems: 1,
        };
    }
}