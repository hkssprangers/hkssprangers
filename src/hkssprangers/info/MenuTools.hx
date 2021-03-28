package hkssprangers.info;

import haxe.ds.ReadOnlyArray;
using StringTools;

class MenuTools {
    static public function parsePrice(line:Null<String>):Float {
        var r = ~/\$([0-9\.]+)/;
        if (!r.match(line))
            return 0;
        return Std.parseFloat(r.matched(1));
    }

    inline static final fullWidthSpace = "　";
    inline static final fullWidthColon = "：";

    static public function summarizeOrderObject(orderItem:Dynamic, def:{title:String, properties:Dynamic}, fields:ReadOnlyArray<String>, ?extra:ReadOnlyArray<String>):{
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
                            orderDetails.push('${prefix()}${fieldTitle}${v}');
                            orderPrice += parsePrice(v);
                    }
                case "array":
                    if (fieldDef.items.type != "string")
                        throw 'cannot proccess array of ${fieldDef.items.type}';
                    var fieldVal:Null<Array<String>> = Reflect.field(orderItem, fieldName);
                    switch (fieldVal) {
                        case null: //pass
                        case options:
                            for (opt in options) {
                                orderDetails.push('${prefix()}${fieldTitle}${opt}');
                                orderPrice += parsePrice(opt);
                            }
                    }
                case type:
                    throw "Cannot handle " + type;
            }
        }
        if (extra != null)
            for (item in extra) {
                orderDetails.push('${prefix()}${item}');
                orderPrice += parsePrice(item);
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
}