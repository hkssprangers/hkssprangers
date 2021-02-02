package hkssprangers.browser.forms;

import haxe.Json;
import hkssprangers.info.TimeSlot;
import js.lib.Object;
import hkssprangers.info.Shop;
import js.npm.rjsf.material_ui.*;
import mui.core.*;
using hkssprangers.info.TimeSlotTools;
using Reflect;

typedef OrderFormProps = {}
typedef OrderFormState = {
    final formData:OrderFormData;
}

typedef OrderFormData = {
    ?pickupTimeSlot:String,
    ?orders:Array<OrderData>,
}

typedef OrderData = {
    ?shop:Shop,
    ?items:Array<Dynamic>,
}

class OrderForm extends ReactComponentOf<OrderFormProps, OrderFormState> {
    final nextSlots = EightyNine.nextTimeSlots(Date.now());
    static public function getSchema(nextSlots:Array<TimeSlot & {isOff:Bool}>, formData:OrderFormData) {
        var shopSchema = {
            type: "string",
            title: "店舖",
            oneOf: Shop.all.map(s -> {
                type: "string",
                title: s.info().name,
                const: s,
            }),
        };
        function orderSchema() return {
            type: "object",
            properties: {
                shop: shopSchema,
            },
            required: [
                "shop",
            ],
        };
        var schema = {
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
                    items: formData.orders == null ? [] : formData.orders.map(o -> {
                        var orderSchema = orderSchema();
                        switch (o.shop) {
                            case null:
                                //pass
                            case DongDong:
                                Object.assign(orderSchema.properties, {
                                    shop: shopSchema,
                                    items: {
                                        var ts = formData.pickupTimeSlot;
                                        if (ts == null) {
                                            {
                                                type: "array",
                                                items: {
                                                    type: "object",
                                                }
                                            };
                                        } else {
                                            DongDongForm.itemsSchema(Json.parse(ts), o);
                                        }
                                    },
                                });
                            case _:
                                //pass
                        }
                        orderSchema;
                    }),
                    additionalItems: orderSchema(),
                    minItems: 1,
                }
            },
            required: [
                "pickupTimeSlot",
                "orders",
            ],
            definitions: Object.assign(
                {},
                DongDongForm.schemaDefinitions
            ),
        };
        return schema;
    }

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
                items: {
                    "ui:ArrayFieldTemplate": OrderItemsTemplate,
                }
            }
        },
    }

    override function render():ReactFragment {
        var schema = getSchema(nextSlots, state.formData);

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
            // trace(e.formData);
            // Ajv.call({
            //     removeAdditional: "all"
            // }).compile(schema).call(e.formData);
            // trace(e.formData);
            setState({
                formData: e.formData,
            });
        }

        function onSubmit(e:{
            formData:Dynamic,
        }, _) {
            var isValid:Bool = Ajv.call({
                removeAdditional: "all",
            }).compile(schema).call(e.formData);
            trace(isValid);
            trace(Json.stringify(e.formData, null, "  "));
        }
        
        return jsx('
            <div className="container max-w-screen-md mx-4 p-4">
                <h1 className="text-center text-xl mb-2">
                    埗兵外賣表格
                </h1>
                <p className="text-sm text-gray-500">*必填項目</p>
                <Form
                    schema=${schema}
                    uiSchema=${getUiSchema()}
                    formData=${state.formData}
                    onChange=${onChange}
                    onSubmit=${onSubmit}
                >
                </Form>
                <pre>${haxe.Json.stringify(state.formData, null, "  ")}</pre>
            </div>
        ');
    }
}