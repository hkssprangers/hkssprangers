package hkssprangers.info.menu;

import js.lib.Object;
import haxe.ds.ReadOnlyArray;
import hkssprangers.info.MenuTools.*;
using Lambda;

enum abstract LoudTeaSSPItem(String) to String {
    final Drink;

    static public final all:ReadOnlyArray<LoudTeaSSPItem> = [
        Drink,
    ];

    public function getTitle():String return switch (cast this:LoudTeaSSPItem) {
        case Drink: "飲品";
    }

    public function getDefinition(value:{
        ?drink:String,
    }):Dynamic {
        return switch (cast this:LoudTeaSSPItem) {
            case Drink:
                final properties:Dynamic = {};
                final def = {
                    title: Drink.getTitle(),
                    type: "object",
                    properties: properties,
                    required: [],
                };

                properties.drink = {
                    type: "string",
                    title: Drink.getTitle(),
                    oneOf: LoudTeaSSPMenu.drinks.map(d -> {
                        const: d.name,
                        title: d.name + (d.canHot ? " (凍/熱)" : " (凍)") + " $" + d.price,
                    }),
                };
                def.required.push("drink");

                if (value != null && value.drink != null) {
                    final drink = LoudTeaSSPMenu.drinks.find(d -> d.name == value.drink);
                    if (drink.canHot) {
                        def.properties.type = {
                            type: "string",
                            title: "類別",
                            "enum": ["凍", "熱"],
                        }
                        def.required.push("type");
                    }
                }

                def;
        }
    }
}

typedef LoudTeaSSPDrink = {
    name:String,
    price:Int,
    iceOpts:ReadOnlyArray<IceOptions>,
    sweetOpts:ReadOnlyArray<SweetOptions>,
    ?canHot:Bool,
    ?milkFoamOpts:Array<String>,
    ?pearlOpts:Array<String>,
    ?teaOpts:Array<String>,
    ?milkOpts:Array<String>,
}

enum abstract IceOptions(String) to String {
    final Fixed = "固定";
    final Regular = "正常 100%";
    final Less = "少冰 50%";
    final Minimal = "微冰 25%";
    final Free = "走冰 0%";
}

enum abstract SweetOptions(String) to String {
    final Fixed = "固定";
    final Regular = "全糖 100%";
    final Less = "少糖 75%";
    final Half = "半糖 50%";
    final Quarter = "微糖 25%";
    final Free = "無糖 0%";
}

class LoudTeaSSPMenu {
    static public final allIceLevels:ReadOnlyArray<IceOptions> = [Regular, Less, Minimal, Free];
    static public final fixedIceLevel:ReadOnlyArray<IceOptions> = [Fixed];
    static public final requireIce:ReadOnlyArray<IceOptions> = [Regular, Less, Minimal];

    static public final allSweetnessLevels:ReadOnlyArray<SweetOptions> = [Regular, Less, Half, Quarter, Free];
    static public final fixedSweetness:ReadOnlyArray<SweetOptions> = [Fixed];
    static public final requireSweetness:ReadOnlyArray<SweetOptions> = [Regular, Less, Half, Quarter];

    static function markup(price:Int):Int {
        return Math.round(price * 1.2);
    }

    static public final drinks:ReadOnlyArray<LoudTeaSSPDrink> = [
        // 精選系列
        {
            name: "大冬瓜茶",
            price: markup(25),
            canHot: true,
            sweetOpts: fixedSweetness,
            iceOpts: allIceLevels,
        },
        {
            name: "綠茶多多",
            price: markup(27),
            sweetOpts: fixedSweetness,
            iceOpts: allIceLevels,
        },
        {
            name: "鳳梨綠茶多多",
            price: markup(32),
            sweetOpts: fixedSweetness,
            iceOpts: allIceLevels,
        },
        {
            name: "牛油果鮮奶波波",
            price: markup(38),
            sweetOpts: fixedSweetness,
            iceOpts: fixedIceLevel,
        },
        {
            name: "紫薯芋泥鮮奶波波",
            price: markup(39),
            sweetOpts: allSweetnessLevels,
            iceOpts: allIceLevels,
        },
        {
            name: "芒果鮮奶茶",
            price: markup(39),
            sweetOpts: requireSweetness,
            iceOpts: fixedIceLevel,
        },
        // 四季如春系列
    ];
    
    static public function itemsSchema(order:FormOrderData):Dynamic {
        function itemSchema():Dynamic return {
            type: "object",
            properties: {
                type: {
                    title: "飲品種類",
                    type: "string",
                    oneOf: LoudTeaSSPItem.all.map(item -> {
                        title: item.getTitle(),
                        const: item,
                    }),
                    "default": Drink,
                },
            },
            required: [
                "type",
            ],
        };
        return {
            type: "array",
            items: order.items == null || order.items.length == 0 ? itemSchema() : order.items.map(item -> {
                final itemSchema:Dynamic = itemSchema();
                switch (cast item.type:LoudTeaSSPItem) {
                    case null:
                        //pass
                    case itemType:
                        Object.assign(itemSchema.properties, {
                            item: itemType.getDefinition(item.item),
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
        ?type:LoudTeaSSPItem,
        ?item:Dynamic,
    }):{
        orderDetails:String,
        orderPrice:Float,
    } {
        final def = orderItem.type.getDefinition(orderItem.item);
        return switch (orderItem.type) {
            case Drink:
                final item = orderItem.item;
                final drink = drinks.find(d -> d.name == item.drink);
                {
                    orderDetails: fullWidthDot + drink.name + (drink.canHot ? ' (${item.type})' : " (凍)") + " $" + drink.price,
                    orderPrice: drink.price,
                }
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