package hkssprangers.info.menu;

import js.lib.Promise;
import js.lib.Object;
import haxe.ds.ReadOnlyArray;
import hkssprangers.info.Shop;
using StringTools;
using Reflect;
using Lambda;

typedef BlackWindowItems = {
    ?Soup:{
        ?description: String,
        items: Array<{
            name:String,
            price:Float,
            ?setPrice:Float,
        }>
    },
    ?Snack:{
        ?description: String,
        items: Array<{
            name:String,
            price:Float,
            ?setPrice:Float,
        }>
    },
    ?Main:{
        ?description: String,
        items: Array<{
            name:String,
            price:Float,
        }>
    },
    ?Dessert:{
        ?description: String,
        items: Array<{
            name:String,
            price:Float,
        }>
    },
    ?Drink:{
        ?description: String,
        items: Array<{
            name:String,
            price:Float,
            ?withMainPrice:Float,
        }>
    },
    ?Coffee:{
        ?description: String,
        items: Array<{
            name:String,
            price:Float,
        }>
    },
    ?Beer:{
        ?description: String,
        items: Array<{
            name:String,
            price:Float,
        }>
    },
    ?Cocktail:{
        ?description: String,
        items: Array<{
            name:String,
            price:Float,
        }>,
    }
};

enum abstract BlackWindowItem(String) to String {
    final Set;
    final Soup;
    final Snack;
    final Main;
    final Dessert;
    final Drink;
    final Coffee;
    final Beer;
    final Cocktail;

    static public function all(timeSlot:TimeSlot):Promise<ReadOnlyArray<BlackWindowItem>>
        return BlackWindowMenu.getDefinitions(timeSlot.start).then(defs -> cast defs.fields());

    public function getTitle():String return switch (cast this:BlackWindowItem) {
        case Set: "套餐";
        case Soup: "湯";
        case Snack: "小食";
        case Main: "主食";
        case Dessert: "甜品";
        case Drink: "飲品";
        case Coffee: "咖啡";
        case Beer: "啤酒";
        case Cocktail: "Cocktails";
    }

    public function getDefinition(timeSlot:TimeSlot):Promise<Null<Dynamic>>
        return BlackWindowMenu.getDefinitions(timeSlot.start)
            .then(defs -> if (defs != null) defs[this] else null);
}

class BlackWindowMenu {
    static public final mainToSetCharge = 44;
    static public final dinnerMainMarkup = 14;

    #if (!browser)
    static function parseSetItem(itemLine:String) {
        final parseSetItem = ~/^([^\$]+?)\s*\$([0-9]+)(?:[\s,，]*跟餐\+?\$([0-9]+))?$/;
        if (!parseSetItem.match(itemLine)) {
            throw "格式有問題：" + itemLine;
        }
        if (itemLine.indexOf("/") != -1 || itemLine.indexOf("／") != -1 ) {
            throw "項目中唔應該有 '/' 字。如果有選項，請分開多個項目。例如 'Black [熱$34／凍$36]' 可以改成 'Black [熱] $34' 同 'Black [凍] $36'。";
        }
        return {
            name: parseSetItem.matched(1),
            price: Std.parseFloat(parseSetItem.matched(2)),
            setPrice: switch parseSetItem.matched(3) {
                case null: null;
                case v: Std.parseFloat(v);
            },
        };
    }
    static function parseWithMainItem(itemLine:String) {
        final parser = ~/^([^\$]+?)\s*\$([0-9]+)(?:[\s,，]*跟主食\+?\$([0-9]+))?$/;
        if (!parser.match(itemLine)) {
            throw "格式有問題：" + itemLine;
        }
        if (itemLine.indexOf("/") != -1 || itemLine.indexOf("／") != -1 ) {
            throw "項目中唔應該有 '/' 字。如果有選項，請分開多個項目。例如 'Black [熱$34／凍$36]' 可以改成 'Black [熱] $34' 同 'Black [凍] $36'。";
        }
        return {
            name: parser.matched(1),
            price: Std.parseFloat(parser.matched(2)),
            withMainPrice: switch parser.matched(3) {
                case null: null;
                case v: Std.parseFloat(v);
            },
        };
    }
    static public function parseMenu(menu:String):BlackWindowItems {
        final items:BlackWindowItems = {}
        var type:BlackWindowItem = null;
        final parseItemLine = ~/^\s*-\s*(.+)$/;
        for (line in menu.split("\n").map(StringTools.trim)) {
            if (line == "")
                continue;
            if (parseItemLine.match(line)) {
                if (type == null)
                    throw "唔知係咩類別嘅項目：" + line;
                final itemLine = parseItemLine.matched(1);
                switch type {
                    case Set:
                        throw "Set 唔會有項目";
                    case Soup:
                        items.Soup.items.push(parseSetItem(itemLine));
                    case Snack:
                        items.Snack.items.push(parseSetItem(itemLine));
                    case Main:
                        items.Main.items.push(parseSetItem(itemLine));
                    case Dessert:
                        items.Dessert.items.push(parseSetItem(itemLine));
                    case Drink:
                        items.Drink.items.push(parseWithMainItem(itemLine));
                    case Coffee:
                        items.Coffee.items.push(parseWithMainItem(itemLine));
                    case Beer:
                        items.Beer.items.push(parseWithMainItem(itemLine));
                    case Cocktail:
                        items.Cocktail.items.push(parseWithMainItem(itemLine));
                }
            } else {
                final parseTitleLine = ~/^(.+?)(?:[\[［](.+)[\]］])?$/;
                if (!parseTitleLine.match(line))
                    throw "類別格式有問題：" + line;
                final titleStr = parseTitleLine.matched(1);
                final descriptionStr = parseTitleLine.matched(2);
                type = [Soup, Snack, Main, Dessert, Drink, Coffee, Beer, Cocktail].find(v -> titleStr == v.getTitle());
                if (type == null)
                    throw "冇呢個類別：" + titleStr;
                switch (type) {
                    case Set:
                        throw "Set 唔會有項目";
                    case Soup:
                        items.Soup = {
                            description: descriptionStr,
                            items: [],
                        }
                    case Snack:
                        items.Snack = {
                            description: descriptionStr,
                            items: [],
                        }
                    case Main:
                        items.Main = {
                            description: descriptionStr,
                            items: [],
                        }
                    case Dessert:
                        items.Dessert = {
                            description: descriptionStr,
                            items: [],
                        }
                    case Drink:
                        items.Drink = {
                            description: descriptionStr,
                            items: [],
                        }
                    case Coffee:
                        items.Coffee = {
                            description: descriptionStr,
                            items: [],
                        }
                    case Beer:
                        items.Beer = {
                            description: descriptionStr,
                            items: [],
                        }
                    case Cocktail:
                        items.Cocktail = {
                            description: descriptionStr,
                            items: [],
                        }
                }
            }
        }
        return items;
    }

