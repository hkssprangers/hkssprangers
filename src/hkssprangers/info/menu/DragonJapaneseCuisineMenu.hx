package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;

enum abstract DragonJapaneseCuisineItem(String) to String {
    final RamenSet;
    final RiceSet;
    final SingleItem;

    static public final all:ReadOnlyArray<DragonJapaneseCuisineItem> = [
        RamenSet,
        RiceSet,
        SingleItem,
    ];

    public function getDefinition():Dynamic return switch (cast this:DragonJapaneseCuisineItem) {
        case RamenSet: DragonJapaneseCuisineMenu.DragonJapaneseCuisineRamenSet;
        case RiceSet: DragonJapaneseCuisineMenu.DragonJapaneseCuisineRiceSet;
        case SingleItem: DragonJapaneseCuisineMenu.DragonJapaneseCuisineSingleItem;
    }
}

class DragonJapaneseCuisineMenu {
    static public final DragonJapaneseCuisineSetDrink = {
        title: "跟餐飲品",
        type: "string",
        "enum": [
            "柑桔紙包飲品",
            "烏龍茶紙包飲品",
        ],
    };

    static public final DragonJapaneseCuisineRamenSet = {
        title: "拉麵",
        properties: {
            main: {
                title: "拉麵",
                type: "string",
                "enum": [
                    "鹽酥雞拉麵 $50",
                    "極盛叉燒拉麵 $50",
                    "火炙叉燒拉麵 $55",
                    "日式餃子拉麵 $48",
                    "吉列猪扒拉麵 $55",
                    "黑蒜油火炙叉燒拉麵(配1隻糖心蛋) $60",
                    "厚條鰻魚拉麵 $65",
                ]
            },
            options: {
                type: "array",
                title: "升級選項",
                items: {
                    type: "string",
                    "enum": [
                        "轉地獄湯底 +$5",
                        "轉黑蒜油湯底 +$8",
                        "拉麵加底 +$5",
                        "加糖心蛋 +$8",
                        "轉烏冬 +$0",
                    ],
                },
                uniqueItems: true,
            },
            drink: DragonJapaneseCuisineSetDrink,
        },
        required: [
            "main",
            "drink",
        ]
    };

    static public final DragonJapaneseCuisineRiceSet = {
        title: "飯類／輕食",
        properties: {
            main: {
                title: "飯類／輕食",
                type: "string",
                "enum": [
                    "滷肉飯配滷蛋 $38",
                    "滷肉飯配原味台灣腸 $40",
                    "滷肉飯配鹽酥雞 $45",
                    "唐揚炸雞飯 $45",
                    "吉列猪扒飯拼韮菜餃子(3隻)  $55",
                    "吉列猪扒飯拼燒汁雞肉串(3串) $55",
                    "香蔥火炙叉燒溫泉蛋飯 $58",
                    "原條鰻魚飯 $65",
                ]
            },
            drink: DragonJapaneseCuisineSetDrink,
        },
        required: [
            "main",
            "drink",
        ]
    }

    static public final DragonJapaneseCuisineSingleItem = {
        title: "小食",
        type: "string",
        "enum": [
            "章魚小丸子(6粒) $35",
            "鹽酥雞 $38",
            "日式韮菜餃子 (5隻) $28",
            "燒汁雞肉串 (3串) $25",
            "香甜南瓜薯餅 $15",
            "爆脆芝士薯餅 $18",
            "自家麻辣脆雞翼(4隻) $25",
        ]
    }
    
    static public function itemsSchema(order:FormOrderData):Dynamic {
        function itemSchema():Dynamic return {
            type: "object",
            properties: {
                type: {
                    title: "食物種類",
                    type: "string",
                    oneOf: DragonJapaneseCuisineItem.all.map(item -> {
                        title: item.getDefinition().title,
                        const: item,
                    }),
                },
            },
            required: [
                "type",
            ],
        };
        return {
            type: "array",
            items: order.items == null || order.items.length == 0 ? itemSchema() : order.items.map(item -> {
                var itemSchema:Dynamic = itemSchema();
                switch (cast item.type:DragonJapaneseCuisineItem) {
                    case null:
                        //pass
                    case itemType:
                        Object.assign(itemSchema.properties, {
                            item: itemType.getDefinition(),
                        });
                        itemSchema.required.push("item");
                }
                itemSchema;
            }),
            additionalItems: itemSchema(),
            minItems: 1,
        };
    }

    static function summarizeItem(orderItem:{
        ?type:DragonJapaneseCuisineItem,
        ?item:Dynamic,
    }):{
        orderDetails:String,
        orderPrice:Float,
    } {
        var def = orderItem.type.getDefinition();
        return switch (orderItem.type) {
            case RamenSet:
                summarizeOrderObject(orderItem.item, def, ["main", "options", "drink"]);
            case RiceSet:
                summarizeOrderObject(orderItem.item, def, ["main", "drink"]);
            case SingleItem:
                switch (orderItem.item:Null<String>) {
                    case v if (Std.isOfType(v, String)):
                        {
                            orderDetails: fullWidthDot + v,
                            orderPrice: v.parsePrice().price,
                        }
                    case _:
                        {
                            orderDetails: "",
                            orderPrice: 0.0,
                        }
                }
            case _:
                {
                    orderDetails: "",
                    orderPrice: 0.0,
                }
        }
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