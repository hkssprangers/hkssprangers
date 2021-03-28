package hkssprangers.info.menu;

class EightyNineMenu {
    static public final EightyNineSet = {
        title: "套餐",
        description: "主菜 + 配菜 + 絲苗白飯2個",
        properties: {
            main: {
                title: "主菜",
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
                title: "配菜",
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

    static function summarizeItem(orderItem):{
        orderDetails:String,
        orderPrice:Float,
    } {
        return summarizeOrderObject(orderItem, EightyNineSet, ["main", "sub"], ["絲苗白飯2個"]);
    }

    static public function summarize(formData:FormOrderData):OrderSummary {
        var s = concatSummaries(formData.items.map(item -> summarizeItem(cast item)));
        return {
            orderDetails: s.orderDetails,
            orderPrice: s.orderPrice,
            wantTableware: formData.wantTableware,
            customerNote: formData.customerNote,
        }
    }
}