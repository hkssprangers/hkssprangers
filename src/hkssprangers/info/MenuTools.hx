package hkssprangers.info;

import global.moment.unitoftime._Date;
import haxe.ds.ReadOnlyArray;
using StringTools;
using hkssprangers.MathTools;

class MenuTools {
    static public function parsePrice(line:Null<String>):{
        item: String,
        price: Float,
    } {
        var r = ~/^(.*?)\s*\+?\$([0-9\.]+)/;
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

    static public function priceInDescription(fieldName:String, def:Dynamic):(fieldName:String, def:Dynamic)->{ ?title:String, ?value:String, ?price:Float } {
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

    inline static public final fullWidthSpace = "　";
    inline static public final fullWidthColon = "：";
    inline static public final fullWidthDot = "．";
    static public function summarizeOrderObject(
        orderItem:Dynamic,
        def:{title:String, ?description:String, properties:Dynamic},
        fields:ReadOnlyArray<String>,
        ?extra:ReadOnlyArray<String>,
        ?mapField:(fieldName:String, value:Dynamic)->{ ?title:String, ?value:String, ?price:Float },
        ?overrideTypeName:String
    ):{
        orderDetails: String,
        orderPrice: Float,
    } {
        final orderDetails = [];
        var orderPrice = parsePrice(def.title).price;
        function prefix() return
            if (overrideTypeName == null) {
                final maxTitleWidth = 6;
                if (orderDetails.length == 0)
                    fullWidthDot + def.title + (def.title.length > maxTitleWidth ? fullWidthColon + "\n" + fullWidthSpace : fullWidthColon);
                else
                    "".rpad(fullWidthSpace, def.title.length > maxTitleWidth ? 1 : def.title.length + 2);
            } else if (overrideTypeName != "") {
                if (orderDetails.length == 0)
                    fullWidthDot + overrideTypeName + fullWidthColon;
                else
                    "".rpad(fullWidthSpace, overrideTypeName.length + 2);
            } else {
                if (orderDetails.length == 0)
                    fullWidthDot;
                else
                    fullWidthSpace;
            }
        for (fieldName in fields) {
            var fieldDef = Reflect.field(def.properties, fieldName);

            // just ignore null, which can happen if we comment out a property in the json schema
            if (fieldDef == null)
                continue;

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
                                var hasOverridedPrice = f.price != null && Math.isFinite(f.price);
                                var price = hasOverridedPrice ? f.price : options.map(opt -> parsePrice(opt).price).sum();
                                
                                orderPrice += price;
                                var titlePad = "".rpad(fullWidthSpace, fieldTitle.length);
                                if (f.value == null) {
                                    for (i => opt in options) {
                                        var title = i == 0 ? fieldTitle : titlePad;
                                        orderDetails.push('${prefix()}${title}${opt}');
                                    }
                                    if (price != 0 && hasOverridedPrice)
                                        orderDetails.push('${prefix()}${titlePad}$$${price}');
                                } else {
                                    var price = price != 0 && hasOverridedPrice ? " $" + price : "";
                                    orderDetails.push('${prefix()}${fieldTitle}${f.value}${price}');
                                }
                            } else {
                                for (opt in options) {
                                    orderDetails.push('${prefix()}${fieldTitle}${opt}');
                                    orderPrice += parsePrice(opt).price;
                                }
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
        final orderDetails = [];
        var orderPrice = 0.0;
        for (o in summaries) {
            orderDetails.push(o.orderDetails);
            orderPrice += o.orderPrice;
        }
        final summary = {
            orderDetails: orderDetails.join("\n"),
            orderPrice: orderPrice,
        };
        // trace(summary);
        return summary;
    }

    inline static public function enums(obj:Dynamic):Array<String> return Reflect.field(obj, "enum");
}