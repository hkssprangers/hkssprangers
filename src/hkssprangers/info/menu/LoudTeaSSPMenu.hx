package hkssprangers.info.menu;

#if js
import js.lib.Object;
#end
import haxe.ds.ReadOnlyArray;
import hkssprangers.info.MenuTools.*;
using Lambda;
using hkssprangers.MathTools;
using hxLINQ.LINQ;

enum abstract LoudTeaSSPItem(String) to String {
    final Drink;

    static public final all:ReadOnlyArray<LoudTeaSSPItem> = [
        Drink,
    ];

    public function getTitle():String return switch (cast this:LoudTeaSSPItem) {
        case Drink: "飲品";
    }

    #if js
    public function getDefinition(drinks:Map<LoudTeaSSPDrinkCategory,ReadOnlyArray<LoudTeaSSPDrink>>, value:LoudTeaSSPDrinkItem):Dynamic {
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
                    oneOf: drinks.linq()
                        .selectMany((ds,i) -> ds.array())
                        .select((d,i) -> {
                            const: d.name,
                            title: d.name + ' (${d.types.join("/")})' + " $" + d.price,
                        })
                        .toArray()
                    ,
                };
                def.required.push("drink");

                if (value != null && value.drink != null) {
                    final drink = drinks.linq()
                        .selectMany((ds,i) -> ds.array())
                        .where((d,i) -> d.name == value.drink)
                        .first();
                    if (drink.types.length > 1) {
                        def.properties.type = {
                            type: "string",
                            title: LoudTeaSSPDrinkType.title,
                            "enum": drink.types,
                        }
                        def.required.push("type");
                    }

                    if ((drink.types.length == 1 && drink.types[0] == Iced) || value.type == Iced) {
                        final iceOpts = drink.iceOpts.copy();
                        // 轉鮮奶不能走冰
                        if (value.extraOptions != null && value.extraOptions.contains(FreshMilk)) {
                            iceOpts.remove(Free);
                        }
                        def.properties.iceLevel = {
                            type: "string",
                            title: LoudTeaSSPIceOption.title,
                            "enum": iceOpts,
                            "default": iceOpts[0],
                        }
                        def.required.push("iceLevel");
                    }

                    {
                        def.properties.sweetness = {
                            type: "string",
                            title: LoudTeaSSPSweetOption.title,
                            "enum": drink.sweetOpts,
                            "default": drink.sweetOpts[0],
                        }
                        def.required.push("sweetness");
                    }

                    if (drink.milkFoamOpts != null) {
                        def.properties.milkFoam = {
                            type: "string",
                            title: LoudTeaSSPMilkFoamOption.title,
                            "enum": drink.milkFoamOpts,
                        }
                        def.required.push("milkFoam");
                    }

                    if (drink.pearlOpts != null) {
                        def.properties.pearl = {
                            type: "string",
                            title: LoudTeaSSPPearlOption.title,
                            "enum": drink.pearlOpts,
                            "default": drink.pearlOpts[0],
                        }
                        def.required.push("pearl");
                    }

                    if (drink.teaOpts != null) {
                        def.properties.tea = {
                            type: "string",
                            title: LoudTeaSSPTeaOption.title,
                            "enum": value.type == Hot ? drink.teaOpts.filter(t -> t != BubbleSoda) : drink.teaOpts,
                        }
                        def.required.push("tea");
                    }

                    if (drink.extraOptions != null) {
                        def.properties.extraOptions = {
                            type: "array",
                            title: LoudTeaSSPExtraOption.title,
                            items: {
                                type: "string",
                                "enum": drink.extraOptions,
                            },
                            uniqueItems: true,
                        }
                    }
                }

                def;
        }
    }
    #end
}

typedef LoudTeaSSPDrink = {
    name:String,
    price:Int,
    ?iceOpts:ReadOnlyArray<LoudTeaSSPIceOption>,
    sweetOpts:ReadOnlyArray<LoudTeaSSPSweetOption>,
    types:ReadOnlyArray<LoudTeaSSPDrinkType>,
    ?milkFoamOpts:ReadOnlyArray<LoudTeaSSPMilkFoamOption>,
    ?pearlOpts:ReadOnlyArray<LoudTeaSSPPearlOption>,
    ?teaOpts:ReadOnlyArray<String>,
    ?extraOptions:ReadOnlyArray<String>,
}