    static function getItems(date:LocalDateString):Promise<BlackWindowItems> {
        final date = date.toDate();
        return hkssprangers.server.CockroachDb.db.menuItem
            .where(r -> r.shopId == BlackWindow && r.startTime <= date && r.endTime >= date && !r.deleted)
            .orderBy(f -> [{ field: f.creationTime, order: Desc }])
            .first()
            .toJsPromise()
            .catchError(err -> null)
            .then(r -> r != null ? cast r.items : null);
    }

    static function toDef(timeSlotType:TimeSlotType, items:Null<BlackWindowItems>):Dynamic {
        if (items == null)
            return null;

        final mainMarkup = switch (timeSlotType) {
            case Dinner: dinnerMainMarkup;
            case _: 0;
        }
        // trace(timeSlotType + " " + mainMarkup);

        final defs:DynamicAccess<Dynamic> = {};
        for (type in [Set, Soup, Snack, Main, Dessert, Drink, Coffee, Beer, Cocktail]) {
            try {
                final def:Dynamic = switch (type) {
                    case Set:
                        {
                            title: Set.getTitle(),
                            description: "跟一款湯、一款小食",
                            properties: {
                                main: {
                                    title: Set.getTitle(),
                                    type: "string",
                                    "enum": items.Main.items.map(v ->  v.name + " $" + (v.price + mainToSetCharge + mainMarkup)),
                                },
                                soup: {
                                    title: Soup.getTitle(),
                                    type: "string",
                                    "enum": items.Soup.items.map(v ->  v.name + switch v {
                                        case {setPrice: v} if (v != null): " +$" + v;
                                        case _: "";
                                    }),
                                },
                                snack: {
                                    title: Snack.getTitle(),
                                    type: "string",
                                    "enum": items.Snack.items.map(v ->  v.name + switch v {
                                        case {setPrice: v} if (v != null): " +$" + v;
                                        case _: "";
                                    }),
                                },
                                drink: {
                                    title: "跟飲品",
                                    type: "string",
                                    "enum": items.Drink.items.map(v ->  v.name + " $" + switch v {
                                        case {withMainPrice: v} if (v != null): v;
                                        case {price: v}: v;
                                    }),
                                },
                            },
                            required: ["main", "soup", "snack"],
                        }
                    case Main:
                        final mainEnum = items.Main.items.map(v -> { name: v.name, price: v.price + mainMarkup }).map(printNamePrice);
                        final drinkEnum = if (items.Drink == null) {
                            [];
                        } else {
                            items.Drink.items.map(v ->  v.name + " $" + switch v {
                                case {withMainPrice: v} if (v != null): v;
                                case {price: v}: v;
                            });
                        }
                        trace(drinkEnum);
                        {
                            title: Main.getTitle(),
                            description: items.Main.description,
                            properties: {
                                main: {
                                    title: Main.getTitle(),
                                    type: "string",
                                    "enum": mainEnum,
                                },
                                drink: {
                                    title: "跟飲品",
                                    type: "string",
                                    "enum": drinkEnum,
                                },
                            },
                            required: ["main"],
                        };
                    case _:
                        {
                            title: type.getTitle(),
                            description: items.field(type).description,
                            type: "string",
                            "enum": items.field(type).items.map(printNamePrice),
                        };
                }
                defs[type] = def;
            } catch (err) {
                trace(err);
                continue;
            }
        }
        return defs;
    }
    #end

