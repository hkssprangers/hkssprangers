package hkssprangers.info;

import global.moment.unitoftime._Date;
import haxe.ds.ReadOnlyArray;
using StringTools;

class MenuTools {
    static public function parsePrice(line:Null<String>):{
        item: String,
        price: Float,
    } {
        var r = ~/^(.+?)\s*\+?\$([0-9\.]+)/;
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

    static public function priceInDescription(fieldName, def) {
        return (fn, value) -> if (fieldName == fn) {
            parsePrice(def.description).price;
        } else {
            0.0;
        }
    }

    inline static final fullWidthSpace = "　";
    inline static final fullWidthColon = "：";
    static public function summarizeOrderObject(orderItem:Dynamic, def:{title:String, ?description:String, properties:Dynamic}, fields:ReadOnlyArray<String>, ?extra:ReadOnlyArray<String>, ?fieldPrice:(fieldName:String, value:Dynamic)->Float):{
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
                            if (fieldPrice != null) switch (fieldPrice(fieldName, fieldVal)) {
                                case p if (p > 0):
                                    v += " $" + p;
                                case _:
                                    // pass
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
                            if (fieldPrice != null) switch (fieldPrice(fieldName, fieldVal)) {
                                case p if (p > 0):
                                    orderPrice += p;
                                    var titlePad = "".rpad(fullWidthSpace, fieldTitle.length);
                                    for (i => opt in options) {
                                        var title = i == 0 ? fieldTitle : titlePad;
                                        orderDetails.push('${prefix()}${title}${opt}');
                                    }
                                    orderDetails.push('${prefix()}${titlePad}$$${p}');
                                    continue;
                                case _:
                                    //pass
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