typedef LoudTeaSSPDrinkItem = {
    drink:String,
    ?type:LoudTeaSSPDrinkType,
    ?iceLevel:LoudTeaSSPIceOption,
    sweetness:LoudTeaSSPSweetOption,
    ?milkFoam:LoudTeaSSPMilkFoamOption,
    ?pearl:LoudTeaSSPPearlOption,
    ?tea:LoudTeaSSPTeaOption,
    ?extraOptions:Array<LoudTeaSSPExtraOption>,
}

enum abstract LoudTeaSSPDrinkType(String) to String {
    static public final title = "類別";

    final Iced = "凍";
    final Hot = "熱";
}

enum abstract LoudTeaSSPIceOption(String) to String {
    static public final title = "冰量";

    final Fixed = "固定";
    final Regular = "正常 100%";
    final Less = "少冰 50%";
    final Minimal = "微冰 25%";
    final Free = "走冰 0%";

    static public final all:ReadOnlyArray<LoudTeaSSPIceOption> = [Regular, Less, Minimal, Free];
    static public final fixed:ReadOnlyArray<LoudTeaSSPIceOption> = [Fixed];
    static public final required:ReadOnlyArray<LoudTeaSSPIceOption> = [Regular, Less, Minimal];
}

enum abstract LoudTeaSSPSweetOption(String) to String {
    static public final title = "甜度";

    final Fixed = "固定";
    final Regular = "全糖 100%";
    final Less = "少糖 75%";
    final Half = "半糖 50%";
    final Quarter = "微糖 25%";
    final Free = "無糖 0%";

    static public final all:ReadOnlyArray<LoudTeaSSPSweetOption> = [Regular, Less, Half, Quarter, Free];
    static public final fixed:ReadOnlyArray<LoudTeaSSPSweetOption> = [Fixed];
    static public final required:ReadOnlyArray<LoudTeaSSPSweetOption> = [Regular, Less, Half, Quarter];
}

enum abstract LoudTeaSSPMilkFoamOption(String) to String {
    static public final title = "奶蓋";

    final Original = "原味";
    final Sesame = "芝麻";
    final Cheese = "芝士";

    static public final all:ReadOnlyArray<LoudTeaSSPMilkFoamOption> = [Original, Sesame, Cheese];
}

enum abstract LoudTeaSSPPearlOption(String) to String {
    static public final title = "配料";

    final BlackPearl = "珍珠";
    final Pudding = "轉布丁";
    final HerbJelly = "轉仙草";
    final NataDeCoco = "轉椰果";
    final RedBean = "轉紅豆";

    static public final all:ReadOnlyArray<LoudTeaSSPPearlOption> = [BlackPearl, Pudding, HerbJelly, NataDeCoco, RedBean];
}

enum abstract LoudTeaSSPTeaOption(String) to String {
    static public final title = "飲品";

    final BlackTea = "紅茶";
    final GreenTea = "綠茶";
    final Oolong = "烏龍";
    final Tieguanyin = "鐵觀音";
    final SpringTea = "春茶";
    final BubbleSoda = "泡泡";

    static public final teaOrSoda:ReadOnlyArray<LoudTeaSSPTeaOption> = [BlackTea, GreenTea, Oolong, BubbleSoda];
    static public final teas:ReadOnlyArray<LoudTeaSSPTeaOption> = [BlackTea, GreenTea, Oolong, Tieguanyin];
    static public final springTeaOrSoda:ReadOnlyArray<LoudTeaSSPTeaOption> = [SpringTea, BubbleSoda];
}

enum abstract LoudTeaSSPExtraOption(String) to String {
    #if (!macro)
    static public final title = "選項";

    final FreshMilk = markupItem("轉鮮奶", 5);

    static public final freshMilk:ReadOnlyArray<LoudTeaSSPExtraOption> = [FreshMilk];
    #end

    macro static public function markupItem(name:String, price:Int) {
        return macro $v{name + " +$" + LoudTeaSSPMenu.markup(price)};
    }
}

enum abstract LoudTeaSSPDrinkCategory(String) to String {
    final SignatureDrink = "精選系列";
    final FourSeasonsOfSpringTea = "四季如春系列";
    final BrownSugarFlavoredLatte = "黑糖系列";
    final ClassicChineseTea = "清茶系列";
    final FreshFruitTea_BubbleSoda = "水果茶•泡泡系列";
    final MilkTeaWithBlackPearl = "珍珠奶茶系列";
    final MilkFoamSpecial = "奶蓋系列";
}

class LoudTeaSSPMenu {
    static public function markup(price:Int):Int {
        return Math.round(price * 1.2);
    }

