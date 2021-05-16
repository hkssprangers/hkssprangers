package hkssprangers.info;

import global.moment.unitoftime._Date;
import haxe.ds.ReadOnlyArray;
using StringTools;

class MenuTools {
    static public function parsePrice(line:Null<String>):{
        item: String,
        price: Float,
    } {
        var r = ~/^(.*)\s*\+?\$([0-9\.]+)/;
        return if (!r.match(line))
            {
                item: line,
                price: null,
            };
        else 
            {
                item: r.matched(1),
                price: Std.parseFloat(r.matched(2)),
            };
    }

    static public function priceInDescription(fieldName:String, def:Dynamic):(fieldName:String, def:Dynamic)->{ ?title:String, ?price:Float } {
        return (fn, value) -> {
            {
                price: if (fieldName == fn) {
                    parsePrice(def.description).price;
                } else {
                    null;
                },
            }
        };
    }

    inline static final fullWidthSpace = "　";
    inline static final fullWidthColon = "：";
    static public function summarizeOrderObject(orderItem:Dynamic, def:{title:String, ?description:String, properties:Dynamic}, fields:ReadOnlyArray<String>, ?extra:ReadOnlyArray<String>, ?mapField:(fieldName:String, value:Dynamic)->{ ?title:String, ?price:Float }):{
        orderDetails: String,
        orderPrice: Float,
    } {
        var orderDetails = [];
        var orderPrice = 0.0;
        function prefix() return if (orderDetails.length == 0)
            def.title + fullWidthColon;
        else
            "".rpad(fullWidthSpace, def.title.length + 1);
        for (fieldName in fields) {
            var fieldDef = Reflect.field(def.properties, fieldName);
            var fieldTitle = if (fieldDef.title == def.title)
                "";
            else
                fieldDef.title + fullWidthColon;
            switch (fieldDef.type:String) {
                case "string":
                    var fieldVal:Null<String> = Reflect.field(orderItem, fieldName);
                    switch (fieldVal) {
                        case null: //pass
                        case v:
                            if (mapField != null) {
                                var f = mapField(fieldName, fieldVal);
                                if (f.title != null)
                                    fieldTitle = f.title;
                                if (f.price != null && Math.isFinite(f.price))
                                    v += " $" + f.price;
                            }
                            orderDetails.push('${prefix()}${fieldTitle}${v}');
                            orderPrice += parsePrice(v).price;
                    }
                case "array":
                    if (fieldDef.items.type != "string")
                        throw 'cannot proccess array of ${fieldDef.items.type}';
                    var fieldVal:Null<Array<String>> = Reflect.field(orderItem, fieldName);
                    switch (fieldVal) {
                        case null: //pass
                        case options:
                            if (mapField != null) {
                                var f = mapField(fieldName, fieldVal);
                                if (f.title != null)
                                    fieldTitle = f.title;
                                if (f.price != null && Math.isFinite(f.price)) {
                                    orderPrice += f.price;
                                    var titlePad = "".rpad(fullWidthSpace, fieldTitle.length);
                                    for (i => opt in options) {
                                        var title = i == 0 ? fieldTitle : titlePad;
                                        orderDetails.push('${prefix()}${title}${opt}');
                                    }
                                    orderDetails.push('${prefix()}${titlePad}$$${f.price}');
                                    continue;
                                }
                            }
                            
                            for (opt in options) {
                                orderDetails.push('${prefix()}${fieldTitle}${opt}');
                                orderPrice += parsePrice(opt).price;
                            }
                    }
                case type:
                    throw "Cannot handle " + type;
            }
        }
        if (extra != null)
            for (item in extra) {
                orderDetails.push('${prefix()}${item}');
                orderPrice += parsePrice(item).price;
            }
        return {
            orderDetails: orderDetails.join("\n"),
            orderPrice: orderPrice,
        };
    }

    static public function concatSummaries(summaries:Array<{
        orderDetails: String,
        orderPrice: Float,
    }>):{
        orderDetails: String,
        orderPrice: Float,
    } {
        var orderDetails = [];
        var orderPrice = 0.0;
        for (o in summaries) {
            orderDetails.push(o.orderDetails);
            orderPrice += o.orderPrice;
        }
        return {
            orderDetails: orderDetails.join("\n"),
            orderPrice: orderPrice,
        };
    }

    inline static public function enums(obj:Dynamic):Array<String> return Reflect.field(obj, "enum");
}