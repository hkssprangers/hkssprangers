package hkssprangers.info.menu;

class HanaSoftCreamMenu {
    static public final HanaSoftCreamItem = {
        title: "HANA SOFT CREAM 產品",
        type: "string",
        "enum": [
            "特濃意大利黑朱古力雪糕 $28",
            "北海道8.0牛奶雪糕 $28",
            "意大利黑朱古力薄荷雪糕 $32",
            "意大利黑朱古力mocha雪糕 $32",
            "台灣黑芝麻雪糕 $34",
            "炭燒烏龍雪糕 $34",
            "泰國奶茶雪糕 $34",
            "伯爵茶雪糕 $34",
            "岡山白桃雪糕 $35",
            "榴槤雪糕 $42",

            "意大利脆皮波波雪糕(牛奶) $48",
            "意大利脆皮波波雪糕(黑朱古力) $48",
            // "意大利脆皮波波雪糕(曲奇) $48",
            // "意大利脆皮波波雪糕(薄荷) $48",

            // "家庭裝特濃意大利黑朱古力雪糕（約200克） $48",
            // "家庭裝北海道8.0牛奶雪糕（約200克） $48",
            "家庭裝意大利黑朱古力薄荷雪糕（約200克） $60",
            "家庭裝意大利黑朱古力mocha雪糕（約200克） $60",

            "8.0牛乳cookie’n cream 雪糕奶昔 $32",
            "8.0牛乳薄荷朱古力雪糕奶昔 $32",
            "8.0牛乳芒果雪糕奶昔 $32",
            "8.0牛乳士多啤梨雪糕奶昔 $32",
            "8.0牛乳咖啡雪糕奶昔 $32",
            "8.0山政小山園抹茶雪糕奶昔 $32",
            "8.0紫薯雪糕奶昔 $32",
            "芒果汁益力多 $26",

            // https://www.facebook.com/hanasoftcream/posts/pfbid09zG9zEHLdmiJjkS13BioQaJ55YF4yVrpSFT68Xd8jkSL8svuGmmxCG5HS6Mj9EpRl
            // "手工雪糕月餅一盒 (北海道8.0牛乳×2 意大利黑朱古力×2) $278",
            // "手工雪糕月餅一個(北海道8.0牛乳) $78",
            // "手工雪糕月餅一個(意大利黑朱古力) $78",
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