    static final definitions:Map<LocalDateString, {lastUpdate:Date, def:Dynamic}> = [];
    static public function getDefinitions(date:LocalDateString):Promise<DynamicAccess<Dynamic>> {
        // trace(date);
        final cachedDef = switch (definitions[date]) {
            case null:
                null;
            case {lastUpdate:lastUpdate, def:def} if (Date.now().getTime() - lastUpdate.getTime() <= DateTools.minutes(1)):
                def;
            case _:
                null;
        }
        if (cachedDef != null) {
            return Promise.resolve(cachedDef);
        }
        #if (!browser)
        return getItems(date)
            .then(items -> toDef(TimeSlotType.classify(date), items))
            .then(def -> {
                definitions[date] = {
                    lastUpdate: Date.now(),
                    def: def,
                };
                def;
            });
        #else
        return js.Browser.window.fetch('/menu/${BlackWindow}_${date.replace(" ", "_")}.json')
            .then(r -> if (r.ok) r.json() else throw r.status)
            .then(r -> {
                definitions[date] = {
                    lastUpdate: Date.now(),
                    def: r.definitions,
                };
                r.definitions;
            });
        #end
    }

    static function printNamePrice(item:{name:String, price:Float}):String {
        return item.name + " $" + item.price;
    }

    static public function itemsSchema(timeSlot:TimeSlot, order:FormOrderData):Promise<Dynamic> {
        function itemSchema():Promise<Dynamic>
            return BlackWindowMenu.getDefinitions(timeSlot.start)
                .then(defs -> {
                    final def:Dynamic = if (defs == null) {
                        title: "⚠️ 未有餐牌資料",
                        type: "string",
                        "enum": [],
                    } else if (defs.fields().length == 0) {
                        title: "⚠️ 冇食物供應",
                        type: "string",
                        "enum": [],
                    } else {
                        type: "object",
                        properties: {
                            type: {
                                title: "食物種類",
                                type: "string",
                                oneOf: [for (item => def in defs) {
                                    title: def.title,
                                    const: item,
                                }],
                            },
                        },
                        required: [
                            "type",
                        ],
                    }
                    def;
            });
        final items:Promise<Dynamic> = order.items == null || order.items.length == 0 ? itemSchema() : Promise.all(order.items.map(item -> {
            if (item != null && item.type != null) {
                itemSchema().then(itemSchema -> {
                    (cast item.type:BlackWindowItem).getDefinition(timeSlot)
                        .then(def -> {
                            if (def != null) {
                                Object.assign(itemSchema.properties, {
                                    item: def,
                                });
                                itemSchema.required.push("item");
                            }
                            itemSchema;
                        });
                });
            } else {
                itemSchema();
            }
        }));
        return itemSchema().then(itemSchema -> {
            items.then(items -> {
                type: "array",
                items: items,
                additionalItems: itemSchema,
                minItems: 1,
            });
        });
    }

    static function summarizeItem(orderItem:{
        ?type:BlackWindowItem,
        ?item:Dynamic,
    }, timeSlot:TimeSlot):Promise<{
        orderDetails:String,
        orderPrice:Float,
    }> {
        return orderItem.type.getDefinition(timeSlot).then(def -> {
            // trace(orderItem);
            // trace(def);
            if (def == null) {
                {
                    orderDetails: "",
                    orderPrice: 0.0,
                }
            } else switch (orderItem.type) {
                case Set:
                    summarizeOrderObject(orderItem.item, def, ["main", "soup", "snack", "drink"]);
                case Main:
                    summarizeOrderObject(orderItem.item, def, ["main", "drink"]);
                case Soup | Snack | Dessert | Drink | Beer | Coffee | Cocktail:
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
        });
    }

    static public function summarize(formData:FormOrderData, timeSlot:TimeSlot):Promise<OrderSummary> {
        return Promise.all(formData.items.map(item -> summarizeItem(cast item, timeSlot)))
            // .then(s -> {
            //     trace(s);
            //     s;
            // })
            .then(concatSummaries)
            .then(s -> {
                orderDetails: s.orderDetails,
                orderPrice: s.orderPrice,
                wantTableware: formData.wantTableware,
                customerNote: formData.customerNote,
            });
    }
}