package hkssprangers.info.menu;

import hkssprangers.browser.forms.OrderForm.OrderData;
import js.lib.Object;
import haxe.ds.ReadOnlyArray;
using Lambda;

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
    ];
    
    static public function itemsSchema(order:OrderData):Dynamic {
        function itemSchema():Dynamic return {
            title: "飲品",
            type: "object",
            properties: {
                drink: {
                    type: "string",
                    title: "飲品選擇",
                    "enum": hotDrinks.map(d -> d.name).concat(iceDrinks.map(d -> d.name)),
                },
            },
            required: [
                "drink",
            ]
        };
        return {
            type: "array",
            items: order.items == null ? [] : order.items.map(item -> {
                var itemSchema:Dynamic = itemSchema();
                switch (hotDrinks.find(d -> d.name == item.drink)) {
                    case null:
                        //pass
                    case hotDrink:
                        Object.assign(itemSchema.properties, {
                            sweetOpt: {
                                type: "string",
                                title: "甜度選擇",
                                "enum": hotDrink.sweetOpts,
                                "default": normalSweet,
                            },
                        });
                        itemSchema.required.push("sweetOpt");
                }
                switch (iceDrinks.find(d -> d.name == item.drink)) {
                    case null:
                        //pass
                    case iceDrink:
                        Object.assign(itemSchema.properties, {
                            sweetOpt: {
                                type: "string",
                                title: "甜度選擇",
                                "enum": iceDrink.sweetOpts,
                                "default": normalSweet,
                            },
                            iceOpt: {
                                type: "string",
                                title: "冰量選擇",
                                "enum": iceOpts,
                                "default": normalIce,
                            }
                        });
                        itemSchema.required.push("sweetOpt");
                        itemSchema.required.push("iceOpt");
                }
                itemSchema;
            }),
            additionalItems: itemSchema(),
            minItems: 1,
        };
    }
}