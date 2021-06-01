package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;
using Lambda;

enum abstract BlaBlaBlaItem(String) to String {
    final HotDrink;
    final IceDrink;

    static public final all:ReadOnlyArray<BlaBlaBlaItem> = [
        HotDrink,
        IceDrink,
    ];

    public function getDefinition():Dynamic return switch (cast this:BlaBlaBlaItem) {
        case HotDrink: BlaBlaBlaMenu.BlaBlaBlaHotDrink;
        case IceDrink: BlaBlaBlaMenu.BlaBlaBlaIceDrink;
    }
}

class BlaBlaBlaMenu {
    static public final normalSweet = "正常";
    static public final normalIce = "正常";
    static public final sweetOpts = ["無糖", "微糖", "少糖", normalSweet, "多糖"];
    static public final honeyOpts = ["無糖不加蜂蜜", "微糖只加蜂蜜", normalSweet];
    static public final iceOpts = ["走冰", "微冰", "少冰", normalIce, "多冰"];
    static public final hotDrinks = [
        { name:"熱蜂蜜普洱珍珠鮮奶茶 $33", sweetOpts: honeyOpts, },
        { name:"熱芋頭鮮奶 $33", sweetOpts: [normalSweet], },
        { name:"熱芋圓鮮奶烏龍 $30", sweetOpts: sweetOpts, },
        { name:"熱西柚檸檬果茶 $30", sweetOpts: sweetOpts, },
        { name:"熱伯爵鮮奶茶 $27", sweetOpts: sweetOpts, },
        { name:"熱冬瓜檸檬 $25", sweetOpts: [normalSweet], },
        { name:"熱桂花青茶 $27", sweetOpts: sweetOpts, },
        { name:"熱百香果綠茶 $27", sweetOpts: sweetOpts, },
        { name:"熱蜂蜜柚子綠茶 $27", sweetOpts: sweetOpts, },
        { name:"熱西柚綠茶 $27", sweetOpts: sweetOpts, },
        { name:"熱玫瑰茉莉綠茶 $27", sweetOpts: sweetOpts, },
        { name:"熱烏龍鮮奶茶 $27", sweetOpts: sweetOpts, },
        { name:"熱茉莉鮮綠奶 $27", sweetOpts: sweetOpts, },
        { name:"熱精選鮮奶茶 $27", sweetOpts: sweetOpts, },
        { name:"熱雞蛋布丁鮮奶茶 $30", sweetOpts: sweetOpts, },
        { name:"熱台式冬瓜茶 $20", sweetOpts: [normalSweet], },
    ];
    static public final iceDrinks = [
        { name:"凍蜂蜜普洱珍珠鮮奶茶 $33", sweetOpts: honeyOpts, },
        { name:"凍芋頭鮮奶 $33", sweetOpts: [normalSweet], },
        { name:"凍芋圓鮮奶烏龍 $30", sweetOpts: sweetOpts, },
        { name:"凍西柚檸檬果茶 $30", sweetOpts: sweetOpts, },
        { name:"凍伯爵鮮奶茶 $27", sweetOpts: sweetOpts, },
        { name:"凍冬瓜檸檬 $25", sweetOpts: [normalSweet], },
        { name:"凍桂花青茶 $27", sweetOpts: sweetOpts, },
        { name:"凍百香果綠茶 $27", sweetOpts: sweetOpts, },
        { name:"鳳梨冰茶 $27", sweetOpts: sweetOpts, },
        { name:"凍蜂蜜柚子綠茶 $27", sweetOpts: sweetOpts, },
        { name:"凍西柚綠茶 $27", sweetOpts: sweetOpts, },
        { name:"凍玫瑰茉莉綠茶 $27", sweetOpts: sweetOpts, },
        { name:"凍烏龍鮮奶茶 $27", sweetOpts: sweetOpts, },
        { name:"凍茉莉鮮綠奶 $27", sweetOpts: sweetOpts, },
        { name:"凍精選鮮奶茶 $27", sweetOpts: sweetOpts, },
        { name:"凍雞蛋布丁鮮奶茶 $30", sweetOpts: sweetOpts, },
        { name:"凍台式冬瓜茶 $20", sweetOpts: [normalSweet], },
    ];

    static public final BlaBlaBlaHotDrink = {
        title: "熱飲",
        type: "object",
        properties: {
            drink: {
                type: "string",
                title: "熱飲",
                "enum": hotDrinks.map(d -> d.name),
            },
            sweetOpt: {
                type: "string",
                title: "甜度",
                "default": normalSweet,
            },
        },
        required: [
            "drink",
            "sweetOpt",
        ]
    };

    static public final BlaBlaBlaIceDrink = {
        title: "凍飲",
        type: "object",
        properties: {
            drink: {
                type: "string",
                title: "凍飲",
                "enum": iceDrinks.map(d -> d.name),
            },
            sweetOpt: {
                type: "string",
                title: "甜度",
                "default": normalSweet,
            },
            iceOpt: {
                type: "string",
                title: "冰量",
                "enum": iceOpts,
                "default": normalIce,
            },
        },
        required: [
            "drink",
            "sweetOpt",
            "iceOpt",
        ]
    };
    
    static public function itemsSchema(order:FormOrderData):Dynamic {
        function itemSchema():Dynamic return {
            type: "object",
            properties: {
                type: {
                    title: "飲品種類",
                    type: "string",
                    oneOf: BlaBlaBlaItem.all.map(item -> {
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
                switch (cast item.type:BlaBlaBlaItem) {
                    case null:
                        //pass
                    case itemType:
                        Object.assign(itemSchema.properties, {
                            item: itemType.getDefinition(),
                        });
                        var sweetOpts = switch (item.item:Null<{drink:Null<String>}>) {
                            case null | { drink:null }:
                                [normalSweet];
                            case hotDrinks.find(d -> d.name == _.drink) => d if (d != null):
                                d.sweetOpts;
                            case iceDrinks.find(d -> d.name == _.drink) => d if (d != null):
                                d.sweetOpts;
                            case _:
                                [normalSweet];
                        }
                        Reflect.setField(itemSchema.properties.item.properties.sweetOpt, "enum", sweetOpts);
                        itemSchema.required.push("item");
                }
                itemSchema;
            }),
            additionalItems: itemSchema(),
            minItems: 1,
        };
    }

    static function summarizeItem(orderItem:{
        ?type:BlaBlaBlaItem,
        ?item:Dynamic,
    }):{
        orderDetails:String,
        orderPrice:Float,
    } {
        var def = orderItem.type.getDefinition();
        return switch (orderItem.type) {
            case HotDrink:
                summarizeOrderObject(orderItem.item, def, ["drink", "sweetOpt"]);
            case IceDrink:
                summarizeOrderObject(orderItem.item, def, ["drink", "sweetOpt", "iceOpt"]);
            case _:
                {
                    orderDetails: "",
                    orderPrice: 0,
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