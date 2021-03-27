package hkssprangers.info.menu;

class HanaSoftCreamMenu {
    static public final HanaSoftCreamItem = {
        title: "HANA SOFT CREAM 產品",
        type: "string",
        "enum": [
            "特濃意大利黑朱古力雪糕 $26",
            "北海道8.0牛奶雪糕 $26",
            "伯爵茶雪糕 $27",
            "日本柚子雪糕 $26",
            "北海道十勝紅豆雪糕 $27",
            "日本巨峰乳酪雪糕 $27",
            "百香果鳳梨味雪糕 $28",
            "水信玄餅 $20",
            "家庭裝特濃意大利黑朱古力雪糕300g $70",
            "家庭裝北海道8.0牛奶雪糕雪糕300g $70",
            "山梨縣桃8.0乳酪特飲 $42",
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
}