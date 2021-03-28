package hkssprangers.info;

import haxe.ds.ReadOnlyArray;

class MenuTools {
    static public function parsePrice(line:Null<String>):Float {
        var r = ~/\$([0-9\.]+)/;
        if (!r.match(line))
            return 0;
        return Std.parseFloat(r.matched(1));
    }

    static public function summarizeOrderObject(orderItem:{type:String, item:Dynamic}, def:{title:String, properties:Dynamic}, fields:ReadOnlyArray<String>):{
        orderDetails: String,
        orderPrice: Float,
    } {
        var orderDetails = [];
        var orderPrice = 0.0;
        for (fieldName in fields) {
            var fieldDef = Reflect.field(def.properties, fieldName);
            switch (fieldDef.type:String) {
                case "string":
                    var fieldVal:Null<String> = Reflect.field(orderItem.item, fieldName);
                    switch (fieldVal) {
                        case null: //pass
                        case v:
                            orderDetails.push('${def.title}: ${fieldDef.title}: ${v}');
                            orderPrice += parsePrice(v);
                    }
                case "array":
                    if (fieldDef.items.type != "string")
                        throw 'cannot proccess array of ${fieldDef.items.type}';
                    var fieldVal:Null<Array<String>> = Reflect.field(orderItem.item, fieldName);
                    switch (fieldVal) {
                        case null: //pass
                        case options:
                            for (opt in options) {
                                orderDetails.push('${def.title}: ${fieldDef.title}: ${opt}');
                                orderPrice += parsePrice(opt);
                            }
                    }
            }
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