    #if js
    static public function getDrinks(year:Int):Map<LoudTeaSSPDrinkCategory,ReadOnlyArray<LoudTeaSSPDrink>> {
        return drinks2023;
    }
    static public final drinks2023:Map<LoudTeaSSPDrinkCategory,ReadOnlyArray<LoudTeaSSPDrink>> = [
        // 精選系列
        SignatureDrink => [
            {
                name: "綠茶多多",
                price: markup(27),
                types: [Iced],
                sweetOpts: LoudTeaSSPSweetOption.required,
                iceOpts: LoudTeaSSPIceOption.all,
            },
            {
                name: "冬瓜仙草茶",
                price: markup(28),
                types: [Iced, Hot],
                sweetOpts: LoudTeaSSPSweetOption.fixed,
                iceOpts: LoudTeaSSPIceOption.all,
            },
            // {
            //     name: "冬瓜鮮奶",
            //     price: markup(30),
            //     types: [Iced, Hot],
            //     sweetOpts: LoudTeaSSPSweetOption.fixed,
            //     iceOpts: LoudTeaSSPIceOption.required,
            // },
            {
                name: "鳯梨綠茶多多",
                price: markup(32),
                types: [Iced],
                sweetOpts: LoudTeaSSPSweetOption.fixed,
                iceOpts: LoudTeaSSPIceOption.all,
            },
            {
                name: "薄荷Oreo鮮奶",
                price: markup(36),
                types: [Iced],
                sweetOpts: LoudTeaSSPSweetOption.fixed,
                iceOpts: LoudTeaSSPIceOption.fixed,
            },
            {
                name: "牛油果鮮奶波波",
                price: markup(38),
                types: [Iced],
                sweetOpts: LoudTeaSSPSweetOption.all,
                iceOpts: LoudTeaSSPIceOption.fixed,
            },
            {
                name: "紫薯芋泥鮮奶波波",
                price: markup(39),
                types: [Iced, Hot],
                sweetOpts: LoudTeaSSPSweetOption.all,
                iceOpts: LoudTeaSSPIceOption.required,
            },
            {
                name: "芒果鮮奶茶",
                price: markup(42),
                types: [Iced],
                sweetOpts: LoudTeaSSPSweetOption.required,
                iceOpts: LoudTeaSSPIceOption.fixed,
            },
        ],
        // 四季如春系列
        FourSeasonsOfSpringTea => [
            {
                name: "四季如春 四季春茶",
                price: markup(31),
                types: [Iced, Hot],
                sweetOpts: LoudTeaSSPSweetOption.all,
                iceOpts: LoudTeaSSPIceOption.all,
                milkFoamOpts: LoudTeaSSPMilkFoamOption.all,
            },
            {
                name: "四季如春 黃金鳳梨",
                price: markup(39),
                types: [Iced],
                sweetOpts: LoudTeaSSPSweetOption.fixed,
                iceOpts: LoudTeaSSPIceOption.fixed,
                milkFoamOpts: LoudTeaSSPMilkFoamOption.all,
            },
            {
                name: "四季如春 番石榴",
                price: markup(39),
                types: [Iced],
                sweetOpts: LoudTeaSSPSweetOption.fixed,
                iceOpts: LoudTeaSSPIceOption.fixed,
                milkFoamOpts: LoudTeaSSPMilkFoamOption.all,
            },
            {
                name: "四季如春 橙橙",
                price: markup(39),
                types: [Iced],
                sweetOpts: LoudTeaSSPSweetOption.fixed,
                iceOpts: LoudTeaSSPIceOption.fixed,
                milkFoamOpts: LoudTeaSSPMilkFoamOption.all,
            },
            {
                name: "四季如春 吱吱西瓜",
                price: markup(39),
                types: [Iced],
                sweetOpts: LoudTeaSSPSweetOption.fixed,
                iceOpts: LoudTeaSSPIceOption.fixed,
                milkFoamOpts: LoudTeaSSPMilkFoamOption.all,
            },
            {
                name: "四季如春 黃金香蕉",
                price: markup(39),
                types: [Iced],
                sweetOpts: LoudTeaSSPSweetOption.fixed,
                iceOpts: LoudTeaSSPIceOption.fixed,
                milkFoamOpts: LoudTeaSSPMilkFoamOption.all,
            },
            {
                name: "四季如春 芒芒",
                price: markup(42),
                types: [Iced],
                sweetOpts: LoudTeaSSPSweetOption.fixed,
                iceOpts: LoudTeaSSPIceOption.fixed,
                milkFoamOpts: LoudTeaSSPMilkFoamOption.all,
            },
            {
                name: "四季如春 粉荔枝芝",
                price: markup(44),
                types: [Iced],
                sweetOpts: LoudTeaSSPSweetOption.fixed,
                iceOpts: LoudTeaSSPIceOption.fixed,
                milkFoamOpts: LoudTeaSSPMilkFoamOption.all,
            },
        ],
        // 黑糖系列
        BrownSugarFlavoredLatte => [
            {
                name: "黑糖薑茶",
                price: markup(26),
                types: [Hot],
                sweetOpts: LoudTeaSSPSweetOption.fixed,
            },
            {
                name: "黑糖薑撞鮮奶",
                price: markup(30),
                types: [Iced, Hot],
                sweetOpts: LoudTeaSSPSweetOption.fixed,
                iceOpts: LoudTeaSSPIceOption.required,
            },
            {
                name: "黑糖豆腐鮮奶",
                price: markup(30),
                types: [Iced, Hot],
                sweetOpts: LoudTeaSSPSweetOption.fixed,
                iceOpts: LoudTeaSSPIceOption.required,
            },
            {
                name: "黑糖瀑布乳牛珍珠鮮奶",
                price: markup(30),
                types: [Iced, Hot],
                sweetOpts: LoudTeaSSPSweetOption.fixed,
                iceOpts: LoudTeaSSPIceOption.required,
                pearlOpts: LoudTeaSSPPearlOption.all,
            },
            {
                name: "黑糖Oreo珍珠鮮奶",
                price: markup(35),
                types: [Iced, Hot],
                sweetOpts: LoudTeaSSPSweetOption.fixed,
                iceOpts: LoudTeaSSPIceOption.required,
                pearlOpts: LoudTeaSSPPearlOption.all,
            },
        ],
        // 清茶系列
        ClassicChineseTea => [
            {
                name: "清茶 頂級鐵觀音",
                price: markup(16),
                types: [Iced, Hot],
                sweetOpts: LoudTeaSSPSweetOption.all,
                iceOpts: LoudTeaSSPIceOption.all,
            },
            {
                name: "清茶 阿薩姆紅茶",
                price: markup(16),
                types: [Iced, Hot],
                sweetOpts: LoudTeaSSPSweetOption.all,
                iceOpts: LoudTeaSSPIceOption.all,
            },
            {
                name: "清茶 御品綠茶",
                price: markup(16),
                types: [Iced, Hot],
                sweetOpts: LoudTeaSSPSweetOption.all,
                iceOpts: LoudTeaSSPIceOption.all,
            },
            {
                name: "清茶 碳焙烏龍",
                price: markup(17),
                types: [Iced, Hot],
                sweetOpts: LoudTeaSSPSweetOption.all,
                iceOpts: LoudTeaSSPIceOption.all,
            },
            {
                name: "清茶 四季春茶",
                price: markup(21),
                types: [Iced, Hot],
                sweetOpts: LoudTeaSSPSweetOption.all,
                iceOpts: LoudTeaSSPIceOption.all,
            },
        ],
        // 水果茶•泡泡系列
        FreshFruitTea_BubbleSoda => [
            {
                name: "滋潤蜂蜜青檸",
                price: markup(25),
                types: [Iced, Hot],
                sweetOpts: LoudTeaSSPSweetOption.required,
                iceOpts: LoudTeaSSPIceOption.all,
                teaOpts: LoudTeaSSPTeaOption.teaOrSoda,
            },
            {
                name: "黃金鳳梨水果",
                price: markup(29),
                types: [Iced, Hot],
                sweetOpts: LoudTeaSSPSweetOption.all,
                iceOpts: LoudTeaSSPIceOption.all,
                teaOpts: LoudTeaSSPTeaOption.teaOrSoda,
            },
            {
                name: "杯杯西柚水果",
                price: markup(29),
                types: [Iced, Hot],
                sweetOpts: LoudTeaSSPSweetOption.all,
                iceOpts: LoudTeaSSPIceOption.all,
                teaOpts: LoudTeaSSPTeaOption.teaOrSoda,
            },
            {
                name: "青青提子水果",
                price: markup(29),
                types: [Iced, Hot],
                    sweetOpts: LoudTeaSSPSweetOption.all,
                    iceOpts: LoudTeaSSPIceOption.all,
                    teaOpts: LoudTeaSSPTeaOption.teaOrSoda,
            },
            {
                name: "清新香橙水果",
                price: markup(29),
                types: [Iced, Hot],
                sweetOpts: LoudTeaSSPSweetOption.all,
                iceOpts: LoudTeaSSPIceOption.all,
                teaOpts: LoudTeaSSPTeaOption.teaOrSoda,
            },
            {
                name: "火紅荔枝水果",
                price: markup(29),
                types: [Iced, Hot],
                sweetOpts: LoudTeaSSPSweetOption.all,
                iceOpts: LoudTeaSSPIceOption.all,
                teaOpts: LoudTeaSSPTeaOption.teaOrSoda,
            },
            {
                name: "粒粒百香果水果",
                price: markup(29),
                types: [Iced, Hot],
                sweetOpts: LoudTeaSSPSweetOption.all,
                iceOpts: LoudTeaSSPIceOption.all,
                teaOpts: LoudTeaSSPTeaOption.teaOrSoda,
            },
            {
                name: "36D水蜜桃水果",
                price: markup(29),
                types: [Iced, Hot],
                sweetOpts: LoudTeaSSPSweetOption.all,
                iceOpts: LoudTeaSSPIceOption.all,
                teaOpts: LoudTeaSSPTeaOption.teaOrSoda,
            },
            {
                name: "豐響水果 (橙、芒果、火龍果、西柚)",
                price: markup(35),
                types: [Iced, Hot],
                sweetOpts: LoudTeaSSPSweetOption.all,
                iceOpts: LoudTeaSSPIceOption.all,
                teaOpts: LoudTeaSSPTeaOption.springTeaOrSoda,
            },
        ],
        // 珍珠奶茶系列
        MilkTeaWithBlackPearl => [
            {
                name: "阿薩姆紅茶珍珠奶茶",
                price: markup(20),
                types: [Iced, Hot],
                sweetOpts: LoudTeaSSPSweetOption.all,
                iceOpts: LoudTeaSSPIceOption.all,
                pearlOpts: LoudTeaSSPPearlOption.all,
                extraOptions: LoudTeaSSPExtraOption.freshMilk,
            },
            {
                name: "頂級鐵觀音珍珠奶茶",
                price: markup(22),
                types: [Iced, Hot],
                sweetOpts: LoudTeaSSPSweetOption.all,
                iceOpts: LoudTeaSSPIceOption.all,
                pearlOpts: LoudTeaSSPPearlOption.all,
                extraOptions: LoudTeaSSPExtraOption.freshMilk,
            },
            {
                name: "御品綠茶珍珠奶茶",
                price: markup(22),
                types: [Iced, Hot],
                sweetOpts: LoudTeaSSPSweetOption.all,
                iceOpts: LoudTeaSSPIceOption.all,
                pearlOpts: LoudTeaSSPPearlOption.all,
                extraOptions: LoudTeaSSPExtraOption.freshMilk,
            },
            {
                name: "碳焙鳥龍珍珠奶茶",
                price: markup(24),
                types: [Iced, Hot],
                sweetOpts: LoudTeaSSPSweetOption.all,
                iceOpts: LoudTeaSSPIceOption.all,
                pearlOpts: LoudTeaSSPPearlOption.all,
                extraOptions: LoudTeaSSPExtraOption.freshMilk,
            },
            {
                name: "香芋珍珠奶茶",
                price: markup(24),
                types: [Iced, Hot],
                sweetOpts: LoudTeaSSPSweetOption.required,
                iceOpts: LoudTeaSSPIceOption.all,
                pearlOpts: LoudTeaSSPPearlOption.all,
                extraOptions: LoudTeaSSPExtraOption.freshMilk,
            },
            {
                name: "香芋珍珠奶綠",
                price: markup(26),
                types: [Iced, Hot],
                sweetOpts: LoudTeaSSPSweetOption.required,
                iceOpts: LoudTeaSSPIceOption.all,
                pearlOpts: LoudTeaSSPPearlOption.all,
                extraOptions: LoudTeaSSPExtraOption.freshMilk,
            },
            {
                name: "抹茶珍珠奶茶",
                price: markup(24),
                types: [Iced, Hot],
                sweetOpts: LoudTeaSSPSweetOption.required,
                iceOpts: LoudTeaSSPIceOption.all,
                pearlOpts: LoudTeaSSPPearlOption.all,
                extraOptions: LoudTeaSSPExtraOption.freshMilk,
            },
            {
                name: "抹茶珍珠奶綠",
                price: markup(26),
                types: [Iced, Hot],
                sweetOpts: LoudTeaSSPSweetOption.required,
                iceOpts: LoudTeaSSPIceOption.all,
                pearlOpts: LoudTeaSSPPearlOption.all,
                extraOptions: LoudTeaSSPExtraOption.freshMilk,
            },
        ],
        // 奶蓋系列
        MilkFoamSpecial => [
            {
                name: "原味奶蓋",
                price: markup(25),
                types: [Iced, Hot],
                sweetOpts: LoudTeaSSPSweetOption.all,
                iceOpts: LoudTeaSSPIceOption.all,
                teaOpts: LoudTeaSSPTeaOption.teas,
            },
            {
                name: "芝麻奶蓋",
                price: markup(26),
                types: [Iced, Hot],
                sweetOpts: LoudTeaSSPSweetOption.required,
                iceOpts: LoudTeaSSPIceOption.all,
                teaOpts: LoudTeaSSPTeaOption.teas,
            },
            {
                name: "芝士奶蓋",
                price: markup(28),
                types: [Iced, Hot],
                sweetOpts: LoudTeaSSPSweetOption.all,
                iceOpts: LoudTeaSSPIceOption.all,
                teaOpts: LoudTeaSSPTeaOption.teas,
            }
        ],
    ];

