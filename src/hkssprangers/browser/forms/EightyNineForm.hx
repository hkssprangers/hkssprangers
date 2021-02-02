package hkssprangers.browser.forms;

import hkssprangers.info.Shop;
import mui.core.*;
using hkssprangers.info.TimeSlotTools;

class EightyNineForm extends ReactComponentOf<Dynamic, Dynamic> {
    final nextSlots = EightyNine.nextTimeSlots(Date.now());
    final schema:Dynamic;
    final uiSchema:Dynamic;

    static public final EightyNineItems = {
        type: "array",
        title: "揀食咩",
        items: {
            "$ref": "#/definitions/EightyNineSet"
        },
        minItems: 1,
    };
    static public final EightyNineItem = {
        type: "object",
        oneOf: [
            {
                "$ref": "#/definitions/EightyNineSet",
                title: "套餐: 主菜 + 配菜 + 絲苗白飯2個",
            },
        ]
    };
    static public final EightyNineSet = {
        title: "套餐",
        properties: {
            main: {
                title: "主菜選擇",
                type: "string",
                "enum": [
                    "香茅豬頸肉 - HK$85",
                    "招牌口水雞 (例) - HK$85",
                    "去骨海南雞 (例) - HK$85",
                    "招牌口水雞 (例) 拼香茅豬頸肉 - HK$98",
                    "去骨海南雞 (例) 拼香茅豬頸肉 - HK$98",
                ]
            },
            sub: {
                title: "配菜選擇",
                type: "string",
                "enum": [
                    "涼拌青瓜拼木耳",
                    "郊外油菜",
                ]
            },
            given: {
                title: "附送",
                type: "string",
                const: "絲苗白飯2個",
                "default": "絲苗白飯2個",
            }
        },
        required: [
            "main",
            "sub",
            "given",
        ]
    };

    function new(props, context):Void {
        super(props, context);
        schema = {
            type: "object",
            properties: {
                pickupTimeSlot: {
                    type: "string",
                    title: "想幾時收到?",
                    "enum": nextSlots.filter(s -> !s.isOff).map(s -> s.print()),
                },
                items: EightyNineItems,
            },
            required: [
                "pickupTimeSlot",
                "items",
            ],
            definitions: {
                EightyNineItem: EightyNineItem,
                EightyNineSet: EightyNineSet,
            },
        };
        uiSchema = {
            items: {
                items: {
                    given: {
                        "ui:readonly": true,
                    },
                },
                "ui:ArrayFieldTemplate": OrderItemsTemplate,
                "ui:options": {
                    orderable: false,
                },
            },
        }
    }

    function onSubmit(r:{formData:Dynamic}, e:ReactEvent) {

    }

    override function render():ReactFragment {
        return jsx('
            <OrderForm
                schema=${schema}
                uiSchema=${uiSchema}
                onSubmit=${onSubmit}
            />
        ');
    }
}