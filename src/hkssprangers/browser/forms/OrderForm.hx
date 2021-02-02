package hkssprangers.browser.forms;

import haxe.Json;
import hkssprangers.info.TimeSlot;
import js.lib.Object;
import hkssprangers.info.Shop;
import js.npm.rjsf.material_ui.*;
import mui.core.*;
using hkssprangers.info.TimeSlotTools;

typedef OrderFormProps = {}
typedef OrderFormState = {
    final formData:{
        ?pickupTimeSlot:String,
        ?orders:Array<Dynamic>,
    };
}

class OrderForm extends ReactComponentOf<OrderFormProps, OrderFormState> {
    final nextSlots = EightyNine.nextTimeSlots(Date.now());
    function getSchema() return {
        type: "object",
        properties: {
            pickupTimeSlot: {
                type: "string",
                title: "想幾時收到?",
                oneOf: nextSlots.filter(s -> !s.isOff).map(s -> {
                    title: s.print(),
                    const: Json.stringify(s),
                }),
            },
            orders: {
                type: "array",
                items: {
                    "$ref": "#/definitions/Order"
                },
                minItems: 1,
            }
        },
        required: [
            "pickupTimeSlot",
            "orders",
        ],
        definitions: Object.assign({},
            {
                Order: {
                    properties: {
                        shop: {
                            type: "string",
                            title: "店舖",
                            oneOf: Shop.all.map(s -> {
                                type: "string",
                                title: s.info().name,
                                const: s,
                            }),
                        }
                    },
                    required: [
                        "shop",
                    ],
                    dependencies: {
                        shop: {
                            oneOf: Shop.all.map(s -> {
                                properties: {
                                    shop: {
                                        type: "string",
                                        title: "店舖",
                                        const: s,
                                    },
                                    items: {
                                        var ts = state.formData.pickupTimeSlot;
                                        if (ts == null) {
                                            {
                                                type: "array",
                                                items: {
                                                    type: "object",
                                                }
                                            };
                                        } else switch (s) {
                                            case DongDong:
                                                DongDongForm.itemsSchema(Json.parse(ts));
                                            case _:
                                                {
                                                    type: "array",
                                                    items: {
                                                        type: "object",
                                                    }
                                                };
                                        }
                                    },
                                },
                            }),
                        }
                    }
                },
            },
            DongDongForm.schemaDefinitions
        ),
    };

    function new(props, context):Void {
        super(props, context);
        state = {
            formData: {},
        };
    }

    function getUiSchema() return {
        orders: {
            "ui:ArrayFieldTemplate": OrdersTemplate,
            items:{
                //"ui:field": OrderField,
                items: {
                    "ui:ArrayFieldTemplate": OrderItemsTemplate,
                }
            }
        },
    }

    function onChange(e:{
        edit:Bool,
        formData:Dynamic,
        errors:Array<Dynamic>,
        errorSchema:Dynamic,
        idSchema:Dynamic,
        schema:Dynamic,
        uiSchema:Dynamic,
        ?status:String,
    }) {
        setState({
            formData: e.formData,
        });
    }

    override function render():ReactFragment {
        return jsx('
            <div className="container max-w-screen-md mx-4 p-4">
                <h1 className="text-center text-xl mb-2">
                    埗兵外賣表格
                </h1>
                <p className="text-sm text-gray-500">*必填項目</p>
                <Form
                    schema=${getSchema()}
                    uiSchema=${getUiSchema()}
                    formData=${state.formData}
                    onChange=${onChange}
                    liveOmit=${true}
                    omitExtraData=${true}
                >
                </Form>
                <pre>${haxe.Json.stringify(state.formData, null, "  ")}</pre>
            </div>
        ');
    }
}