    static public function itemsSchema(pickupTimeSlot:TimeSlot, order:FormOrderData):Dynamic {
        final drinks = getDrinks(pickupTimeSlot != null && pickupTimeSlot.start != null ? pickupTimeSlot.start.toDate().getFullYear() : null);
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
                            item: itemType.getDefinition(drinks, item.item),
                        });
                        itemSchema.required.push("item");
                }
                itemSchema;
            }),
            additionalItems: itemSchema(),
            minItems: 1,
        };
    }

    static function summarizeItem(
        drinks:Map<LoudTeaSSPDrinkCategory,ReadOnlyArray<LoudTeaSSPDrink>>,
        orderItem:{
            ?type:LoudTeaSSPItem,
            ?item:Dynamic,
        }
    ):{
        orderDetails:String,
        orderPrice:Float,
    } {
        final def = orderItem.type.getDefinition(drinks, orderItem.item);
        return switch (orderItem.type) {
            case Drink:
                final item:LoudTeaSSPDrinkItem = orderItem.item;
                final drink = drinks.linq()
                    .selectMany((ds,i) -> ds.array())
                    .where((d,i) -> d.name == item.drink)
                    .first();
                {
                    orderDetails:
                        fullWidthDot + drink.name + ' (${drink.types.length > 1 ? item.type : drink.types[0]})' + " $" + drink.price
                        + (item.iceLevel == null ? "" : "\n" + fullWidthSpace + LoudTeaSSPIceOption.title + fullWidthColon + item.iceLevel)
                        + (item.sweetness == null ? "" : "\n" + fullWidthSpace + LoudTeaSSPSweetOption.title + fullWidthColon + item.sweetness)
                        + (item.milkFoam == null ? "" : "\n" + fullWidthSpace + LoudTeaSSPMilkFoamOption.title + fullWidthColon + item.milkFoam)
                        + (item.pearl == null || item.pearl == BlackPearl ? "" : "\n" + fullWidthSpace + LoudTeaSSPPearlOption.title + fullWidthColon + item.pearl)
                        + (item.tea == null ? "" : "\n" + fullWidthSpace + LoudTeaSSPTeaOption.title + fullWidthColon + item.tea)
                        + (item.extraOptions == null ? "" : item.extraOptions.map(opt -> "\n" + fullWidthSpace + LoudTeaSSPExtraOption.title + fullWidthColon + opt).join(""))
                    ,
                    orderPrice: drink.price + (item.extraOptions == null ? 0 : item.extraOptions.map(opt -> parsePrice(opt).price).sum()),
                }
            case _:
                {
                    orderDetails: "",
                    orderPrice: 0,
                }
        }
    }

    static public function summarize(
        pickupTimeSlot:TimeSlot,
        formData:FormOrderData
    ):OrderSummary {
        final drinks = getDrinks(pickupTimeSlot != null && pickupTimeSlot.start != null ? pickupTimeSlot.start.toDate().getFullYear() : null);
        final s = concatSummaries(formData.items.map(item -> summarizeItem(drinks, cast item)));
        return {
            orderDetails: s.orderDetails,
            orderPrice: s.orderPrice,
            wantTableware: formData.wantTableware,
            customerNote: formData.customerNote,
        }
    }
    #end
}