package hkssprangers.info.menu;

class HanaSoftCreamMenu {
    static public final HanaSoftCreamItem = {
        title: "HANA SOFT CREAM 產品",
        type: "string",
        "enum": [
            "特濃意大利黑朱古力雪糕 $26",
            "北海道8.0牛奶雪糕 $26",
            "日本柚子雪糕 $26",
            // "波子汽水雪糕 $28",
            "伯爵茶雪糕 $27",
            "意大利脆皮波波雪糕(牛奶) $48",
            "意大利脆皮波波雪糕(黑朱古力) $48",
            "家庭裝特濃意大利黑朱古力雪糕300g $70",
            "家庭裝北海道8.0牛奶雪糕雪糕300g $70",
            "山梨縣桃8.0乳酪特飲 $38",
            "8.0青森蘋果乳酪特飲 $38",
            "8.0牛乳cookie’n cream 特飲 $32",
            "8.0牛乳薄荷朱古力特飲 $32",
            "8.0紫薯奶昔 $32",
        ]
    };

    static public function itemsSchema():Dynamic {
        return {
            type: "array",
            items:  HanaSoftCreamItem,
            minItems: 1,
        };
    }

    static function summarizeItem(orderItem:Null<String>):{
        orderDetails:String,
        orderPrice:Float,
    } {
        return switch (orderItem) {
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